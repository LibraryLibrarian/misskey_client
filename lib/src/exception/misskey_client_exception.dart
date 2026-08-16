/// Base class for all exceptions thrown by the Misskey API client.
sealed class MisskeyClientException implements Exception {
  const MisskeyClientException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// An exception representing an HTTP response error.
///
/// Contains the HTTP [statusCode] and the error [message] returned by the
/// server.
class MisskeyApiException extends MisskeyClientException {
  const MisskeyApiException({
    required this.statusCode,
    required String message,
    this.code,
    this.errorId,
    this.endpoint,
    this.raw,
  }) : super(message);

  final int statusCode;

  /// Misskey-specific error code (e.g. `AUTHENTICATION_FAILED`).
  final String? code;

  /// UUID identifying the Misskey error type.
  final String? errorId;

  /// The API endpoint where the error occurred.
  final String? endpoint;

  /// The underlying exception or raw error object.
  final Object? raw;

  @override
  String toString() =>
      '$runtimeType($statusCode): $message'
      '${code != null ? ' code=$code' : ''}'
      '${endpoint != null ? ' endpoint=$endpoint' : ''}';
}

/// Authentication error (HTTP 401).
///
/// Thrown when the access token is invalid or expired.
class MisskeyUnauthorizedException extends MisskeyApiException {
  const MisskeyUnauthorizedException({
    super.message = 'Unauthorized',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 401);
}

/// Authorization error (HTTP 403).
///
/// Thrown when the requested operation is not permitted.
class MisskeyForbiddenException extends MisskeyApiException {
  const MisskeyForbiddenException({
    super.message = 'Forbidden',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 403);
}

/// Resource not found (HTTP 404).
class MisskeyNotFoundException extends MisskeyApiException {
  const MisskeyNotFoundException({
    super.message = 'Not found',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 404);
}

/// Rate limit error (HTTP 429).
///
/// Thrown when the request rate exceeds the server's limit.
class MisskeyRateLimitException extends MisskeyApiException {
  const MisskeyRateLimitException({
    super.message = 'Rate limited',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
    this.retryAfter,
  }) : super(statusCode: 429);

  /// The server-suggested retry delay.
  final Duration? retryAfter;
}

/// Validation error (HTTP 422).
///
/// Thrown when the request body is invalid.
class MisskeyValidationException extends MisskeyApiException {
  const MisskeyValidationException({
    super.message = 'Unprocessable entity',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  }) : super(statusCode: 422);
}

/// Server error (HTTP 5xx).
class MisskeyServerException extends MisskeyApiException {
  const MisskeyServerException({
    required super.statusCode,
    super.message = 'Server error',
    super.code,
    super.errorId,
    super.endpoint,
    super.raw,
  });
}

/// Network connectivity error (timeout, connection refused, etc.).
class MisskeyNetworkException extends MisskeyClientException {
  const MisskeyNetworkException({
    String message = 'Network error',
    this.endpoint,
    this.cause,
  }) : super(message);

  /// The API endpoint where the error occurred.
  final String? endpoint;

  /// The underlying exception that caused this error.
  final Object? cause;
}

/// Base class for exceptions thrown by the Misskey Streaming API client.
sealed class MisskeyStreamingException extends MisskeyClientException {
  const MisskeyStreamingException({
    required String message,
    this.cause,
    this.stackTrace,
    this.operation,
    this.context,
  }) : super(message);

  /// The underlying exception that caused this error.
  final Object? cause;

  /// The stack trace associated with [cause].
  final StackTrace? stackTrace;

  /// The streaming operation that failed.
  final String? operation;

  /// Additional structured information about the failure.
  final Map<String, Object?>? context;

  @override
  String toString() =>
      '${super.toString()}'
      '${operation != null ? ' operation=$operation' : ''}';
}

/// An exception thrown when a Streaming API connection fails.
final class MisskeyStreamingConnectionException
    extends MisskeyStreamingException {
  const MisskeyStreamingConnectionException({
    super.message = 'Streaming connection failed',
    super.cause,
    super.stackTrace,
    super.operation,
    super.context,
  });
}

/// An exception thrown when a Streaming API operation times out.
final class MisskeyStreamingTimeoutException extends MisskeyStreamingException {
  const MisskeyStreamingTimeoutException({
    super.message = 'Streaming operation timed out',
    super.cause,
    super.stackTrace,
    super.operation,
    super.context,
    this.timeout,
  });

  /// The timeout used by the failed operation.
  final Duration? timeout;
}

/// An exception thrown for an invalid Streaming API message or state.
final class MisskeyStreamingProtocolException
    extends MisskeyStreamingException {
  const MisskeyStreamingProtocolException({
    super.message = 'Invalid Streaming API protocol message',
    super.cause,
    super.stackTrace,
    super.operation,
    super.context,
  });
}

/// An exception thrown when a Streaming API subscription fails.
final class MisskeyStreamingSubscriptionException
    extends MisskeyStreamingException {
  const MisskeyStreamingSubscriptionException({
    super.message = 'Streaming subscription failed',
    super.cause,
    super.stackTrace,
    super.operation,
    super.context,
  });
}
