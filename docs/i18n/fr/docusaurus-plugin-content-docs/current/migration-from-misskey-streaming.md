---
title: Migration depuis misskey_streaming
---

# Migration depuis misskey_streaming

Streaming est désormais intégré à `misskey_client`. Après avoir migré tous les appels, supprimez la dépendance autonome `misskey_streaming` et utilisez la première version de `misskey_client` contenant l'issue #30.

## Client et souscription

```dart
// Avant
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
);
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
);

// Après
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

`MisskeyStreaming.fromClient()` n'est plus nécessaire. La connexion intégrée partage l'URL, le fournisseur de jeton, le logger et le réglage de journalisation de `MisskeyClient`. Utilisez `subscribeRaw()` pour un Channel propre à un fork et attendez avec `await` le nouvel `unsubscribe()` asynchrone.

Enveloppez un rappel existant `void oldLogger(String level, String message)` avec `FunctionLogger(oldLogger)`, transmettez-le comme `logger` du client et définissez `MisskeyClientConfig.enableLog` sur `true`.

| Ancienne API | API intégrée |
|---|---|
| `handle.stream` | `messages` / `events` / `notes` / `notifications` |
| `messagesFor(id)` | `messages` du handle correspondant |
| `MisskeyStreamingClient.messages` | `client.streaming.messages` (enveloppes externes) |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `uncaptureNote(handle.id, noteId)` | `handle.uncaptureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| Décodage typé manuel | `MisskeyStreamingEvent` et `MisskeyUnknownEvent` |
| `status` / `isConnected` | `stateChanges` / `state == MisskeyStreamingConnectionState.connected` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | argument `tokenProvider` de `MisskeyClient` |
| `debugLog` / rappel `logger` | `enableLog: true` / `logger: FunctionLogger(oldLogger)` du client |
| Réglages de reconnexion | `MisskeyStreamingConfig` |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `pingInterval` | Supprimé ; aucun réglage public de ping applicatif |
| `customHeaders` / `protocols` | Aucun réglage public intégré |
| `connector` | Injection réservée aux tests internes |
| `exceptionMapper` | Exceptions typées et `errors` |

La capture devient `home.captureNote(noteId)` / `home.uncaptureNote(noteId)`. Utilisez `disconnect()` pour réutiliser la connexion et `dispose()` ou `MisskeyClient.dispose()` pour la terminer. `MisskeyClient.dispose()` est idempotent et ferme à la fois les ressources Streaming initialisées et le transport HTTP. `sendToChannel()` n'a pas de remplacement public. Ouvrez une issue si un protocole amont ou propre à un fork nécessite l'envoi d'événements au Channel.

Consultez le [guide de l'API Streaming](./streaming.md) et la [référence de migration complète](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md).
