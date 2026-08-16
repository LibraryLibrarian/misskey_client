# Migrating from misskey_streaming

The Misskey Streaming API is integrated into `misskey_client`. This guide maps the standalone `misskey_streaming` package to the integrated API.

## Dependencies and imports

Remove `misskey_streaming` after migrating every call site and depend on the first `misskey_client` release that includes the integrated Streaming API:

```sh
dart pub remove misskey_streaming
dart pub add misskey_client
```

Replace the old import:

```dart
import 'package:misskey_streaming/misskey_streaming.dart';
```

with:

```dart
import 'package:misskey_client/misskey_client.dart';
```

Before that version is published, use a Git dependency pinned to a revision that contains issue #30.

## Client setup

Previously, the Streaming connection had its own server URL, token, and logging settings:

```dart
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
  enableAutoReconnect: true,
  debugLog: true,
);
```

Create one `MisskeyClient` instead. Its lazily created `streaming` property shares the base URL, token provider, logger, and `enableLog` setting with the HTTP client:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => token,
  streamingConfig: MisskeyStreamingConfig(
    enableAutoReconnect: true,
    maxReconnectAttempts: 5,
  ),
);

await client.streaming.connect();
```

`MisskeyStreaming.fromClient()` is no longer needed. Access `client.streaming` directly. The token provider is evaluated for each new WebSocket connection, including reconnections.

## Subscriptions

Prefer typed channel definitions for official Misskey channels:

```dart
// Before
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
  params: {'withRenotes': true, 'withFiles': false},
);
final messageSubscription = handle.stream.listen((message) {
  print(message.body);
});

// After
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
final messageSubscription = home.messages.listen((message) {
  print(message.body);
});
```

For a channel supplied by a Misskey fork, use the raw escape hatch:

```dart
final forkChannel = await client.streaming.subscribeRaw(
  channel: 'forkSpecificChannel',
  params: const <String, Object?>{'option': true},
  id: 'optional-caller-id',
);
```

The returned future waits for the server's `connected` acknowledgement when a connection is open. Await subscription cleanup because `unsubscribe()` is now asynchronous:

```dart
await messageSubscription.cancel();
await home.unsubscribe();
```

## Messages and typed events

Each `MisskeyStreamingSubscription` provides several views of the same routed events:

| Standalone API | Integrated API |
|---|---|
| `MisskeySubscriptionHandle.stream` | `MisskeyStreamingSubscription.messages` |
| `MisskeyStreamingClient.messagesFor(id)` | The matching handle's `messages` stream |
| `MisskeyStreamingClient.messages` | `MisskeyStreaming.messages` |
| Manual note decoding | `MisskeyStreamingSubscription.notes` |
| Manual notification decoding | `MisskeyStreamingSubscription.notifications` |
| Manual `noteUpdated` decoding | `MisskeyStreamingSubscription.events` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| `MisskeyMessage.id` on a channel event | The handle message's `MisskeyStreamingMessage.subscriptionId` |
| `MisskeyMessage.id` on a `noteUpdated` event | `MisskeyNoteUpdatedEvent.noteId`; a raw outer message keeps the same note ID in its `body.id` |

The `events` stream emits `MisskeyNoteEvent`, `MisskeyNotificationEvent`, and typed captured-note updates such as `MisskeyNoteReactedEvent`, `MisskeyNoteDeletedEvent`, and `MisskeyNotePollVotedEvent`. Unsupported events and payloads that cannot be decoded are preserved as `MisskeyUnknownEvent`; inspect its `body`, `raw`, and `decodeError` fields rather than dropping the event.

Messages on a subscription handle are normalized to their inner event. The global `client.streaming.messages` stream instead preserves the outer wire envelope, so its messages have no `subscriptionId`.

`sendToChannel()` has no integrated public replacement. Open an issue if an upstream or fork protocol requires outbound channel events.

## Capturing note updates

Capture and uncapture operations now belong to the subscription handle, so the subscription ID is not passed separately:

```dart
// Before
streaming.captureNote(handle.id, noteId);
streaming.uncaptureNote(handle.id, noteId);

// After
home.captureNote(noteId);
home.uncaptureNote(noteId);
```

Captured-note registrations survive automatic reconnection while their subscription remains active. Repeated capture and uncapture calls are idempotent.

## Connection state, errors, and lifecycle

| Standalone API | Integrated API |
|---|---|
| `MisskeyStreamingClient.status` stream | `client.streaming.stateChanges` |
| `MisskeyStreamingClient.isConnected` | `client.streaming.state == MisskeyStreamingConnectionState.connected` |
| `MisskeyConnectionState` | `MisskeyStreamingConnectionState` |
| Connection/protocol failures mixed into state or thrown | `client.streaming.errors` and typed `MisskeyStreamingException` subclasses |
| `connect()` | `connect()` |
| `dispose()` | `disconnect()` for later reuse, or terminal `dispose()` |

`MisskeyClient.dispose()` is idempotent. It disposes a Streaming connection if one was created and then closes the HTTP transport. A disposed client and its Streaming API cannot be reused.

Read `client.streaming.state` for the current value before listening to `stateChanges`, which reports changes that occur after listening.

## Configuration mapping

`MisskeyStreamingConfig` contains connection behavior only:

| `MisskeyStreamConfig` field | Replacement |
|---|---|
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | `tokenProvider` constructor argument of `MisskeyClient` |
| `debugLog` | `MisskeyClientConfig.enableLog` |
| `logger` callback | `logger: FunctionLogger(oldLogger)` on `MisskeyClient`, with `MisskeyClientConfig.enableLog: true` |
| `enableAutoReconnect` | `MisskeyStreamingConfig.enableAutoReconnect` |
| `connectTimeout` | `MisskeyStreamingConfig.connectTimeout` |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `reconnectInitialDelay` | `MisskeyStreamingConfig.reconnectInitialDelay` |
| `reconnectMaxDelay` | `MisskeyStreamingConfig.reconnectMaxDelay` |
| `maxReconnectAttempts` | `MisskeyStreamingConfig.maxReconnectAttempts` |
| `pingInterval` | Removed; there is no public application-level ping interval setting |
| `customHeaders` / `protocols` | Not part of the public integrated API |
| `connector` | Internal test transport injection only |
| `exceptionMapper` | Typed `MisskeyStreamingException` subclasses and `errors` |

Wrap an existing two-argument logger callback with the integrated logger adapter and enable logging:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => token,
  logger: FunctionLogger(oldLogger),
);
```

## Migration checklist

1. Replace the package dependency and import.
2. Move the server URL, token provider, and logger to `MisskeyClient`.
3. Move reconnection timeouts and attempt limits to `MisskeyStreamingConfig`.
4. Replace string-based official subscriptions with `MisskeyStreamingChannel` factories.
5. Replace `handle.stream` with the appropriate `messages`, `events`, `notes`, or `notifications` stream.
6. Move capture calls onto their subscription handle.
7. Await `unsubscribe()` and dispose the owning `MisskeyClient` when finished.
8. Handle `MisskeyUnknownEvent` and listen to `errors` so new server payloads and asynchronous failures remain observable.
