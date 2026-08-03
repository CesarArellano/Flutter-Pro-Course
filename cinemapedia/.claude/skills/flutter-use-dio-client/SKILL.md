---
name: flutter-use-dio-client
description: Use the Dio HTTP client correctly in this project — through the NetworkService wrapper, not directly from datasources — covering requests, query params, cancellation, uploads/downloads, and error handling.
---

# Using Dio in This Project

## Contents
- [Rule: Datasources Never Touch Dio Directly](#rule-datasources-never-touch-dio-directly)
- [Making Requests](#making-requests)
- [Cancellation](#cancellation)
- [Uploads and Downloads](#uploads-and-downloads)
- [Error Handling](#error-handling)
- [Testing Code That Uses Dio](#testing-code-that-uses-dio)
- [Do Not](#do-not)

This repo already has a configured `Dio` instance behind `lib/config/network/network_service.dart` (`NetworkService`), exposed via `networkServiceProvider` (`lib/presentation/providers/network/network_service_provider.dart`). Building the *wrapper itself* is covered by `flutter-build-network-service-layer` — this skill is about calling it correctly day to day.

## Rule: Datasources Never Touch Dio Directly

`MovieDbDatasource` (`lib/infrastructure/datasources/movie_db_datasource.dart`) depends on `NetworkService`, never on `Dio`:

```dart
class MovieDbDatasource implements MoviesDatasource {
  MovieDbDatasource(this.networkService);
  final NetworkService networkService;

  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await networkService.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }
}
```

Any new datasource follows the same shape: constructor-inject `NetworkService`, call `.get`/`.post`/`.put`/`.delete`/`.query`, and let it throw `NetworkException` — never construct a second `Dio()` instance or import `package:dio/dio.dart` inside a datasource. A second `Dio` instance means a second, un-audited copy of the API key injection, retry policy, and timeouts.

## Making Requests

```dart
// GET with query params — base URL, api_key, and language are already injected by NetworkService
final response = await networkService.get('/movie/now_playing', queryParameters: {'page': page});

// POST with a body
final response = await networkService.post('/some/endpoint', data: {'field': value});

// Typed response — pass the generic through when the caller can consume Response<T> directly
final response = await networkService.get<Map<String, dynamic>>('/movie/$id');
```

`response.data` for a JSON endpoint through this stack is already a decoded `Map<String, dynamic>` (or `List`) — Dio's default `ResponseType.json` transformer handles decoding, so don't call `jsonDecode` on it again.

## Cancellation

Pass a `CancelToken` via `Options` for requests tied to a widget/search box lifecycle (e.g. debounced search-as-you-type, or a request that should die when the user navigates away):

```dart
final cancelToken = CancelToken();

final response = await networkService.get(
  '/search/movie',
  queryParameters: {'query': query},
  options: Options(),
).catchError((e) {
  if (CancelToken.isCancel(e)) return null; // swallow intentional cancellation
  throw e;
});

// on dispose / on next keystroke:
cancelToken.cancel('superseded by newer search');
```

`NetworkService`'s public methods don't currently accept a `CancelToken` parameter directly — if a call site needs one, extend the relevant method signature to accept `CancelToken? cancelToken` and forward it into the underlying `_dio.get(...)` call rather than bypassing `NetworkService` to get access to Dio's `cancelToken`.

## Uploads and Downloads

Not currently used in this app (read-only movie API), but if a feature needs them:

- **Multipart upload:** build a `dio.FormData.fromMap({...})` and pass it as `data` to `NetworkService.post`; add a field via `MultipartFile.fromFile(path, filename: ...)` for binary parts.
- **File download:** Dio's `download()` isn't exposed on `NetworkService` today — add a dedicated method there (mirroring the existing `get`/`post` shape, routed through `_guard`) rather than reaching into a raw `Dio()` for one call site.

## Error Handling

Every `NetworkService` method already funnels `DioException` into `NetworkException` (see `network_exceptions.dart`). At call sites (repositories, providers), catch `NetworkException`, not `DioException`:

```dart
try {
  final movies = await moviesRepository.getPopular();
} on NetworkException catch (e) {
  // e.message is already a user-safe, localized-ready string
  // e.statusCode is available for bad-response cases
}
```

Don't add a second `try`/`on DioException` block downstream of `NetworkService` — by the time a caller sees the error, it has already been normalized.

## Testing Code That Uses Dio

- Don't hit the real API in unit tests. Inject a `Dio` configured with `DioAdapter` (from `package:http_mock_adapter` or `package:dio_test`) or provide `NetworkService` a fake `baseUrl` pointed at a local mock server.
- If `NetworkService` grows a constructor parameter for injecting a pre-built `Dio` (useful for tests), keep the production default (`Dio(BaseOptions(...))`) so app code doesn't need to change.
- For datasource/repository tests, mock at the `NetworkService`/`MoviesDatasource` boundary (see `dart-generate-test-mocks`) rather than mocking `Dio` itself — that keeps tests decoupled from HTTP client internals.

## Do Not

- Don't instantiate `Dio()` outside `network_service.dart`.
- Don't add `api_key`/auth headers at a call site — that's `NetworkService`'s `onRequest` interceptor's job; a call-site override risks shipping a request without it.
- Don't catch `DioException` outside `NetworkService._guard` — catch the mapped `NetworkException` instead.
- Don't disable timeouts or retries per-call by reaching around `NetworkService` — change the shared config if the policy genuinely needs to differ.
