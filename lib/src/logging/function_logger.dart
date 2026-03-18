import 'logger.dart';

/// A lightweight adapter that wraps a callback function as a [Logger].
class FunctionLogger implements Logger {
  const FunctionLogger(this._fn);
  final void Function(String level, String message) _fn;

  @override
  void debug(String message) => _fn('debug', message);

  @override
  void info(String message) => _fn('info', message);

  @override
  void warn(String message) => _fn('warn', message);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    final m = error == null ? message : '$message error=$error';
    _fn('error', m);
  }
}
