---
sidebar_position: 2
title: Authentication
---

# Authentication

Misskey uses token-based authentication. A secret token (called `i` in the Misskey API) is injected into every authenticated POST request body. Unlike OAuth-based APIs, there is no Bearer header — the token travels inside the JSON body.

## How TokenProvider works

`TokenProvider` is a typedef for a callback that returns `FutureOr<String?>`:

```dart
typedef TokenProvider = FutureOr<String?> Function();
```

The callback is invoked for each authenticated request. This design lets you refresh or lazily load tokens without rebuilding the client.

### Synchronous token

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_token_here',
);
```

### Asynchronous token (e.g. loaded from secure storage)

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

### Token refresh pattern

If your token can be rotated, return the latest value from the provider. The client always calls the callback immediately before sending, so returning an up-to-date value is enough:

```dart
String? _cachedToken;

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => _cachedToken,
);

// Update the cached value whenever your token changes.
void onTokenRefreshed(String newToken) {
  _cachedToken = newToken;
}
```

## AuthMode enum

Each API endpoint declares its authentication requirement using the `AuthMode` enum:

| Mode | Behavior |
|------|----------|
| `AuthMode.required` | Token is injected; throws if none is provided (default) |
| `AuthMode.optional` | Token is injected when available; request proceeds without one |
| `AuthMode.none` | Token is never injected, regardless of the provider |

This is an internal library concern. As a consumer, you only need to supply `tokenProvider`. The library handles injection automatically.

Endpoints with `AuthMode.optional` return richer responses when authenticated. For example, `notes/show` includes `myReaction` and `isFavorited` fields only when a token is present.

## Obtaining a token: MiAuth flow

Misskey does not use OAuth 2.0. The recommended flow for third-party apps is **MiAuth**, a simplified browser-redirect flow.

```
1. Generate a session UUID
2. Open the MiAuth URL in a browser
3. User grants permission on the Misskey web UI
4. Redirect returns to your callback URL (or you poll the API)
5. Exchange the session UUID for a token
```

### Step 1: Build the authorization URL

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
// Open authUrl in a browser or WebView
```

### Step 2: Exchange the session for a token

After the user approves the request, call the check endpoint. This is a plain HTTP GET and does not go through the library's authenticated path:

```dart
final response = await http.get(
  Uri.parse('$baseUrl/api/miauth/$session/check'),
);
final json = jsonDecode(response.body) as Map<String, dynamic>;
final token = json['token'] as String?;
```

Store the token securely and pass it to `tokenProvider`.

## Unauthenticated usage

Pass no `tokenProvider` to access public endpoints:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
);

// Works without a token
final info = await client.meta.fetch();
final notes = await client.notes.timelineLocal(limit: 10);
```

Calling an endpoint with `AuthMode.required` without a provider throws `MisskeyUnauthorizedException`.
