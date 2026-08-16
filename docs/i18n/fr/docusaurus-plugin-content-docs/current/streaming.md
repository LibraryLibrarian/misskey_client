---
title: API Streaming
---

# API Streaming

L'API Streaming intégrée fournit les fils d'actualité, notifications et mises à jour de Notes capturées par WebSocket. `MisskeyClient.streaming` est créé à la demande et partage l'URL, le fournisseur de jeton, le logger et le réglage de journalisation du client.

## Configuration et connexion

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

Le fournisseur de jeton est évalué à chaque nouvelle connexion, reconnexions comprises. `state` donne l'état actuel, `stateChanges` les changements ultérieurs et `errors` les erreurs asynchrones de transport, protocole et souscription. `connect()`, `disconnect()` et `reconnect()` contrôlent la connexion réutilisable ; `dispose()` y met fin définitivement.

## Souscrire à un Channel officiel

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

Pendant une connexion, `subscribe()` se termine après l'accusé `connected` du serveur. Les souscriptions sont renvoyées après une reconnexion automatique. Des définitions typées couvrent le Channel principal, les fils, listes, hashtags, rôles, antennes, Channels, Drive, statistiques, administration, Reversi et Chat.

## Choisir une vue des événements

| Flux | Contenu |
|---|---|
| `messages` | `MisskeyStreamingMessage` normalisés avec leur enveloppe brute |
| `events` | `MisskeyStreamingEvent` typés |
| `notes` | `MisskeyNote` extraites des événements |
| `notifications` | `MisskeyNotification` extraites des événements |

```dart
final noteListener = home.notes.listen((note) => print(note.text));
final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId: $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('Événement non pris en charge $type : $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` conserve `type`, `body`, le message source `raw` et l'éventuel `decodeError`. Le flux global `client.streaming.messages` conserve l'enveloppe réseau externe ; les `messages` d'une souscription sont normalisés vers l'événement interne.

## Capturer les mises à jour d'une Note

```dart
home.captureNote(noteId);
// events reçoit reacted, unreacted, deleted et pollVoted.
home.uncaptureNote(noteId);
```

Les captures sont comptées par référence entre souscriptions et restaurées après reconnexion. Les appels répétés sur le même handle sont idempotents.

## Channels propres aux forks et nettoyage

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

`unsubscribe()` et `MisskeyClient.dispose()` peuvent être appelés plusieurs fois ou simultanément. La limite est de 32 souscriptions actives.

Pour migrer, consultez [Migration depuis misskey_streaming](./migration-from-misskey-streaming.md).
