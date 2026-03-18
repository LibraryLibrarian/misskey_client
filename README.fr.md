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
- Journalisation configurable via une interface `Logger` interchangeable
- Dart pur — aucune dépendance Flutter requise

## Installation

Ajoutez le package à votre `pubspec.yaml` :

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.1
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
| `users` | Recherche d'utilisateurs, listes, relations, succès |

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

## Documentation

- Référence API : https://librarylibrarian.github.io/misskey_client/
- Page pub.dev : https://pub.dev/packages/misskey_client
- GitHub : https://github.com/LibraryLibrarian/misskey_client

## Licence

Voir [LICENSE](LICENSE).
