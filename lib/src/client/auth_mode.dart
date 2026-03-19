/// The authentication mode for a request.
enum AuthMode {
  /// Authentication required: raises an error if no token is available
  /// (default).
  ///
  /// Automatically injects the token (`i`) into the POST request body.
  required,

  /// Authentication optional: attaches the token if available, but still sends
  /// the request without one.
  ///
  /// For endpoints that work unauthenticated but return extra fields
  /// (e.g. `isFollowing`, `isFavorited`) when authenticated.
  optional,

  /// No authentication: never attaches a token.
  ///
  /// For endpoints that do not require authentication and where sending a
  /// token would be inappropriate.
  none,
}
