---
title: Migrating from misskey_streaming
---

# Migrating from misskey_streaming

Streaming is now part of `misskey_client`. Remove the standalone `misskey_streaming` dependency after migrating every call site, and use the first `misskey_client` release that includes issue #30.

## Create the integrated client

```dart
// Before
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
  enableAutoReconnect: true,
  debugLog: true,
);

// After
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => token,
  streamingConfig: MisskeyStreamingConfig(enableAutoReconnect: true),
);
await client.streaming.connect();
```

`MisskeyStreaming.fromClient()` is no longer needed. The integrated connection shares the URL, token provider, logger, and log setting of `MisskeyClient`.

Wrap an existing `void oldLogger(String level, String message)` callback with `FunctionLogger(oldLogger)`, pass it as the client's `logger`, and set `MisskeyClientConfig.enableLog` to `true`.

## Replace subscriptions and capture calls

```dart
// Before
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
  params: {'withRenotes': true},
);
handle.stream.listen((message) => print(message.body));
streaming.captureNote(handle.id, noteId);

// After
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(withRenotes: true),
);
home.messages.listen((message) => print(message.body));
home.captureNote(noteId);
```

Use `subscribeRaw(channel: ..., params: ..., id: ...)` for a fork-specific channel. `unsubscribe()` is now asynchronous, so await it.

| Standalone API | Integrated API |
|---|---|
| `MisskeySubscriptionHandle.stream` | Handle `messages`, `events`, `notes`, or `notifications` |
| `MisskeyStreamingClient.messagesFor(id)` | The matching handle's `messages` |
| `MisskeyStreamingClient.messages` | `client.streaming.messages` (outer envelopes) |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `uncaptureNote(handle.id, noteId)` | `handle.uncaptureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| Manual typed decoding | `MisskeyStreamingEvent` and `MisskeyUnknownEvent` |

## Map lifecycle and configuration

| Standalone API | Integrated API |
|---|---|
| `status` stream | `stateChanges` plus the current `state` |
| `isConnected` | `state == MisskeyStreamingConnectionState.connected` |
| Reconnection fields | The same fields on `MisskeyStreamingConfig` |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | `MisskeyClient`'s `tokenProvider` argument |
| `debugLog` / `logger` callback | Client `enableLog: true` / `logger: FunctionLogger(oldLogger)` |
| `pingInterval` | Removed; no public application-level ping timer |
| `customHeaders` / `protocols` | No public integrated setting |
| `connector` | Internal test injection only |
| `exceptionMapper` | Typed Streaming exceptions and the `errors` stream |

Use `disconnect()` when the connection will be reused. Use terminal `dispose()`, or dispose the owning `MisskeyClient`, when finished. `MisskeyClient.dispose()` is idempotent and closes both initialized Streaming resources and the HTTP transport.

`sendToChannel()` has no integrated public replacement. Open an issue if an upstream or fork protocol requires outbound channel events.

For complete examples and event details, see the [Streaming API guide](./streaming.md). The root repository also contains the full [migration reference](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md).
