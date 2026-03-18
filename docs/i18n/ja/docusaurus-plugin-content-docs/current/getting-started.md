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
  misskey_client: ^1.0.0-beta.1
```

その後、依存関係を取得します。

```bash
dart pub get
```

## 基本的な使い方

`MisskeyClient` を使うには、`MisskeyClientConfig` と `TokenProvider` を用意します。

```dart
import 'package:misskey_client/misskey_client.dart';

final config = MisskeyClientConfig(
  baseUrl: 'https://misskey.example.com',
  userAgent: 'MyApp/1.0.0',
);

final tokenProvider = StaticTokenProvider('your_access_token');

final client = MisskeyClient(
  config: config,
  tokenProvider: tokenProvider,
);
```

## 最初のAPI呼び出し

`meta.fetch` でサーバー情報を取得できます。

```dart
final meta = await client.meta.fetch();
print(meta.name);
print(meta.version);
```

## API構造の概要

`MisskeyClient` は25のAPIドメインを提供します。

| プロパティ | 説明 |
|---|---|
| `client.notes` | ノートの取得・作成・検索 |
| `client.users` | ユーザー情報・フォロー管理 |
| `client.drive` | ファイルストレージ |
| `client.notifications` | 通知の取得と管理 |
| `client.meta` | サーバーメタ情報 |

すべてのAPIはHTTP POSTで通信します。トークンはリクエストボディの `i` フィールドとして送信されます。

## ログ制御

デフォルトでは `StdoutLogger` がログを出力します。ログを無効にするには `enableLog: false` を設定します。

```dart
final config = MisskeyClientConfig(
  baseUrl: 'https://misskey.example.com',
  enableLog: false,
);
```

詳細は[ロギング](./advanced/logging)を参照してください。

## 次のステップ

- [認証](./authentication) - TokenProviderとAuthModeの使い方
- [エラーハンドリング](./error-handling) - 例外の種類と対処法
- [ノートAPI](./api/notes) - ノートの操作
- [ドライブアップロード](./advanced/drive-upload) - ファイルのアップロード
