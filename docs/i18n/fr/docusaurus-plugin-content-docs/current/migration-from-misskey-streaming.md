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

`MisskeyStreaming.fromClient()` n'est plus nécessaire. Utilisez `subscribeRaw()` pour un Channel propre à un fork et attendez avec `await` le nouvel `unsubscribe()` asynchrone.

Enveloppez un rappel existant `void oldLogger(String level, String message)` avec `FunctionLogger(oldLogger)`, transmettez-le comme `logger` du client et définissez `MisskeyClientConfig.enableLog` sur `true`.

| Ancienne API | API intégrée |
|---|---|
| `handle.stream` | `messages` / `events` / `notes` / `notifications` |
| `messagesFor(id)` | `messages` du handle correspondant |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| `status` / `isConnected` | `stateChanges` / `state == MisskeyStreamingConnectionState.connected` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `tokenProvider` / rappel `logger` | `tokenProvider` / `logger: FunctionLogger(oldLogger)` (`enableLog: true`) |
| Réglages de reconnexion | `MisskeyStreamingConfig` |
| `pingInterval` | Supprimé ; aucun réglage public de ping applicatif |
| `customHeaders` / `protocols` | Aucun réglage public intégré |
| `exceptionMapper` | Exceptions typées et `errors` |

La capture devient `home.captureNote(noteId)` / `home.uncaptureNote(noteId)`. Utilisez `disconnect()` pour réutiliser la connexion et `dispose()` ou `MisskeyClient.dispose()` pour la terminer. `sendToChannel()` n'a pas de remplacement public.

Consultez le [guide de l'API Streaming](./streaming.md) et la [référence de migration complète](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md).
