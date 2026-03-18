---
sidebar_position: 2
title: 认证
---

# 认证

Misskey 使用基于令牌的认证方式。一个私密令牌（在 Misskey API 中称为 `i`）会被注入到每个需要认证的 POST 请求体中。与基于 OAuth 的 API 不同，这里没有 Bearer 请求头——令牌通过 JSON 请求体传递。

## TokenProvider 的工作原理

`TokenProvider` 是一个返回 `FutureOr<String?>` 的回调函数类型：

```dart
typedef TokenProvider = FutureOr<String?> Function();
```

每次发起已认证请求时都会调用该回调。这种设计让你无需重建客户端就能刷新或延迟加载令牌。

### 同步令牌

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_token_here',
);
```

### 异步令牌（例如从安全存储中读取）

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () async {
    return await secureStorage.read(key: 'misskey_token');
  },
);
```

### 令牌刷新模式

如果令牌可以被轮换，从提供者中返回最新值即可。客户端在每次发送请求前都会立即调用回调，因此返回最新值就足够了：

```dart
String? _cachedToken;

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => _cachedToken,
);

// 在令牌变更时更新缓存值。
void onTokenRefreshed(String newToken) {
  _cachedToken = newToken;
}
```

## AuthMode 枚举

每个 API 端点通过 `AuthMode` 枚举声明其认证要求：

| 模式 | 行为 |
|------|----------|
| `AuthMode.required` | 注入令牌；如未提供则抛出异常（默认） |
| `AuthMode.optional` | 有令牌时注入；无令牌时请求照常进行 |
| `AuthMode.none` | 无论提供者如何，从不注入令牌 |

这是库内部的机制，作为使用者只需提供 `tokenProvider`，库会自动处理注入。

使用 `AuthMode.optional` 的端点在已认证时会返回更丰富的响应。例如，`notes/show` 仅在有令牌时才包含 `myReaction` 和 `isFavorited` 字段。

## 获取令牌：MiAuth 流程

Misskey 不使用 OAuth 2.0。对于第三方应用，推荐的流程是 **MiAuth**——一种简化的浏览器重定向流程。

```
1. 生成一个会话 UUID
2. 在浏览器中打开 MiAuth URL
3. 用户在 Misskey Web 界面上授予权限
4. 重定向返回到你的回调 URL（或轮询 API）
5. 用会话 UUID 换取令牌
```

### 第一步：构建授权 URL

```dart
import 'package:uuid/uuid.dart';

final session = const Uuid().v4();
final baseUrl = 'https://misskey.example.com';

final authUrl = Uri.parse('$baseUrl/miauth/$session').replace(
  queryParameters: {
    'name': 'My App',
    'callback': 'myapp://auth/callback',
    'permission': 'read:account,write:notes',
  },
);
// 在浏览器或 WebView 中打开 authUrl
```

### 第二步：用会话换取令牌

用户批准请求后，调用 check 端点。这是一个普通的 HTTP GET 请求，不经过库的认证路径：

```dart
final response = await http.get(
  Uri.parse('$baseUrl/api/miauth/$session/check'),
);
final json = jsonDecode(response.body) as Map<String, dynamic>;
final token = json['token'] as String?;
```

请安全地存储令牌并将其传递给 `tokenProvider`。

## 未认证使用

不传入 `tokenProvider` 即可访问公开端点：

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
);

// 无需令牌即可工作
final info = await client.meta.fetch();
final notes = await client.notes.timelineLocal(limit: 10);
```

在没有提供者的情况下调用 `AuthMode.required` 的端点将抛出 `MisskeyUnauthorizedException`。
