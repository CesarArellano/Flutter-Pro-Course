import 'package:dio/dio.dart';

/// Resends a failed request when the failure looks transient (timeouts,
/// connection errors, 5xx) and the HTTP method is safe to repeat.
///
/// Retries are capped at [maxRetries] and only apply to idempotent methods,
/// so a POST that already reached the server is never resent automatically.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
  });

  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  static const _retryableMethods = {'GET', 'PUT', 'DELETE', 'QUERY'};
  static const _retryCountKey = 'retry_count';

  bool _shouldRetry(DioException error) {
    final isRetryableMethod = _retryableMethods.contains(
      error.requestOptions.method.toUpperCase(),
    );

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

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final retryCount = (options.extra[_retryCountKey] as int?) ?? 0;

    if (!_shouldRetry(err) || retryCount >= maxRetries) {
      return handler.next(err);
    }

    options.extra[_retryCountKey] = retryCount + 1;

    final delay = retryCount < retryDelays.length
        ? retryDelays[retryCount]
        : retryDelays.last;
    await Future.delayed(delay);

    try {
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
