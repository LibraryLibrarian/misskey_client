---
title: Migration von misskey_streaming
---

# Migration von misskey_streaming

Streaming ist jetzt in `misskey_client` integriert. Entfernen Sie nach der Migration aller Aufrufstellen die eigenständige Abhängigkeit `misskey_streaming` und verwenden Sie das erste `misskey_client`-Release mit Issue #30.

## Integrierten Client erstellen

```dart
// Vorher
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
  enableAutoReconnect: true,
  debugLog: true,
);

// Nachher
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

`MisskeyStreaming.fromClient()` ist nicht mehr nötig. Die integrierte Verbindung verwendet URL, Token-Provider, Logger und Log-Einstellung von `MisskeyClient` gemeinsam.

Umschließen Sie einen vorhandenen Callback `void oldLogger(String level, String message)` mit `FunctionLogger(oldLogger)`, übergeben Sie ihn als `logger` des Clients und setzen Sie `MisskeyClientConfig.enableLog` auf `true`.

## Abonnement- und Capture-Aufrufe ersetzen

```dart
// Vorher
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
  params: {'withRenotes': true},
);
handle.stream.listen((message) => print(message.body));
streaming.captureNote(handle.id, noteId);

// Nachher
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(withRenotes: true),
);
home.messages.listen((message) => print(message.body));
home.captureNote(noteId);
```

Verwenden Sie `subscribeRaw(channel: ..., params: ..., id: ...)` für einen Fork-spezifischen Channel. `unsubscribe()` ist jetzt asynchron und muss daher mit `await` aufgerufen werden.

| Alte API | Integrierte API |
|---|---|
| `MisskeySubscriptionHandle.stream` | `messages`, `events`, `notes` oder `notifications` des Handles |
| `MisskeyStreamingClient.messagesFor(id)` | `messages` des passenden Handles |
| `MisskeyStreamingClient.messages` | `client.streaming.messages` (äußere Envelopes) |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `uncaptureNote(handle.id, noteId)` | `handle.uncaptureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| Manuelle typisierte Dekodierung | `MisskeyStreamingEvent` und `MisskeyUnknownEvent` |

## Lebenszyklus und Konfiguration zuordnen

| Alte API | Integrierte API |
|---|---|
| `status`-Stream | `stateChanges` zusammen mit dem aktuellen `state` |
| `isConnected` | `state == MisskeyStreamingConnectionState.connected` |
| Wiederverbindungsfelder | Dieselben Felder in `MisskeyStreamingConfig` |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | Argument `tokenProvider` von `MisskeyClient` |
| `debugLog` / `logger`-Callback | `enableLog: true` / `logger: FunctionLogger(oldLogger)` des Clients |
| `pingInterval` | Entfernt; kein öffentlicher anwendungsseitiger Ping-Timer |
| `customHeaders` / `protocols` | Keine öffentliche integrierte Einstellung |
| `connector` | Nur für interne Testinjektion |
| `exceptionMapper` | Typisierte Streaming-Ausnahmen und der Stream `errors` |

Verwenden Sie `disconnect()`, wenn die Verbindung wiederverwendet werden soll. Rufen Sie zum endgültigen Beenden `dispose()` auf oder geben Sie den zugehörigen `MisskeyClient` frei. `MisskeyClient.dispose()` ist idempotent und schließt sowohl initialisierte Streaming-Ressourcen als auch den HTTP-Transport.

Für `sendToChannel()` gibt es keinen öffentlichen Ersatz in der integrierten API. Erstellen Sie ein Issue, wenn ein Upstream- oder Fork-Protokoll das Senden von Channel-Events erfordert.

Vollständige Beispiele und Event-Details finden Sie im [Streaming-API-Leitfaden](./streaming.md). Im Stammverzeichnis des Repositorys steht außerdem die vollständige [Migrationsreferenz](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md).
