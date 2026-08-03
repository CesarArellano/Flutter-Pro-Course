import 'package:dio/dio.dart';

class NetworkException implements Exception {
  factory NetworkException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return NetworkException(
          'The connection timed out, please try again.',
          error: exception,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          'Could not connect, please check your internet connection.',
          error: exception,
        );
      case DioExceptionType.cancel:
        return NetworkException('The request was cancelled.', error: exception);
      case DioExceptionType.badCertificate:
        return NetworkException(
          'The server certificate could not be verified.',
          error: exception,
        );
      case DioExceptionType.badResponse:
        return NetworkException(
          _messageForStatusCode(exception.response?.statusCode),
          statusCode: exception.response?.statusCode,
          error: exception,
        );
      case DioExceptionType.unknown:
        return NetworkException(
          'Something unexpected happened, please try again.',
          error: exception,
        );
    }
  }
  const NetworkException(this.message, {this.statusCode, this.error});

  final String message;
  final int? statusCode;
  final Object? error;

  static String _messageForStatusCode(int? statusCode) {
    return switch (statusCode) {
      400 => 'Bad request.',
      401 => 'Invalid or missing API key.',
      403 => 'Access to this resource is denied.',
      404 => 'The requested resource was not found.',
      429 => 'Too many requests, please slow down.',
      _ when statusCode != null && statusCode >= 500 =>
        'Server error, please try again later.',
      _ => 'Unexpected error${statusCode != null ? ' ($statusCode)' : ''}.',
    };
  }

  @override
  String toString() => 'NetworkException: $message';
}
