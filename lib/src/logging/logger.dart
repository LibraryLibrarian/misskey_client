import 'package_logger.dart';

/// A simple logger interface that can be swapped with a custom implementation.
abstract class Logger {
  /// Logs a debug-level [message].
  void debug(String message);

  /// Logs an info-level [message].
  void info(String message);

  /// Logs a warning-level [message].
  void warn(String message);

  /// Logs an error-level [message] with an optional [error] and [stackTrace].
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

/// A [Logger] implementation that writes to stdout via the package logger.
class StdoutLogger implements Logger {
  const StdoutLogger();

  @override
  void debug(String message) {
    clientLog.d(message);
  }

  @override
  void info(String message) {
    clientLog.i(message);
  }

  @override
  void warn(String message) {
    clientLog.w(message);
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (error != null || stackTrace != null) {
      clientLog.e(message, error: error, stackTrace: stackTrace);
    } else {
      clientLog.e(message);
    }
  }
}
