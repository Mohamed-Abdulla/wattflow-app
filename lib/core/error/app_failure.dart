sealed class AppFailure implements Exception {
  const AppFailure(this.message, {this.technicalDetails});
  final String message;
  final String? technicalDetails;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([String? details])
    : super(
        'Unable to connect. Check your internet connection.',
        technicalDetails: details,
      );
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure() : super('The request timed out. Please try again.');
}

final class ServerFailure extends AppFailure {
  const ServerFailure([String? details])
    : super(
        'The service is temporarily unavailable.',
        technicalDetails: details,
      );
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure()
    : super('Your session has expired. Please sign in again.');
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure() : super('The requested device could not be found.');
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure([String? details])
    : super(
        'Something went wrong. Please try again.',
        technicalDetails: details,
      );
}
