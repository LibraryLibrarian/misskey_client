---
sidebar_position: 1
slug: /
---

# はじめに

:::warning ベータ版

このライブラリは現在**ベータ版**です。API実装は完了していますが、テストカバレッジは最小限です。テスト結果に基づき、レスポンスモデルやメソッドシグネチャが変更される可能性があります。

レスポンスモデルの不備や予期しない動作を発見された場合は、[GitHub Issues](https://github.com/LibraryLibrarian/misskey_client/issues) での報告、または [Pull Request](https://github.com/LibraryLibrarian/misskey_client/pulls) の送信をお願いいたします。

:::

## インストール

`pubspec.yaml` に以下を追加してください。

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.9
```

その後、依存関係を取得します。

```bash
dart pub get
```

## 基本的な使い方

`MisskeyClient` を使うには、`MisskeyClientConfig` とトークンを返すコールバックを用意します。

```dart
import 'package:misskey_client/misskey_client.dart';

final config = MisskeyClientConfig(
  baseUrl: Uri.parse('https://misskey.example.com'),
  userAgent: 'MyApp/1.0.0',
);

final client = MisskeyClient(
  config: config,
  tokenProvider: () => 'your_access_token',
);
```

`baseUrl` にはスキームを含む `Uri` を指定します。`tokenProvider` は `FutureOr<String?>` を返すコールバックで、認証を伴うリクエストごとに呼び出されます。認証が不要なエンドポイントだけを使う場合は省略できます。

## 最初のAPI呼び出し

`meta.getMeta` でサーバー情報を取得できます。

```dart
final meta = await client.meta.getMeta();
print(meta.name);
print(meta.version);
```

## API構造の概要

`MisskeyClient` は、主なAPIドメインをプロパティとして提供します。管理者向けAPI（`admin*`）など、ここに載せていないドメインもあります。

| プロパティ | 説明 |
|---|---|
| `client.notes` | ノートの取得・作成・検索 |
| `client.users` | ユーザー情報・フォロー管理 |
| `client.drive` | ファイルストレージ |
| `client.notifications` | 通知の取得と管理 |
| `client.meta` | サーバーメタ情報 |
| `client.streaming` | リアルタイムのタイムライン、通知、ノート更新 |

認証を伴う POST リクエストでは、ボディの `i` フィールドにアクセストークンが自動的に付与されます。

## ログ制御

HTTP リクエスト・レスポンスのログはデフォルトで無効です。`enableLog: true` を設定すると、カスタム `logger` を指定していない場合は `StdoutLogger` がログを出力します。HTTP ログはリリースビルドでは出力されません。

```dart
final config = MisskeyClientConfig(
  baseUrl: Uri.parse('https://misskey.example.com'),
  enableLog: true,
);
```

詳細は[ロギング](./advanced/logging)を参照してください。

## 次のステップ

- [認証](./authentication) - TokenProviderとAuthModeの使い方
- [Streaming API](./streaming) - リアルタイムチャンネル、イベント、ライフサイクル
- [misskey_streamingからの移行](./migration-from-misskey-streaming) - 旧パッケージからの移行
- [エラーハンドリング](./error-handling) - 例外の種類と対処法
- [ノートAPI](./api/notes) - ノートの操作
- [ドライブアップロード](./advanced/drive-upload) - ファイルのアップロード
