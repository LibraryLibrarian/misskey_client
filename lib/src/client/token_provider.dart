import 'dart:async';

/// A function type that provides an authorization token.
///
/// Returns `FutureOr<String?>` to support both synchronous and asynchronous
/// token retrieval.
typedef TokenProvider = FutureOr<String?> Function();
