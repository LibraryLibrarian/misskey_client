import 'package:logger/web.dart' as pkg;

import '../client/constants.dart';

/// Provides the shared logger instance for the misskey_client library.
///
/// The level is `debug` outside release builds and `warning` in release
/// builds, but the package's default `DevelopmentFilter` only lets logs
/// through while assertions are enabled (debug builds). With assertions
/// disabled, as in release builds, nothing is output.
final pkg.Logger clientLog = pkg.Logger(
  level: kReleaseMode ? pkg.Level.warning : pkg.Level.debug,
  printer: _CustomLogPrinter(),
);

/// Custom log printer.
///
/// Format: `[misskey_client] [LEVEL] YYYY-MM-DD HH:MM:SS.ffffff message`
class _CustomLogPrinter extends pkg.LogPrinter {
  static final Map<pkg.Level, String> _levelLabels = {
    pkg.Level.trace: 'TRACE',
    pkg.Level.debug: 'DEBUG',
    pkg.Level.info: 'INFO',
    pkg.Level.warning: 'WARNING',
    pkg.Level.error: 'ERROR',
    pkg.Level.fatal: 'FATAL',
  };

  @override
  List<String> log(pkg.LogEvent event) {
    final level = _levelLabels[event.level] ?? 'UNKNOWN';
    final time = DateTime.now().toString();
    final message = event.message;

    return ['[misskey_client] [$level] $time $message'];
  }
}
