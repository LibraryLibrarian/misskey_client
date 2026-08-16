[日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [한국어](README.ko.md)

# misskey_client

A pure Dart client library for the [Misskey](https://misskey-hub.net/) API. Provides typed access to 25 API domains with built-in authentication, retry logic, and structured error handling.

> **Beta**: API implementation is complete but test coverage is minimal. Response models and method signatures may change based on test findings. See the [changelog](CHANGELOG.md) for details.

## Features

- Covers 25 Misskey API domains (Notes, Drive, Users, Channels, Chat, and more)
- Token-based authentication via a pluggable `TokenProvider` callback
- Automatic retry with configurable maximum attempts
- Sealed exception hierarchy for exhaustive error handling
- Strongly typed request and response models generated with `json_serializable`
- Integrated Streaming API with typed channels, events, and automatic reconnection
- Configurable logging through a swappable `Logger` interface
- Pure Dart — no Flutter dependency required

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.7
```

Then run:

```
dart pub get
```

## Quick Start

```dart
import 'package:misskey_client/misskey_client.dart';

void main() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      timeout: Duration(seconds: 10),
      maxRetries: 3,
    ),
    // Supply your access token. The callback may be async.
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  );

  // Fetch the authenticated user's own notes
  final notes = await client.notes.getTimeline();
  for (final note in notes) {
    print(note.text);
  }
}
```

## API Overview

`MisskeyClient` exposes the following properties, each covering a distinct area of the Misskey API:

| Property | Description |
|---|---|
| `account` | Account and profile management, registry, 2FA, webhooks |
| `announcements` | Server announcements |
| `antennas` | Antenna (keyword-based feed) management |
| `ap` | ActivityPub utilities |
| `blocking` | User blocking |
| `channels` | Channels and channel mutes |
| `charts` | Statistics charts |
| `chat` | Chat rooms and messages |
| `clips` | Clip collections |
| `drive` | Drive (file storage), files, folders, stats |
| `federation` | Federated instance information |
| `flash` | Flash (Play) scripts |
| `following` | Following and follow requests |
| `gallery` | Gallery posts |
| `hashtags` | Hashtag search and trends |
| `invite` | Invite codes |
| `meta` | Server metadata |
| `mute` | User muting |
| `notes` | Notes, reactions, polls, search, timeline |
| `notifications` | Notifications |
| `pages` | Pages |
| `renoteMute` | Renote muting |
| `roles` | Role assignments |
| `sw` | Push notifications (Service Worker) |
| `streaming` | Real-time timelines, notifications, and captured note updates |
| `users` | User search, lists, relations, achievements |

## Streaming API

The lazily created `client.streaming` connection shares the client's server, token provider, and logger. Subscribe with a typed `MisskeyStreamingChannel` and choose the level that fits your application: decoded `notes` and `notifications`, typed `events`, or lossless `messages`.

```dart
Future<void> streamHomeTimeline() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
    ),
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
    streamingConfig: MisskeyStreamingConfig(maxReconnectAttempts: 5),
  );

  await client.streaming.connect();
  final home = await client.streaming.subscribe(
    const MisskeyStreamingChannel.homeTimeline(
      withRenotes: true,
      withFiles: false,
    ),
  );

  final notesSubscription = home.notes.listen((note) {
    print(note.text);
  });
  final eventsSubscription = home.events.listen((event) {
    if (event is MisskeyNoteReactedEvent) {
      print('${event.noteId}: ${event.reaction}');
    }
  });

  // Capture a known note to receive reaction, deletion, and poll updates.
  home.captureNote('NOTE_ID');

  await notesSubscription.cancel();
  await eventsSubscription.cancel();
  home.uncaptureNote('NOTE_ID');
  await home.unsubscribe();
  await client.dispose();
}
```

Use `subscribeRaw(channel: ..., params: ...)` for fork-specific channels. It returns the same subscription handle, including the `messages` stream. `connect()`, `disconnect()`, and `reconnect()` control a reusable connection; `dispose()` is terminal. Connection states are available through `state` and `stateChanges`, while asynchronous failures are reported through `errors`.

## Authentication

Pass a `TokenProvider` callback when constructing the client. The callback returns `FutureOr<String?>`, so both synchronous and asynchronous token sources are supported:

```dart
// Synchronous token
final client = MisskeyClient(
  config: config,
  tokenProvider: () => secureStorage.readSync('token'),
);

