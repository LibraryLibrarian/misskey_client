---
title: Streaming API
---

# Streaming API

The integrated Streaming API delivers timelines, notifications, and captured-note updates over WebSocket. `MisskeyClient.streaming` is created lazily and shares the client's base URL, token provider, logger, and log setting.

## Configure and connect

Pass `MisskeyStreamingConfig` only when you need to change connection behavior:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  streamingConfig: MisskeyStreamingConfig(
    connectTimeout: const Duration(seconds: 15),
    subscriptionTimeout: const Duration(seconds: 10),
    enableAutoReconnect: true,
    maxReconnectAttempts: 5,
  ),
);

await client.streaming.connect();
```

The token provider is evaluated for each new connection, including reconnections. This lets a refreshed token take effect without rebuilding the client.

| Member | Purpose |
|---|---|
| `state` | Current `MisskeyStreamingConnectionState` |
| `stateChanges` | Changes that occur after listening |
| `errors` | Asynchronous transport, protocol, timeout, and subscription errors |
| `connect()` | Open the reusable connection |
| `disconnect()` | Close it without disposing subscriptions or the Streaming client |
| `reconnect()` | Replace the current connection |
| `dispose()` | Permanently release the Streaming client |

Listen to `errors` before connecting if the application needs to surface failures from automatic reconnection or resubscription.

## Subscribe to an official channel

Official channels use typed `MisskeyStreamingChannel` factories:

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

When connected, `subscribe()` completes after the server acknowledges the subscription. The handle remains registered across automatic reconnections and is resubscribed automatically.

The API includes typed definitions for `main`, the home/local/hybrid/global timelines, user lists, hashtags, roles, antennas, channels, drive, server and queue stats, admin, Reversi, and direct or room chat channels.

## Choose an event view

A subscription exposes multiple views of its routed messages:

| Stream | Contents |
|---|---|
| `messages` | Normalized `MisskeyStreamingMessage` values with their raw decoded envelopes |
| `events` | Typed `MisskeyStreamingEvent` values |
| `notes` | `MisskeyNote` values extracted from note events |
| `notifications` | `MisskeyNotification` values extracted from notification events |

```dart
final noteListener = home.notes.listen((note) {
  print(note.text);
});

final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId received $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('Unsupported event $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` preserves its normalized `type`, `body`, source `raw` message, and optional `decodeError`. Keep a fallback branch so server additions remain observable.

The global `client.streaming.messages` stream preserves outer wire envelopes. Messages routed through a subscription are normalized to their inner event and carry that subscription's `subscriptionId`.

## Capture note updates

Capture a known note through the handle that should receive its updates:

```dart
home.captureNote(noteId);
// home.events can now emit reacted, unreacted, deleted, and pollVoted events.

home.uncaptureNote(noteId);
```

Capture calls are reference-counted across subscriptions and restored after reconnection. Repeated capture or uncapture calls on the same handle are idempotent.

## Fork-specific channels

Use `subscribeRaw()` when a Misskey fork exposes a channel that has no typed factory:

```dart
final forkChannel = await client.streaming.subscribeRaw(
  channel: 'forkSpecificChannel',
  params: const <String, Object?>{'option': true},
  id: 'optional-caller-id',
);

final listener = forkChannel.messages.listen((message) {
  print('${message.type}: ${message.body}');
});
```

The same acknowledgement, reconnection, message, and cleanup behavior applies. An explicit ID must be unique among registered subscriptions and cannot reuse a tombstone from the current connection generation.

## Cleanup

Cancel Dart stream listeners separately, then unsubscribe the channel:

```dart
await listener.cancel();
await forkChannel.unsubscribe();

await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();

await client.dispose();
```

`unsubscribe()` and `MisskeyClient.dispose()` are safe to call repeatedly or concurrently. A client supports at most 32 active Streaming subscriptions. Accessing `client.streaming` after the client has been disposed throws `StateError`.

Migrating from the standalone package? See [Migrating from misskey_streaming](./migration-from-misskey-streaming.md).
