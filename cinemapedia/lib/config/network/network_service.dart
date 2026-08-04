import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/environment.dart';
import 'network_exceptions.dart';
import 'retry_interceptor.dart';

/// Thin wrapper around a configured [Dio] instance for The Movie DB API.
///
/// Centralizes the base URL, the `api_key` query parameter, error mapping to
/// [NetworkException] and automatic retries, so datasources only deal with
/// paths and payloads.
class NetworkService {
  NetworkService({
    required Map<String, dynamic> defaultQueryParameters,
    String baseUrl = _baseUrl,
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
          // Always injected here (never relying on per-call queryParameters)
          // so no request can accidentally go out without a valid api_key.
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

  static const _baseUrl = 'https://api.themoviedb.org/3';

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guard(
      () =>
          _dio.get<T>(path, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guard(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guard(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guard(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  /// HTTP QUERY — a safe, idempotent GET-with-body, useful for complex
  /// filters that don't fit cleanly in a query string.
  Future<Response<T>> query<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guard(
      () => _dio.query<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
