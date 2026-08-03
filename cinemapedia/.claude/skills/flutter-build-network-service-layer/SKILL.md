---
name: flutter-build-network-service-layer
description: Design a NetworkService-style logic class that wraps Dio for a specific API — base config, interceptor composition order, retry policy, and error mapping — so datasources only deal with paths and payloads. Use when adding a client for a new API or reviewing an existing one.
---

# Building a Network Service Logic-Class

## Contents
- [What This Class Owns](#what-this-class-owns)
- [Reference Implementation in This Repo](#reference-implementation-in-this-repo)
- [Workflow: Adding a Service for a New API](#workflow-adding-a-service-for-a-new-api)
- [Design Rules](#design-rules)
- [Interceptor Composition Order](#interceptor-composition-order)
- [Error Mapping](#error-mapping)
- [Retry Policy](#retry-policy)
- [Examples](#examples)
- [Anti-Patterns to Avoid](#anti-patterns-to-avoid)

## What This Class Owns

A `NetworkService` is the single seam between "this app talks to API X" and everything above it (datasources, repositories). It owns:

1. **One `Dio` instance**, private, never leaked as a public field.
2. **Base config** — base URL, timeouts.
3. **Cross-cutting request behavior** via interceptors — auth/API-key injection, logging, retries.
4. **A thin, typed public surface** — `get`/`post`/`put`/`delete` (and any verb the API actually needs) that mirror Dio's signature closely enough that callers don't need to think about it, but return/throw *this app's* types, not Dio's.
5. **Error normalization** — every method funnels through one guarded path that turns `DioException` into a domain-safe exception.

It does **not** own: response-to-domain-model mapping (that's the datasource's/mapper's job), business logic, or UI-facing strings beyond a plain error message.

## Reference Implementation in This Repo

`lib/config/network/network_service.dart` wraps The Movie DB API:

```dart
class NetworkService {
  NetworkService({
    String baseUrl = _baseUrl,
    Map<String, dynamic> defaultQueryParameters = const {'language': 'es-MX'},
    int maxRetries = 3,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),
           sendTimeout: const Duration(seconds: 10),
         ),
       ) {
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters = {
            ...defaultQueryParameters,
            ...options.queryParameters,
            'api_key': Environment.theMovieDbKey,
          };
          return handler.next(options);
        },
      ),
      RetryInterceptor(dio: _dio, maxRetries: maxRetries),
      if (kDebugMode) LogInterceptor(requestBody: true),
    ]);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    return _guard(() => _dio.get<T>(path, queryParameters: queryParameters, options: options));
  }

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
```

Everything below generalizes this pattern for a *new* API client — copy the shape, not necessarily the specific interceptors.

## Workflow: Adding a Service for a New API

- [ ] 1. **Pick the base config.** Base URL, per-request timeouts appropriate to the API (10s is a reasonable default for a JSON REST API; raise it for endpoints known to be slow/large).
- [ ] 2. **Decide what every request needs injected.** API key, bearer token, tenant header, a fixed query param (locale, version) — write one `onRequest` interceptor that merges caller-supplied params with these defaults, with the injected values *last* in the merge so a caller can never accidentally override the API key by passing a colliding query key.
- [ ] 3. **Decide the retry policy.** Which HTTP methods are idempotent for this API (usually `GET`/`PUT`/`DELETE`, never a plain `POST` that isn't explicitly idempotent), which failure types are transient (timeouts, connection errors, 5xx), and a bounded backoff schedule. Reuse `RetryInterceptor` (`lib/config/network/retry_interceptor.dart`) if the policy fits; write a new one only if this API's retry semantics genuinely differ (e.g. it needs to respect a `Retry-After` header).
- [ ] 4. **Write the exception mapping.** One factory (`NetworkException.fromDioException` is the template) translating each `DioExceptionType` — and each meaningful HTTP status code — into a message safe to show a user, plus a machine-readable `statusCode`/`error` for logging. Do this once per API service, not once per call site.
- [ ] 5. **Add debug-only logging.** `if (kDebugMode) LogInterceptor(...)` — never ship request/response body logging to release builds (it can leak tokens/PII into device logs).
- [ ] 6. **Expose only the verbs the API needs**, typed with a generic `<T>`, each routed through one `_guard` helper — don't duplicate the try/catch per method.
- [ ] 7. **Register it as a singleton provider** (Riverpod `Provider<NetworkService>`, mirroring `network_service_provider.dart`) so every datasource sharing this API shares one `Dio` instance and interceptor chain.
- [ ] 8. **Feedback loop:** write one datasource method against it, hit a real (or mocked) endpoint, confirm the injected params/headers actually appear on the wire (`LogInterceptor` output) and that a forced failure (airplane mode, or a mock 500) comes back as the expected `NetworkException`, not a raw `DioException` leaking past `_guard`.

## Design Rules

- **One `Dio` per API, not per feature.** If the app talks to two different backends (e.g. TMDB + a first-party backend), that's two `NetworkService`-like classes with two base configs and two interceptor chains — don't overload one `Dio` instance with conditional logic for "which API is this."
- **Never rely on per-call `queryParameters` for anything security-sensitive.** Inject API keys/tokens in `onRequest`, unconditionally, so a call site can't forget it or, worse, hardcode it locally.
- **Keep the public method signatures Dio-shaped but Dio-opaque where it matters.** Accepting `Options`/`Map<String, dynamic>` is fine (low friction for callers); leaking `DioException` out of a public method is not.
- **Immutable construction.** Configure `baseUrl`/`defaultQueryParameters`/`maxRetries` via constructor parameters with sane defaults, not mutable public fields toggled after construction — a `NetworkService` instance's behavior shouldn't change out from under callers holding a reference to it.

## Interceptor Composition Order

Order matters — Dio runs `onRequest` interceptors in list order outbound, and unwinds `onResponse`/`onError` in the same order inbound. This repo's order is deliberate:

1. **Param/auth injection first** — so every later interceptor (including retry) sees a fully-formed request if it needs to replay it.
2. **Retry interceptor next** — it needs the finished request (with auth already attached) to `dio.fetch(options)` on replay.
3. **Logging last** — so logs reflect exactly what went over the wire, including injected params, and (in debug builds) the retry attempts.

If you add more cross-cutting concerns (response caching, a refresh-token-on-401 interceptor), place them by the same rule: request mutation before retry, side-effect-only observers (logging, analytics) last.

## Error Mapping

Map by `DioExceptionType` first, then refine `badResponse` by status code — this keeps the switch exhaustive and easy to extend:

```dart
switch (exception.type) {
  case DioExceptionType.connectionTimeout:
  case DioExceptionType.sendTimeout:
  case DioExceptionType.receiveTimeout:
  case DioExceptionType.transformTimeout:
    return NetworkException('The connection timed out, please try again.', error: exception);
  case DioExceptionType.connectionError:
    return NetworkException('Could not connect, please check your internet connection.', error: exception);
  case DioExceptionType.badResponse:
    return NetworkException(_messageForStatusCode(exception.response?.statusCode),
        statusCode: exception.response?.statusCode, error: exception);
  // ...
}
```

Keep the original `DioException`/stack trace on the mapped exception (`error: exception`) even though the message is user-safe — you still want it for crash reporting/logging.

## Retry Policy

`RetryInterceptor` (`lib/config/network/retry_interceptor.dart`) is the template: restrict to a fixed set of idempotent methods, restrict to transient error types (timeouts, connection errors, 5xx — never blanket-retry 4xx), cap attempts, and back off with increasing delays stored per-request in `options.extra` (so concurrent requests don't share retry state):

```dart
static const _retryableMethods = {'GET', 'PUT', 'DELETE', 'QUERY'};

bool _shouldRetry(DioException error) {
  final isRetryableMethod = _retryableMethods.contains(error.requestOptions.method.toUpperCase());
  final isTransientError = switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => true,
    DioExceptionType.badResponse => (error.response?.statusCode ?? 0) >= 500,
    _ => false,
  };
  return isRetryableMethod && isTransientError;
}
```

Never add `POST`/`PATCH` to the retryable set unless the specific endpoint is documented as idempotent (e.g. it takes a client-generated idempotency key) — a naive retry on a plain `POST` can double-submit.

## Examples

### Second API client alongside the existing one

```dart
class AuthApiService {
  AuthApiService({String baseUrl = _baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10))) {
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readAccessToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
      if (kDebugMode) LogInterceptor(requestBody: true),
    ]);
  }

  static const _baseUrl = 'https://auth.example.com';
  final Dio _dio;

  Future<Response<T>> post<T>(String path, {Object? data}) {
    return _guard(() => _dio.post<T>(path, data: data));
  }

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
```

Note this deliberately has **no** retry interceptor for auth endpoints where blind retries on `POST /login` would be unsafe by default — retry policy is a per-service decision, not a copy-pasted default.

## Anti-Patterns to Avoid

- **A `NetworkService` that returns raw `DioException`** from any public method — every path through the class must funnel through the same `_guard`.
- **Business/domain logic inside the service** (e.g. deciding which movies to filter out) — that belongs in the datasource/mapper, not here. Compare `network_service.dart` (pure transport) against `movie_db_datasource.dart` (JSON → domain mapping) for the split.
- **Retrying non-idempotent methods** or retrying 4xx client errors — both make failures worse (duplicate writes, hammering a rate-limited endpoint).
- **Logging response bodies outside `kDebugMode`** — treat `LogInterceptor(requestBody: true)` as a debug-only tool, never shipped to release.
- **A second, ad-hoc `Dio()` instantiated near a call site** "just for this one request" — it bypasses every interceptor above and is the single most common way an API key or retry policy silently goes missing.
