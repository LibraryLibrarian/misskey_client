[English](README.md) | [日本語](README.ja.md) | [简体中文](README.zh-Hans.md) | [Deutsch](README.de.md) | Français | [한국어](README.ko.md)

# misskey_client

Une bibliothèque cliente Dart pure pour l'API [Misskey](https://misskey-hub.net/). Fournit un accès typé à 25 domaines d'API avec authentification intégrée, logique de réessai et gestion structurée des erreurs.

> **Bêta** : L'implémentation de l'API est complète mais la couverture de tests est minimale. Les modèles de réponse et les signatures de méthodes peuvent évoluer suite aux résultats des tests. Voir le [CHANGELOG](CHANGELOG.md) pour plus de détails.

## Fonctionnalités

- Couverture de 25 domaines de l'API Misskey (Notes, Drive, utilisateurs, Channels, Chat, etc.)
- Authentification par jeton via un callback `TokenProvider` interchangeable
- Réessai automatique avec un nombre maximum de tentatives configurable
- Hiérarchie d'exceptions scellées pour une gestion exhaustive des erreurs
- Modèles de requête et de réponse fortement typés générés avec `json_serializable`
- API Streaming intégrée avec Channels et événements typés, et reconnexion automatique
- Journalisation configurable via une interface `Logger` interchangeable
- Dart pur — aucune dépendance Flutter requise

## Installation

Ajoutez le package à votre `pubspec.yaml` :

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.7
```

Puis exécutez :

```
dart pub get
```

## Démarrage rapide

```dart
import 'package:misskey_client/misskey_client.dart';

void main() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
      timeout: Duration(seconds: 10),
      maxRetries: 3,
    ),
    // Fournissez votre jeton d'accès. Le callback peut être asynchrone.
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  );

  // Récupérer les Notes de l'utilisateur authentifié
  final notes = await client.notes.getTimeline();
  for (final note in notes) {
    print(note.text);
  }
}
```

## Aperçu de l'API

`MisskeyClient` expose les propriétés suivantes, chacune couvrant un domaine distinct de l'API Misskey :

| Propriété | Description |
|---|---|
| `account` | Gestion du compte et du profil, registre, 2FA, webhooks |
| `announcements` | Annonces du serveur |
| `antennas` | Gestion des antennes (flux basés sur des mots-clés) |
| `ap` | Utilitaires ActivityPub |
| `blocking` | Blocage d'utilisateurs |
| `channels` | Channels et silencieux de Channels |
| `charts` | Graphiques statistiques |
| `chat` | Salons de Chat et messages |
| `clips` | Collections de Clips |
| `drive` | Drive (stockage de fichiers), fichiers, dossiers, statistiques |
| `federation` | Informations sur les instances fédérées |
| `flash` | Scripts Flash (Play) |
| `following` | Abonnements et demandes d'abonnement |
| `gallery` | Publications de galerie |
| `hashtags` | Recherche de hashtags et tendances |
| `invite` | Codes d'invitation |
| `meta` | Métadonnées du serveur |
| `mute` | Silencieux d'utilisateurs |
| `notes` | Notes, Reactions, sondages, recherche, fil d'actualité |
| `notifications` | Notifications |
| `pages` | Pages |
| `renoteMute` | Silencieux de Renotes |
| `roles` | Attributions de rôles |
| `sw` | Notifications push (Service Worker) |
| `streaming` | Fils d'actualité, notifications et mises à jour de Notes capturées en temps réel |
| `users` | Recherche d'utilisateurs, listes, relations, succès |

## API Streaming

La connexion `client.streaming`, créée à la demande, partage le serveur, le fournisseur de jeton et le logger du client. Abonnez-vous avec un `MisskeyStreamingChannel` typé et choisissez le niveau adapté : `notes` et `notifications` décodées, `events` typés ou `messages` sans perte d'information.

```dart
Future<void> streamHomeTimeline() async {
  final client = MisskeyClient(
    config: MisskeyClientConfig(
      baseUrl: Uri.parse('https://misskey.example.com'),
    ),
    tokenProvider: () => 'YOUR_ACCESS_TOKEN',
    streamingConfig: MisskeyStreamingConfig(maxReconnectAttempts: 5),
  );

  await client.streaming.connect();
  final home = await client.streaming.subscribe(
    const MisskeyStreamingChannel.homeTimeline(
      withRenotes: true,
      withFiles: false,
    ),
  );

  final notesSubscription = home.notes.listen((note) {
    print(note.text);
  });
  final eventsSubscription = home.events.listen((event) {
    if (event is MisskeyNoteReactedEvent) {
      print('${event.noteId}: ${event.reaction}');
    }
  });

  // Capturer une Note connue pour recevoir les Reactions, suppressions et votes.
  home.captureNote('NOTE_ID');

  await notesSubscription.cancel();
  await eventsSubscription.cancel();
  home.uncaptureNote('NOTE_ID');
  await home.unsubscribe();
  await client.dispose();
}
```

Utilisez `subscribeRaw(channel: ..., params: ...)` pour les Channels propres à un fork. La méthode renvoie le même handle de souscription, avec le flux `messages`. `connect()`, `disconnect()` et `reconnect()` contrôlent une connexion réutilisable ; `dispose()` y met fin définitivement. Les états de connexion sont accessibles via `state` et `stateChanges`, tandis que les erreurs asynchrones sont signalées via `errors`.

## Authentification

Passez un callback `TokenProvider` lors de la construction du client. Le callback retourne `FutureOr<String?>`, ce qui prend en charge les sources de jetons synchrones et asynchrones :

```dart
// Jeton synchrone
final client = MisskeyClient(
  config: config,
  tokenProvider: () => secureStorage.readSync('token'),
);

