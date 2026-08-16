---
title: Migration von misskey_streaming
---

# Migration von misskey_streaming

Streaming ist jetzt in `misskey_client` integriert. Entfernen Sie nach der Migration aller Aufrufstellen die eigenständige Abhängigkeit `misskey_streaming` und verwenden Sie das erste `misskey_client`-Release mit Issue #30.

## Client und Subscription

```dart
// Vorher
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
);
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
);

// Nachher
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => token,
  streamingConfig: MisskeyStreamingConfig(),
);
await client.streaming.connect();
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(),
);
```

`MisskeyStreaming.fromClient()` ist nicht mehr nötig. Für Fork-spezifische Channels dient `subscribeRaw()`; das jetzt asynchrone `unsubscribe()` muss mit `await` aufgerufen werden.

Umschließen Sie einen vorhandenen Callback `void oldLogger(String level, String message)` mit `FunctionLogger(oldLogger)`, übergeben Sie ihn als `logger` des Clients und setzen Sie `MisskeyClientConfig.enableLog` auf `true`.

| Alte API | Integrierte API |
|---|---|
| `handle.stream` | `messages` / `events` / `notes` / `notifications` |
| `messagesFor(id)` | `messages` des passenden Handles |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| `status` / `isConnected` | `stateChanges` / `state == MisskeyStreamingConnectionState.connected` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `tokenProvider` / `logger`-Callback | `tokenProvider` / `logger: FunctionLogger(oldLogger)` (`enableLog: true`) |
| Wiederverbindungseinstellungen | `MisskeyStreamingConfig` |
| `pingInterval` | Entfernt; keine öffentliche anwendungsseitige Ping-Einstellung |
| `customHeaders` / `protocols` | Keine öffentliche integrierte Einstellung |
| `exceptionMapper` | Typisierte Ausnahmen und `errors` |

Capture-Aufrufe werden zu `home.captureNote(noteId)` / `home.uncaptureNote(noteId)`. Nutzen Sie `disconnect()` zur Wiederverwendung und `dispose()` oder `MisskeyClient.dispose()` zum endgültigen Beenden. Für `sendToChannel()` gibt es keinen öffentlichen Ersatz.

Details stehen im [Streaming-API-Leitfaden](./streaming.md) und in der [vollständigen Migrationsreferenz](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md).
