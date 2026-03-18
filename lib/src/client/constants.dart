/// Constants for detecting the Dart build mode.
library;

/// Whether the app is running in release mode.
const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

/// Whether the app is running in debug mode.
const bool kDebugMode = !kReleaseMode;