// Jeton asynchrone
final client = MisskeyClient(
  config: config,
  tokenProvider: () async => await secureStorage.read('token'),
);
```

Les points de terminaison nécessitant une authentification injectent le jeton automatiquement. Les points de terminaison à authentification facultative attachent le jeton lorsqu'il est disponible.

## Gestion des erreurs

Toutes les exceptions étendent la classe scellée `MisskeyClientException`, permettant un filtrage par correspondance de motifs exhaustif :

```dart
try {
  final user = await client.users.show(userId: 'abc123');
} on MisskeyUnauthorizedException {
  // 401 — jeton invalide ou manquant
} on MisskeyForbiddenException {
  // 403 — opération non autorisée
} on MisskeyNotFoundException {
  // 404 — ressource introuvable
} on MisskeyRateLimitException catch (e) {
  // 429 — limite de débit atteinte ; vérifier e.retryAfter
} on MisskeyValidationException {
  // 422 — corps de requête invalide
} on MisskeyServerException {
  // 5xx — erreur côté serveur
} on MisskeyNetworkException {
  // Délai d'attente, connexion refusée, etc.
}
```

## Journalisation

Activez le journal stdout intégré via `MisskeyClientConfig.enableLog`, ou fournissez une implémentation `Logger` personnalisée :

```dart
class MyLogger implements Logger {
  @override void debug(String message) { /* ... */ }
  @override void info(String message)  { /* ... */ }
  @override void warn(String message)  { /* ... */ }
  @override void error(String message, [Object? error, StackTrace? stackTrace]) { /* ... */ }
}

final client = MisskeyClient(
  config: MisskeyClientConfig(baseUrl: Uri.parse('https://misskey.example.com')),
  logger: MyLogger(),
);
```

## Migration depuis misskey_api_core

### Correspondance des API

| misskey_api_core | misskey_client |
|---|---|
| `MisskeyHttpClient(config: ..., tokenProvider: ...)` | `MisskeyClient(config: ..., tokenProvider: ...)` |
| `MisskeyApiConfig(baseUrl: ...)` | `MisskeyClientConfig(baseUrl: ...)` |
| `http.send<T>('/emojis', ...)` | La méthode typée correspondante, par exemple `client.meta.getEmojis()` |
| `MetaClient(http).getMeta()` | `client.meta.getMeta()` |
| `MisskeyApiException` | La hiérarchie scellée comprenant `MisskeyApiException`, `MisskeyUnauthorizedException`, `MisskeyForbiddenException`, `MisskeyRateLimitException`, etc. |
| `RequestOptions(authRequired: false)` | Géré en interne par les méthodes typées ; aucun paramètre n'est nécessaire côté appelant |
| `Logger` / `FunctionLogger` | Classes portant les mêmes noms |
| `kReleaseMode` / `kDebugMode` | Non inclus dans l'API publique ; voir ci-dessous |

### Conflit de nom MisskeyApiException

Les deux packages définissent `MisskeyApiException`, mais les classes ont un contenu différent et aucune relation d'héritage. La version de `misskey_api_core` est une classe simple, tandis que celle de `misskey_client` étend `MisskeyClientException` et exige un `statusCode`. Lorsque les deux packages sont importés pendant la migration, utilisez un préfixe pour éviter le conflit :

```dart
import 'package:misskey_api_core/misskey_api_core.dart' as core;
```

### Constantes du mode de compilation

`misskey_api_core` exportait `kReleaseMode` et `kDebugMode`, mais `misskey_client` ne les inclut pas dans son API publique. Il s'agit d'utilitaires généraux sans rapport avec Misskey. Les applications Flutter doivent utiliser ceux de `package:flutter/foundation.dart` ; les applications Dart pur peuvent utiliser `bool.fromEnvironment('dart.vm.product')`. Pour contrôler la journalisation du client, transmettez la valeur à `MisskeyClientConfig.enableLog`, par exemple `enableLog: kDebugMode`.

### Accès HTTP de bas niveau

L'équivalent de bas niveau de `MisskeyHttpClient.send<T>()` n'est pas public. `misskey_client` couvre 25 domaines d'API ; utilisez donc les méthodes typées. Si un point de terminaison nécessaire manque, veuillez le signaler dans une issue GitHub afin qu'il soit ajouté à l'API typée.

## Migration depuis misskey_streaming

Streaming est désormais intégré à `misskey_client`. Consultez le [guide de migration](MIGRATION_FROM_MISSKEY_STREAMING.md) pour la correspondance des dépendances, de la configuration, des souscriptions, des événements, de la capture de Notes et du cycle de vie depuis le package autonome `misskey_streaming`.

## Documentation

- Référence API : https://librarylibrarian.github.io/misskey_client/
- Page pub.dev : https://pub.dev/packages/misskey_client
- GitHub : https://github.com/LibraryLibrarian/misskey_client

## Licence

Voir [LICENSE](LICENSE).
