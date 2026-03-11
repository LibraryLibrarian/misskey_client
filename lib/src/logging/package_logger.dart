import 'package:logger/logger.dart' as pkg;

import '../client/constants.dart';

/// misskey_clientライブラリ共通のロガーを提供
///
/// - デバッグビルド: 詳細ログ（debug/trace）を出力
/// - リリースビルド: 警告以上のみ出力（大量ログを抑制）
final pkg.Logger clientLog = pkg.Logger(
  level: kReleaseMode ? pkg.Level.warning : pkg.Level.debug,
  printer: _CustomLogPrinter(),
);

/// カスタムログプリンター
///
/// 出力形式: `[misskey_client] [LEVEL] YYYY-MM-DD HH:MM:SS.ffffff メッセージ`
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
