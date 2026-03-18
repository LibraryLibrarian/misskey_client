---
sidebar_position: 1
slug: /
title: Premiers pas
---

# Premiers pas

misskey_client est une bibliothèque cliente Misskey API écrite en Dart pur.
Elle fonctionne dans tout environnement Dart : Flutter, Dart côté serveur, outils CLI, et bien d'autres.

## Installation

Ajoutez la dépendance à votre `pubspec.yaml` :

```yaml
dependencies:
  misskey_client: ^0.0.1
```

Puis récupérez-la :

```bash
dart pub get
```

## Utilisation de base

### Initialisation du client

```dart
import 'package:misskey_client/misskey_client.dart';

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_access_token',
);
```

`baseUrl` doit être un `Uri` incluant le schéma (par exemple `https://`).
`tokenProvider` est un rappel qui retourne un `FutureOr<String?>`. Il peut être omis si vous n'utilisez que des points d'accès ne nécessitant pas d'authentification.

### Votre premier appel API

Récupérer les informations du serveur (aucune authentification requise) :

```dart
final serverInfo = await client.meta.fetch();
print(serverInfo.name);        // Nom du serveur
print(serverInfo.description); // Description du serveur
```

Récupérer le compte de l'utilisateur authentifié :

```dart
final me = await client.account.i();
print(me.name);     // Nom d'affichage
print(me.username); // Nom d'utilisateur (sans @)
```

### Structure de l'API

Chaque domaine d'API est exposé en tant que propriété de `MisskeyClient` :

```dart
client.account       // Gestion du compte et du profil (/api/i/*)
client.announcements // Annonces du serveur
client.antennas      // Gestion des antennes (surveillance par mots-clés)
client.ap            // Points d'accès ActivityPub
client.blocking      // Blocage d'utilisateurs
client.channels      // Gestion des canaux
client.charts        // Graphiques statistiques
client.chat          // Messagerie directe
client.clips         // Gestion des clips de notes
client.drive         // Stockage de fichiers (drive.files, drive.folders, drive.stats)
client.federation    // Informations sur les instances fédérées
client.flash         // Gestion de Play (Flash)
client.following     // Opérations d'abonnement / désabonnement
client.gallery       // Gestion des publications de galerie
client.hashtags      // Informations sur les hashtags
client.invite        // Gestion des codes d'invitation
client.meta          // Métadonnées du serveur
client.mute          // Mise en sourdine d'utilisateurs
client.notes         // Opérations sur les notes (fils d'actualité, création, réactions, etc.)
client.notifications // Récupération et gestion des notifications
client.pages         // Gestion des pages
client.renoteMute    // Gestion de la mise en sourdine des renotes
client.roles         // Gestion des rôles
client.sw            // Enregistrement des notifications push Service Worker
client.users         // Recherche d'utilisateurs, listes d'abonnements, listes d'utilisateurs
```

### Contrôle des journaux

Les journaux des requêtes et réponses HTTP sont désactivés par défaut. Activez-les via `MisskeyClientConfig` :

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

Pour rediriger les journaux vers votre propre destination, passez une implémentation de `Logger` au constructeur :

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level is one of: 'debug', 'info', 'warn', 'error'
    myLogger.log(level, message);
  }),
);
```

Consultez [Journalisation](./advanced/logging.md) pour plus de détails.

## Étapes suivantes

- [Authentification](./authentication.md) — Authentification par jeton et flux MiAuth
- [Gestion des erreurs](./error-handling.md) — Hiérarchie des exceptions et modèles de capture
- [Notes](./api/notes.md) — Créer et récupérer des notes
- [Téléversement Drive](./advanced/drive-upload.md) — Téléverser des fichiers vers le Drive
