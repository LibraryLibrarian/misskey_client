---
title: Streaming API
---

# Streaming API

Die integrierte Streaming API liefert Timelines, Benachrichtigungen und Updates erfasster Notes per WebSocket. `MisskeyClient.streaming` wird verzögert erstellt und verwendet URL, Token-Provider, Logger und Log-Einstellung des Clients gemeinsam.

## Konfigurieren und verbinden

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

Der Token-Provider wird bei jeder neuen Verbindung einschließlich Wiederverbindungen ausgewertet. `state` enthält den aktuellen Zustand, `stateChanges` spätere Änderungen und `errors` asynchrone Transport-, Protokoll- und Subscription-Fehler. `connect()`, `disconnect()` und `reconnect()` steuern die wiederverwendbare Verbindung; `dispose()` beendet sie endgültig.

## Offiziellen Channel abonnieren

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

Während einer Verbindung wird `subscribe()` nach der `connected`-Bestätigung des Servers abgeschlossen. Subscriptions werden nach einer automatischen Wiederverbindung erneut gesendet. Typisierte Definitionen gibt es für den Haupt-Channel, Timelines, Benutzerlisten, Hashtags, Rollen, Antennen, Channels, Drive, Statistiken, Administration, Reversi und Chat.

## Event-Ansicht auswählen

| Stream | Inhalt |
|---|---|
| `messages` | Normalisierte `MisskeyStreamingMessage` mit Raw-Envelope |
| `events` | Typisierte `MisskeyStreamingEvent` |
| `notes` | Aus Note-Events extrahierte `MisskeyNote` |
| `notifications` | Aus Events extrahierte `MisskeyNotification` |

```dart
final noteListener = home.notes.listen((note) => print(note.text));
final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId: $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('Nicht unterstütztes Event $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` bewahrt `type`, `body`, die ursprüngliche `raw`-Nachricht und den optionalen `decodeError`. Der globale Stream `client.streaming.messages` bewahrt die äußere Wire-Envelope; Subscription-`messages` sind auf das innere Event normalisiert.

## Note-Updates erfassen

```dart
home.captureNote(noteId);
// events empfängt reacted, unreacted, deleted und pollVoted.
home.uncaptureNote(noteId);
```

Captures werden über Subscriptions hinweg referenzgezählt und nach Wiederverbindungen wiederhergestellt. Wiederholte Aufrufe auf demselben Handle sind idempotent.

## Fork-spezifische Channels und Cleanup

```dart
final forkChannel = await client.streaming.subscribeRaw(
  channel: 'forkSpecificChannel',
  params: const <String, Object?>{'option': true},
  id: 'optional-caller-id',
);
final listener = forkChannel.messages.listen(print);

await listener.cancel();
await forkChannel.unsubscribe();
await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();
await client.dispose();
```

`unsubscribe()` und `MisskeyClient.dispose()` können sicher wiederholt oder gleichzeitig aufgerufen werden. Es sind höchstens 32 aktive Subscriptions möglich.

Zur Migration siehe [Migration von misskey_streaming](./migration-from-misskey-streaming.md).
