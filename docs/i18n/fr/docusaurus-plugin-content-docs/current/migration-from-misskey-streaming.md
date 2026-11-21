---
title: Migration depuis misskey_streaming
---

# Migration depuis misskey_streaming

Streaming est désormais intégré à `misskey_client`. Après avoir migré tous les appels, supprimez la dépendance autonome `misskey_streaming` et utilisez la première version de `misskey_client` contenant l'Issue #30.

## Créer le client intégré

```dart
// Avant
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
  enableAutoReconnect: true,
  debugLog: true,
);

// Après
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

`MisskeyStreaming.fromClient()` n'est plus nécessaire. La connexion intégrée partage l'URL, le fournisseur de jeton, le logger et le réglage de journalisation de `MisskeyClient`.

Enveloppez un rappel existant `void oldLogger(String level, String message)` avec `FunctionLogger(oldLogger)`, transmettez-le comme `logger` du client et définissez `MisskeyClientConfig.enableLog` sur `true`.

## Remplacer les appels de souscription et de capture

```dart
// Avant
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
  params: {'withRenotes': true},
);
handle.stream.listen((message) => print(message.body));
streaming.captureNote(handle.id, noteId);

// Après
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(withRenotes: true),
);
home.messages.listen((message) => print(message.body));
home.captureNote(noteId);
```

Utilisez `subscribeRaw(channel: ..., params: ..., id: ...)` pour un Channel propre à un fork. `unsubscribe()` est désormais asynchrone : attendez sa fin avec `await`.

| Ancienne API | API intégrée |
|---|---|
| `MisskeySubscriptionHandle.stream` | `messages`, `events`, `notes` ou `notifications` du handle |
| `MisskeyStreamingClient.messagesFor(id)` | `messages` du handle correspondant |
| `MisskeyStreamingClient.messages` | `client.streaming.messages` (enveloppes externes) |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `uncaptureNote(handle.id, noteId)` | `handle.uncaptureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| Décodage typé manuel | `MisskeyStreamingEvent` et `MisskeyUnknownEvent` |

## Correspondance du cycle de vie et de la configuration

| Ancienne API | API intégrée |
|---|---|
| Flux `status` | `stateChanges` ainsi que le `state` actuel |
| `isConnected` | `state == MisskeyStreamingConnectionState.connected` |
| Champs de reconnexion | Les mêmes champs dans `MisskeyStreamingConfig` |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | argument `tokenProvider` de `MisskeyClient` |
| `debugLog` / rappel `logger` | `enableLog: true` / `logger: FunctionLogger(oldLogger)` du client |
| `pingInterval` | Supprimé ; aucun minuteur public de ping applicatif |
| `customHeaders` / `protocols` | Aucun réglage public intégré |
| `connector` | Injection réservée aux tests internes |
| `exceptionMapper` | Exceptions Streaming typées et flux `errors` |

Utilisez `disconnect()` si la connexion doit être réutilisée. Pour terminer, appelez `dispose()` afin de la libérer définitivement, ou libérez le `MisskeyClient` qui la possède. `MisskeyClient.dispose()` est idempotent et ferme à la fois les ressources Streaming initialisées et le transport HTTP.

`sendToChannel()` n'a pas de remplacement public dans l'API intégrée. Ouvrez une Issue si un protocole amont ou propre à un fork nécessite l'envoi d'événements au Channel.

Pour des exemples complets et les détails des événements, consultez le [guide de l'API Streaming](./streaming.md). La racine du dépôt contient également la [référence de migration complète](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md).