// Asynchronous token
final client = MisskeyClient(
  config: config,
  tokenProvider: () async => await secureStorage.read('token'),
);
```

Endpoints that require authentication inject the token automatically. Endpoints that are optionally authenticated attach the token when one is available.

## Error Handling

All exceptions extend the sealed class `MisskeyClientException`, allowing exhaustive pattern matching:

```dart
try {
  final user = await client.users.show(userId: 'abc123');
} on MisskeyUnauthorizedException {
  // 401 — token invalid or missing
} on MisskeyForbiddenException {
  // 403 — operation not permitted
} on MisskeyNotFoundException {
  // 404 — resource not found
} on MisskeyRateLimitException catch (e) {
  // 429 — rate limited; check e.retryAfter
} on MisskeyValidationException {
  // 422 — invalid request body
} on MisskeyServerException {
  // 5xx — server-side error
} on MisskeyNetworkException {
  // Timeout, connection refused, etc.
}
```

## Logging

Enable the built-in stdout logger via `MisskeyClientConfig.enableLog`, or supply a custom `Logger` implementation:

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

## Migrating from misskey_api_core

### API mapping

| misskey_api_core | misskey_client |
|---|---|
| `MisskeyHttpClient(config: ..., tokenProvider: ...)` | `MisskeyClient(config: ..., tokenProvider: ...)` |
| `MisskeyApiConfig(baseUrl: ...)` | `MisskeyClientConfig(baseUrl: ...)` |
| `http.send<T>('/emojis', ...)` | The corresponding typed method, such as `client.meta.getEmojis()` |
| `MetaClient(http).getMeta()` | `client.meta.getMeta()` |
| `MisskeyApiException` | The sealed hierarchy containing `MisskeyApiException`, `MisskeyUnauthorizedException`, `MisskeyForbiddenException`, `MisskeyRateLimitException`, and others |
| `RequestOptions(authRequired: false)` | Handled internally by typed methods; callers do not need to specify it |
| `Logger` / `FunctionLogger` | Classes with the same names |
| `kReleaseMode` / `kDebugMode` | Not part of the public API; see below |

### Exception name collision

Both packages define `MisskeyApiException`, but the classes have different contents and no inheritance relationship. The `misskey_api_core` version is a simple class, while the `misskey_client` version extends `MisskeyClientException` and requires a `statusCode`. While importing both packages during migration, use a prefix to avoid the collision:

```dart
import 'package:misskey_api_core/misskey_api_core.dart' as core;
```

### Build mode constants

`misskey_api_core` exported `kReleaseMode` and `kDebugMode`, but `misskey_client` does not. They are general-purpose utilities unrelated to Misskey. Flutter applications should import them from `package:flutter/foundation.dart`; pure Dart applications can use `bool.fromEnvironment('dart.vm.product')`. To control client logging, pass the value through `MisskeyClientConfig.enableLog`, for example `enableLog: kDebugMode`.

### Low-level HTTP access

The low-level equivalent of `MisskeyHttpClient.send<T>()` is not public. `misskey_client` covers 25 API domains, so use its typed methods. If an endpoint you need is missing, please report it in a GitHub issue so it can be added to the typed API.

## Migrating from misskey_streaming

Streaming is now integrated into `misskey_client`. See the [migration guide](MIGRATION_FROM_MISSKEY_STREAMING.md) for dependency, configuration, subscription, event, note capture, and lifecycle mappings from the standalone `misskey_streaming` package.

## Documentation

- API reference: https://librarylibrarian.github.io/misskey_client/
- pub.dev page: https://pub.dev/packages/misskey_client
- GitHub: https://github.com/LibraryLibrarian/misskey_client

## License

See [LICENSE](LICENSE).
