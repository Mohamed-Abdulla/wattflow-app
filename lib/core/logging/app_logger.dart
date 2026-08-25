import 'dart:developer' as developer;

abstract interface class AppLogger {
  void info(
    String message, {
    String? feature,
    String? operation,
    String? requestId,
  });
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? feature,
    String? operation,
    String? requestId,
  });
}

final class DevelopmentLogger implements AppLogger {
  const DevelopmentLogger();
  @override
  void info(
    String message, {
    String? feature,
    String? operation,
    String? requestId,
  }) => developer.log(
    _format(message, feature, operation, requestId),
    name: 'WattFlow',
  );
  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? feature,
    String? operation,
    String? requestId,
  }) => developer.log(
    _format(message, feature, operation, requestId),
    name: 'WattFlow',
    error: error,
    stackTrace: stackTrace,
  );
  String _format(
    String message,
    String? feature,
    String? operation,
    String? requestId,
  ) {
    final context = [
      if (feature != null) 'feature=$feature',
      if (operation != null) 'operation=$operation',
      if (requestId != null) 'requestId=$requestId',
    ].join(' ');
    return context.isEmpty ? message : '[$context] $message';
  }
}
