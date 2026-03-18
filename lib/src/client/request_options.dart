import 'auth_mode.dart';

/// Per-request options (internal use).
class RequestOptions {
  /// Creates per-request options.
  ///
  /// [authMode] controls token injection (default: [AuthMode.required]).
  /// Set [idempotent] to `true` to enable automatic retries for this request
  /// (default: `false`). Use [contentType] to override the Content-Type header;
  /// Dio infers it automatically when omitted. Supply [headers] to attach
  /// additional headers specific to this request.
  const RequestOptions({
    this.authMode = AuthMode.required,
    this.idempotent = false,
    this.contentType,
    this.headers = const {},
  });

  /// The authentication mode for this request.
  ///
  /// Use [AuthMode.required] to always inject the token,
  /// [AuthMode.optional] to inject it only when available,
  /// or [AuthMode.none] to never inject the token.
  final AuthMode authMode;

  /// Whether this request is idempotent.
  ///
  /// Only idempotent requests are eligible for automatic retries.
  final bool idempotent;

  /// Explicitly sets the Content-Type for this request.
  ///
  /// When omitted, Dio infers the Content-Type automatically.
  final String? contentType;

  /// Additional headers specific to this request.
  final Map<String, String> headers;
}
