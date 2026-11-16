---
sidebar_position: 2
---

# 認証

## Misskeyのトークン認証

misskey_client はトークンベースの認証を使用します。認証を伴う POST リクエストでは、ボディの `i` フィールドにアクセストークンが自動的に付与されます。

## TokenProvider

`TokenProvider` は `FutureOr<String?> Function()` を表す型エイリアスです。認証を伴うリクエストごとに呼び出されるため、動的なトークン管理が可能です。

固定のトークンを使う場合は、トークンを返すコールバックを指定します。

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_access_token',
);
```

`baseUrl` にはスキームを含む `Uri` を指定します。

トークンをキーチェーンや暗号化ストレージから取得する場合は、非同期のコールバックを指定します。

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () async => await secureStorage.read(key: 'misskey_token'),
);
```

## AuthMode

各APIエンドポイントは `AuthMode` を持ちます。

| AuthMode | 説明 |
|---|---|
| `required` | トークン必須（デフォルト）。未設定の場合は認証エラー |
| `optional` | トークンがあれば付与、なければ匿名リクエスト |
| `none` | トークンを付与しない（公開エンドポイント用） |

`tokenProvider` が `null` を返し、`AuthMode` が `required` の場合は `MisskeyUnauthorizedException` がスローされます。

## MiAuthフロー概要

Misskeyでは MiAuth プロトコルを使ってユーザーにアクセスを許可してもらう方法が一般的です。

1. セッションIDを生成する
2. 認証URLをブラウザで開く: `https://misskey.example.com/miauth/{sessionId}?name=MyApp&permission=read:account,write:notes`
3. ユーザーが承認後、セッションIDでトークンを取得する

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

final sessionId = 'unique-session-id';
final authUrl = 'https://misskey.example.com/miauth/$sessionId'
    '?name=MyApp&permission=read:account,write:notes';

// ユーザーがブラウザで認証後、トークンを取得
final response = await http.post(
  Uri.parse('https://misskey.example.com/api/miauth/$sessionId/check'),
);
final data = jsonDecode(response.body);
final token = data['token'] as String;
```

取得したトークンを返すコールバックを `tokenProvider` に渡してクライアントを構築します。
