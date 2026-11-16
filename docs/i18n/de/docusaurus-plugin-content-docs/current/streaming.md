---
title: Streaming API
---

# Streaming API

Die integrierte Streaming API liefert Timelines, Benachrichtigungen und Updates erfasster Notes per WebSocket. `MisskeyClient.streaming` wird verzögert erstellt und verwendet Basis-URL, Token-Provider, Logger und Log-Einstellung des Clients gemeinsam.

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

Der Token-Provider wird bei jeder neuen Verbindung einschließlich Wiederverbindungen ausgewertet. So wird ein aktualisiertes Token wirksam, ohne den Client neu zu erstellen.

| Member | Zweck |
|---|---|
| `state` | Aktueller `MisskeyStreamingConnectionState` |
| `stateChanges` | Zustandsänderungen nach Registrierung des Listeners |
| `errors` | Asynchrone Transport-, Protokoll-, Timeout- und Abonnement-Fehler |
| `connect()` | Wiederverwendbare Verbindung öffnen |
| `disconnect()` | Verbindung schließen, ohne Abonnements oder den Streaming-Client freizugeben |
| `reconnect()` | Aktuelle Verbindung ersetzen |
| `dispose()` | Streaming-Client endgültig freigeben |

Registrieren Sie vor dem Verbindungsaufbau einen Listener für `errors`, wenn die Anwendung Fehler bei der automatischen Wiederverbindung oder beim erneuten Abonnieren behandeln soll.

## Offiziellen Channel abonnieren

Offizielle Channels verwenden typisierte Factorys von `MisskeyStreamingChannel`:

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

Bei bestehender Verbindung wird `subscribe()` abgeschlossen, nachdem der Server das Abonnement bestätigt hat. Das Handle bleibt über automatische Wiederverbindungen hinweg registriert und wird automatisch erneut abonniert.

Die API enthält typisierte Definitionen für `main`, die Startseiten-, lokale, hybride und globale Timeline, Benutzerlisten, Hashtags, Rollen, Antennen, Channels, Drive, Server- und Queue-Statistiken, Administration, Reversi sowie direkte und raumbasierte Chat-Channels.

## Event-Ansicht auswählen

Ein Abonnement bietet mehrere Ansichten der darüber weitergeleiteten Nachrichten:

| Stream | Inhalt |
|---|---|
| `messages` | Normalisierte `MisskeyStreamingMessage`-Werte mit ihren rohen dekodierten Envelopes |
| `events` | Typisierte `MisskeyStreamingEvent`-Werte |
| `notes` | Aus Note-Events extrahierte `MisskeyNote`-Werte |
| `notifications` | Aus Benachrichtigungs-Events extrahierte `MisskeyNotification`-Werte |

```dart
final noteListener = home.notes.listen((note) {
  print(note.text);
});

final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId hat $reaction erhalten');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('Nicht unterstütztes Event $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` bewahrt den normalisierten `type`, `body`, die ursprüngliche `raw`-Nachricht und den optionalen `decodeError`. Behalten Sie einen Fallback-Zweig bei, damit auch vom Server neu hinzugefügte Events sichtbar bleiben.

Der globale Stream `client.streaming.messages` bewahrt die äußeren Wire-Envelopes. Über ein Abonnement weitergeleitete Nachrichten werden auf ihr inneres Event normalisiert und enthalten die `subscriptionId` des jeweiligen Abonnements.

## Note-Updates erfassen

Erfassen Sie eine bekannte Note über das Handle, das ihre Updates erhalten soll:

```dart
home.captureNote(noteId);
// home.events kann jetzt reacted-, unreacted-, deleted- und pollVoted-Events ausgeben.

home.uncaptureNote(noteId);
```

Capture-Aufrufe werden über Abonnements hinweg referenzgezählt und nach Wiederverbindungen wiederhergestellt. Wiederholte Capture- oder Uncapture-Aufrufe auf demselben Handle sind idempotent.

## Fork-spezifische Channels

Verwenden Sie `subscribeRaw()`, wenn ein Misskey-Fork einen Channel bereitstellt, für den es keine typisierte Factory gibt.

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

Dasselbe Verhalten für Bestätigungen, Wiederverbindungen, Nachrichten und Cleanup gilt auch hier. Eine explizit angegebene ID muss unter den registrierten Abonnements eindeutig sein und darf keine ID wiederverwenden, die in der aktuellen Verbindungsgeneration als Tombstone gespeichert ist.

## Cleanup

Beenden Sie Dart-Stream-Listener separat und melden Sie anschließend das Channel-Abonnement ab.

```dart
await listener.cancel();
await forkChannel.unsubscribe();

await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();

await client.dispose();
```

`unsubscribe()` und `MisskeyClient.dispose()` können sicher wiederholt oder gleichzeitig aufgerufen werden. Ein Client unterstützt höchstens 32 aktive Streaming-Abonnements. Nach dem Freigeben des Clients löst ein Zugriff auf `client.streaming` einen `StateError` aus.

Zur Migration aus dem eigenständigen Paket siehe [Migration von misskey_streaming](./migration-from-misskey-streaming.md).
