---
title: API Streaming
---

# API Streaming

L'API Streaming intégrée fournit les fils d'actualité, notifications et mises à jour de Notes capturées par WebSocket. `MisskeyClient.streaming` est créé à la demande et partage l'URL de base, le fournisseur de jeton, le logger et le réglage de journalisation du client.

## Configuration et connexion

Ne passez `MisskeyStreamingConfig` que si vous devez modifier le comportement de connexion.

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

Le fournisseur de jeton est évalué à chaque nouvelle connexion, reconnexions comprises. Cela permet de prendre en compte un jeton actualisé sans recréer le client.

| Membre | Rôle |
|---|---|
| `state` | `MisskeyStreamingConnectionState` actuel |
| `stateChanges` | Changements survenant après le début de l'écoute |
| `errors` | Erreurs asynchrones de transport, de protocole, de dépassement de délai et de souscription |
| `connect()` | Ouvrir la connexion réutilisable |
| `disconnect()` | Fermer la connexion sans libérer les souscriptions ni le client Streaming |
| `reconnect()` | Remplacer la connexion actuelle |
| `dispose()` | Libérer définitivement le client Streaming |

Écoutez `errors` avant de vous connecter si l'application doit gérer les échecs de reconnexion automatique ou de renouvellement des souscriptions.

## Souscrire à un Channel officiel

Les Channels officiels utilisent les fabriques typées de `MisskeyStreamingChannel` :

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

Lorsque la connexion est établie, `subscribe()` se termine après l'accusé de réception de la souscription par le serveur. Le handle reste enregistré au fil des reconnexions automatiques et sa souscription est automatiquement rétablie.

L'API comprend des définitions typées pour `main`, les fils personnel, local, hybride et global, les listes d'utilisateurs, hashtags, rôles, antennes, Channels, Drive, statistiques du serveur et de la file d'attente, administration, Reversi, ainsi que les Channels de Chat direct ou en salon.

## Choisir une vue des événements

Une souscription expose plusieurs vues des messages qui lui sont acheminés :

| Flux | Contenu |
|---|---|
| `messages` | `MisskeyStreamingMessage` normalisés avec leurs enveloppes brutes décodées |
| `events` | `MisskeyStreamingEvent` typés |
| `notes` | `MisskeyNote` extraites des événements de Note |
| `notifications` | `MisskeyNotification` extraites des événements de notification |

```dart
final noteListener = home.notes.listen((note) {
  print(note.text);
});

final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId a reçu $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('Événement non pris en charge $type : $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent` conserve son `type` normalisé, `body`, le message source `raw` et l'éventuel `decodeError`. Conservez une branche de repli pour que les événements ajoutés par le serveur restent observables.

Le flux global `client.streaming.messages` conserve les enveloppes réseau externes. Les messages acheminés via une souscription sont normalisés vers leur événement interne et portent le `subscriptionId` de cette souscription.

## Capturer les mises à jour d'une Note

Capturez une Note connue via le handle qui doit recevoir ses mises à jour :

```dart
home.captureNote(noteId);
// home.events peut désormais émettre des événements reacted, unreacted, deleted et pollVoted.

home.uncaptureNote(noteId);
```

Les appels de capture sont comptés par référence entre souscriptions et restaurés après reconnexion. Les appels répétés de capture ou de fin de capture sur le même handle sont idempotents.

## Channels propres aux forks

Utilisez `subscribeRaw()` lorsqu'un fork de Misskey expose un Channel sans fabrique typée.

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

Les mêmes comportements d'accusé de réception, de reconnexion, de message et de nettoyage s'appliquent. Un ID explicite doit être unique parmi les souscriptions enregistrées et ne peut pas réutiliser un ID conservé comme tombstone dans la génération de connexion actuelle.

## Nettoyage

Annulez séparément les écouteurs de flux Dart, puis résiliez la souscription au Channel.

```dart
await listener.cancel();
await forkChannel.unsubscribe();

await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();

await client.dispose();
```

`unsubscribe()` et `MisskeyClient.dispose()` peuvent être appelés plusieurs fois ou simultanément en toute sécurité. Un client prend en charge au maximum 32 souscriptions Streaming actives. Après la libération du client, tout accès à `client.streaming` lève une `StateError`.

Pour migrer depuis le package autonome, consultez [Migration depuis misskey_streaming](./migration-from-misskey-streaming.md).
