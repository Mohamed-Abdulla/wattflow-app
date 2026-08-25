import 'dart:io';
import 'package:dio/dio.dart';
import '../error/app_failure.dart';
import '../logging/app_logger.dart';

final class ApiClient {
  ApiClient({required AppLogger logger, String? baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl:
            baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'https://api.example.com',
            ),
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {Headers.acceptHeader: Headers.jsonContentType},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final requestId = options.headers['X-Request-ID'] ?? _requestId();
          options.headers['X-Request-ID'] = requestId;
          logger.info(
            '${options.method} ${options.path}',
            feature: 'network',
            operation: 'request',
            requestId: requestId.toString(),
          );
          handler.next(options);
        },
        onError: (error, handler) {
          logger.error(
            'HTTP request failed',
            error: error.error,
            feature: 'network',
            operation: 'response',
            requestId: error.requestOptions.headers['X-Request-ID']?.toString(),
          );
          handler.next(error);
        },
      ),
    );
  }
  late final Dio dio;
  static String _requestId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Object().hashCode}';
  static AppFailure mapError(Object error) {
    if (error is DioException) {
      if ([
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ].contains(error.type)) {
        return const TimeoutFailure();
      }
      final status = error.response?.statusCode;
      if (status == HttpStatus.unauthorized) return const UnauthorizedFailure();
      if (status == HttpStatus.notFound) return const NotFoundFailure();
      if (status != null && status >= 500) return ServerFailure(error.message);
      if (error.type == DioExceptionType.connectionError) {
        return NetworkFailure(error.message);
      }
    }
    return UnexpectedFailure(error.toString());
  }
}
