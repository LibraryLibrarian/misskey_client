/// Dart環境でのビルドモード検出用定数
library;

/// リリースモードかどうかを示す定数
const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

/// デバッグモードかどうかを示す定数
const bool kDebugMode = !kReleaseMode;
