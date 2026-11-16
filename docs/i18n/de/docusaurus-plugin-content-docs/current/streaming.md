---
title: Streaming API
---

# Streaming API

Die integrierte Streaming API liefert Timelines, Benachrichtigungen und Updates erfasster Notes per WebSocket. `MisskeyClient.streaming` wird verzögert erstellt und verwendet URL, Token-Provider, Logger und Log-Einstellung des Clients gemeinsam.

## Konfigurieren und verbinden

Übergeben Sie `MisskeyStreamingConfig` nur, wenn Sie das Verbindungsverhalten ändern müssen.

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

Der Token-Provider wird bei jeder neuen Verbindung einschließlich Wiederverbindungen ausgewertet. So wird ein aktualisiertes Token wirksam, ohne den Client neu zu erstellen. `state` enthält den aktuellen Zustand, `stateChanges` spätere Änderungen und `errors` asynchrone Transport-, Protokoll-, Timeout- und Subscription-Fehler. Registrieren Sie vor dem Verbindungsaufbau einen Listener für `errors`, wenn die Anwendung Fehler bei der automatischen Wiederverbindung oder beim erneuten Abonnieren behandeln soll. `connect()`, `disconnect()` und `reconnect()` steuern die wiederverwendbare Verbindung; `dispose()` beendet sie endgültig. `disconnect()` schließt die Verbindung, ohne Subscriptions oder den Streaming-Client freizugeben.

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
| `notifications` | Aus Benachrichtigungs-Events extrahierte `MisskeyNotification` |

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

`MisskeyUnknownEvent` bewahrt `type`, `body`, die ursprüngliche `raw`-Nachricht und den optionalen `decodeError`. Behalten Sie einen Fallback-Zweig bei, damit auch vom Server neu hinzugefügte Events sichtbar bleiben. Der globale Stream `client.streaming.messages` bewahrt die äußere Wire-Envelope; Subscription-`messages` sind auf das innere Event normalisiert und enthalten die `subscriptionId` der jeweiligen Subscription.

## Note-Updates erfassen

Erfassen Sie eine bekannte Note über das Handle, das ihre Updates erhalten soll:

```dart
home.captureNote(noteId);
// events empfängt reacted, unreacted, deleted und pollVoted.
home.uncaptureNote(noteId);
```

Captures werden über Subscriptions hinweg referenzgezählt und nach Wiederverbindungen wiederhergestellt. Wiederholte Aufrufe auf demselben Handle sind idempotent.

## Fork-spezifische Channels und Cleanup

Verwenden Sie `subscribeRaw()`, wenn ein Misskey-Fork einen Channel bereitstellt, für den es keine typisierte Factory gibt. Dasselbe Verhalten für Bestätigungen, Wiederverbindungen, Nachrichten und Cleanup gilt auch für `subscribeRaw()`. Beenden Sie Dart-Stream-Listener separat und melden Sie anschließend die Channel-Subscription ab.

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

Eine explizit angegebene `id` muss unter den registrierten Subscriptions eindeutig sein und darf keine ID wiederverwenden, die in der aktuellen Verbindungsgeneration als Tombstone gespeichert ist.

`unsubscribe()` und `MisskeyClient.dispose()` können sicher wiederholt oder gleichzeitig aufgerufen werden. Es sind höchstens 32 aktive Subscriptions möglich. Nach dem Freigeben des Clients mit `dispose()` löst ein Zugriff auf `client.streaming` einen `StateError` aus.

Zur Migration siehe [Migration von misskey_streaming](./migration-from-misskey-streaming.md).
