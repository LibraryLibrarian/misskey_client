[English](README.md) | 日本語 | [简体中文](README.zh-Hans.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [한국어](README.ko.md)

# misskey_client

[Misskey](https://misskey-hub.net/) API 向けの pure Dart クライアントライブラリ。APIへの型付きアクセスを提供し、認証・リトライ・構造化されたエラーハンドリングを内蔵。

> **ベータ版**: API実装は完了していますが、テストカバレッジは最小限です。テスト結果に基づき、レスポンスモデルやメソッドシグネチャが変更される可能性があります。詳細は [CHANGELOG](CHANGELOG.md) を参照してください。

## 特徴

- MisskeyAPIドメインをカバー（ノート、ドライブ、ユーザー、チャンネル、チャットなど）
- 最大リトライ回数を設定可能な自動リトライ試行
- 網羅的なエラーハンドリングのための sealed 例外クラス階層
- `json_serializable` で生成された厳密に型付けされたリクエスト・レスポンスモデル
- 差し替え可能な `Logger` インターフェースによる柔軟なロギング
- pure Dart — Flutter への依存なし

## インストール

`pubspec.yaml` にパッケージを追加してください：

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.5
```

その後、以下を実行します：

```
dart pub get
```

## クイックスタート

```dart
import 'package:misskey_client/misskey_client.dart';

void main() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      timeout: Duration(seconds: 10),
      maxRetries: 3,
    ),
    // アクセストークンを提供します。コールバックは非同期も可能です。
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  );

  // 認証済みユーザーのノートを取得
  final notes = await client.notes.getTimeline();
  for (final note in notes) {
    print(note.text);
  }
}
```

## API 概要

`MisskeyClient` は以下のプロパティを公開しており、それぞれが Misskey API の異なる領域をカバーしています：

| プロパティ | 説明 |
|---|---|
| `account` | アカウント・プロフィール管理、レジストリ、二段階認証、Webhook |
| `announcements` | サーバーのお知らせ |
| `antennas` | アンテナ（キーワードベースのフィード）管理 |
| `ap` | ActivityPub ユーティリティ |
| `blocking` | ユーザーのブロック |
| `channels` | チャンネルとチャンネルミュート |
| `charts` | 統計チャート |
| `chat` | チャットルームとメッセージ |
| `clips` | クリップコレクション |
| `drive` | ドライブ（ファイルストレージ）、ファイル、フォルダ、統計 |
| `federation` | 連合インスタンス情報 |
| `flash` | Flash（Play）スクリプト |
| `following` | フォローとフォローリクエスト |
| `gallery` | ギャラリー投稿 |
| `hashtags` | ハッシュタグ検索とトレンド |
| `invite` | 招待コード |
| `meta` | サーバーメタデータ |
| `mute` | ユーザーのミュート |
| `notes` | ノート、リアクション、投票、検索、タイムライン |
| `notifications` | 通知 |
| `pages` | ページ |
| `renoteMute` | リノートミュート |
| `roles` | ロールの割り当て |
| `sw` | プッシュ通知（Service Worker） |
| `users` | ユーザー検索、リスト、関係、アチーブメント |

## 認証

クライアント構築時に `TokenProvider` コールバックを渡します。コールバックは `FutureOr<String?>` を返すため、同期・非同期の両方のトークンソースに対応しています：

```dart
// 同期トークン
final client = MisskeyClient(
  config: config,
  tokenProvider: () => secureStorage.readSync('token'),
);

// 非同期トークン
final client = MisskeyClient(
  config: config,
  tokenProvider: () async => await secureStorage.read('token'),
);
```

認証が必要なエンドポイントはトークンを自動的に付与します。任意認証のエンドポイントはトークンが利用可能な場合に付与します。

## エラーハンドリング

すべての例外は sealed クラス `MisskeyClientException` を継承しており、網羅的なパターンマッチングが可能です：

```dart
try {
  final user = await client.users.show(userId: 'abc123');
} on MisskeyUnauthorizedException {
  // 401 — トークンが無効または存在しない
} on MisskeyForbiddenException {
  // 403 — 操作が許可されていない
} on MisskeyNotFoundException {
  // 404 — リソースが見つからない
} on MisskeyRateLimitException catch (e) {
  // 429 — レート制限; e.retryAfter を確認
} on MisskeyValidationException {
  // 422 — リクエストボディが無効
} on MisskeyServerException {
  // 5xx — サーバー側エラー
} on MisskeyNetworkException {
  // タイムアウト、接続拒否など
}
```

## ロギング

`MisskeyClientConfig.enableLog` で組み込みの stdout ロガーを有効にするか、カスタムの `Logger` 実装を渡すことができます：

```dart
class MyLogger implements Logger {
  @override void debug(String message) { /* ... */ }
  @override void info(String message)  { /* ... */ }
  @override void warn(String message)  { /* ... */ }
  @override void error(String message, [Object? error, StackTrace? stackTrace]) { /* ... */ }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(baseUrl: Uri.parse('https://misskey.example.com')),
  logger: MyLogger(),
);
```

## misskey_api_core からの移行

### API 対応表

| misskey_api_core | misskey_client |
|---|---|
| `MisskeyHttpClient(config: ..., tokenProvider: ...)` | `MisskeyClient(config: ..., tokenProvider: ...)` |
| `MisskeyApiConfig(baseUrl: ...)` | `MisskeyClientConfig(baseUrl: ...)` |
| `http.send<T>('/emojis', ...)` | 対応する型付きメソッド（例：`client.meta.getEmojis()`） |
| `MetaClient(http).getMeta()` | `client.meta.getMeta()` |
| `MisskeyApiException` | `MisskeyApiException`、`MisskeyUnauthorizedException`、`MisskeyForbiddenException`、`MisskeyRateLimitException` などを含む sealed 階層 |
| `RequestOptions(authRequired: false)` | 型付きメソッドが内部で処理するため、利用側の指定は不要 |
| `Logger` / `FunctionLogger` | 同名クラス |
| `kReleaseMode` / `kDebugMode` | 公開 API に含めない（下記参照） |

### MisskeyApiException の名前衝突

両パッケージに `MisskeyApiException` が存在しますが、内容も継承関係も異なります。`misskey_api_core` 版は単純なクラスである一方、`misskey_client` 版は `MisskeyClientException` を継承し、`statusCode` が必須です。移行中に両方のパッケージを import する場合は、接頭辞を付けて衝突を回避してください：

```dart
import 'package:misskey_api_core/misskey_api_core.dart' as core;
```

### ビルドモード定数

`misskey_api_core` は `kReleaseMode` と `kDebugMode` を export していましたが、`misskey_client` の公開 API には含めません。これらは Misskey とは無関係な汎用ユーティリティです。Flutter アプリでは `package:flutter/foundation.dart` の定数を、pure Dart では `bool.fromEnvironment('dart.vm.product')` を使用してください。ログ出力は `MisskeyClientConfig.enableLog` で制御し、たとえば `enableLog: kDebugMode` のように渡します。

### 低レベル HTTP アクセス

`MisskeyHttpClient.send<T>()` に相当する低レベル API は公開しません。`misskey_client` は25の API ドメインを網羅しているため、型付きメソッドを使用してください。必要なエンドポイントが未実装の場合は、型付き API に追加できるよう GitHub issue で報告してください。

## ドキュメント

- API リファレンス: https://librarylibrarian.github.io/misskey_client/
- pub.dev ページ: https://pub.dev/packages/misskey_client
- GitHub: https://github.com/LibraryLibrarian/misskey_client

## ライセンス

[LICENSE](LICENSE) を参照してください。
