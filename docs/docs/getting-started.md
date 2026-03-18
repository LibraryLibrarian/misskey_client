---
sidebar_position: 1
slug: /
title: Getting Started
---

# Getting Started

misskey_client is a pure Dart Misskey API client library.
It works in any environment where Dart runs: Flutter, server-side Dart, CLI tools, and more.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  misskey_client: ^0.0.1
```

Then fetch it:

```bash
dart pub get
```

## Basic Usage

### Initializing the client

```dart
import 'package:misskey_client/misskey_client.dart';

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_access_token',
);
```

`baseUrl` must be a `Uri` including the scheme (e.g. `https://`).
`tokenProvider` is a callback returning `FutureOr<String?>`. It can be omitted when only using endpoints that do not require authentication.

### Your first API call

Fetching server information (no authentication required):

```dart
final serverInfo = await client.meta.fetch();
print(serverInfo.name);        // Server name
print(serverInfo.description); // Server description
```

Fetching the authenticated user's own account:

```dart
final me = await client.account.i();
print(me.name);     // Display name
print(me.username); // Username (without @)
```

### API structure

Every API domain is exposed as a property on `MisskeyClient`:

```dart
client.account       // Account and profile management (/api/i/*)
client.announcements // Server announcements
client.antennas      // Antenna (keyword monitoring) management
client.ap            // ActivityPub endpoints
client.blocking      // User blocking
client.channels      // Channel management
client.charts        // Statistics charts
client.chat          // Direct messaging
client.clips         // Note clip management
client.drive         // File storage (drive.files, drive.folders, drive.stats)
client.federation    // Federated instance information
client.flash         // Flash (Play) management
client.following     // Follow / unfollow operations
client.gallery       // Gallery post management
client.hashtags      // Hashtag information
client.invite        // Invite code management
client.meta          // Server metadata
client.mute          // User muting
client.notes         // Note operations (timelines, create, react, etc.)
client.notifications // Notification retrieval and management
client.pages         // Pages management
client.renoteMute    // Renote mute management
client.roles         // Role management
client.sw            // Service Worker push notification registration
client.users         // User search, follow lists, user lists
```

### Controlling log output

HTTP request/response logs are disabled by default. Enable them via `MisskeyClientConfig`:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

To route logs to your own sink, pass a `Logger` implementation to the constructor:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level is one of: 'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

See [Logging](./advanced/logging.md) for details.

## Next steps

- [Authentication](./authentication.md) — Token-based auth and MiAuth flow
- [Error Handling](./error-handling.md) — Exception hierarchy and catch patterns
- [Notes](./api/notes.md) — Creating and fetching notes
- [Drive Upload](./advanced/drive-upload.md) — Uploading files to Drive
