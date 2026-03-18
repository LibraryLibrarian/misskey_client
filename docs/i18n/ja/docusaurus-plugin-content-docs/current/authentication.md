---
sidebar_position: 2
---

# 認証

## Misskeyのトークン認証

misskey_client はトークンベースの認証を使用します。すべてのAPIリクエストのボディに `i` フィールドとしてアクセストークンが自動的に付与されます。

## TokenProvider

`TokenProvider` はトークンを供給するインターフェースです。リクエストのたびに呼び出されるため、動的なトークン管理が可能です。

最もシンプルな実装は `StaticTokenProvider` です。

```dart
final tokenProvider = StaticTokenProvider('your_access_token');
```

トークンをキーチェーンや暗号化ストレージから取得する場合は、カスタム実装を作成します。

```dart
class SecureTokenProvider implements TokenProvider {
  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'misskey_token');
  }
}
```

## AuthMode

各APIエンドポイントは `AuthMode` を持ちます。

| AuthMode | 説明 |
|---|---|
| `required` | トークン必須（デフォルト）。未設定の場合はリクエスト前にエラー |
| `optional` | トークンがあれば付与、なければ匿名リクエスト |
| `none` | トークンを付与しない（公開エンドポイント用） |

`TokenProvider.getToken()` が `null` を返し、AuthModeが `required` の場合は `MisskeyClientException` がスローされます。

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

取得したトークンを `StaticTokenProvider` や独自の `TokenProvider` に渡してクライアントを構築します。
