---
sidebar_position: 4
title: Gestion des erreurs
---

# Gestion des erreurs

Cette bibliothèque mappe les erreurs de l'API Misskey vers une hiérarchie de classes scellées dont la racine est `MisskeyClientException`.

## Hiérarchie des exceptions

```
MisskeyClientException (sealed)
├── MisskeyApiException              // Erreurs générales de réponse HTTP
│   ├── MisskeyUnauthorizedException // 401 - Jeton invalide ou absent
│   ├── MisskeyForbiddenException    // 403 - Opération non autorisée
│   ├── MisskeyNotFoundException     // 404 - Ressource introuvable
│   ├── MisskeyRateLimitException    // 429 - Limite de débit atteinte
│   │   └── retryAfter               //   Durée d'attente suggérée par le serveur
│   ├── MisskeyValidationException   // 422 - Corps de requête invalide
│   └── MisskeyServerException       // 5xx - Erreur côté serveur
└── MisskeyNetworkException          // Délai dépassé, connexion refusée, etc.
```

`MisskeyApiException` contient également des champs spécifiques à Misskey :

- `code` — Chaîne de code d'erreur Misskey (par exemple `AUTHENTICATION_FAILED`, `NO_SUCH_NOTE`)
- `errorId` — UUID identifiant le type d'erreur Misskey
- `endpoint` — Le chemin de l'API où l'erreur s'est produite

## Modèles de capture de base

### Capturer toutes les erreurs

```dart
try {
  final note = await client.notes.show(noteId: '9xyz');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

### Gestion par statut HTTP

```dart
try {
  final note = await client.notes.show(noteId: noteId);
} on MisskeyNotFoundException {
  print('Note not found');
} on MisskeyUnauthorizedException {
  print('Token is invalid. Please re-authenticate');
} on MisskeyForbiddenException {
  print('You do not have permission to view this note');
} on MisskeyRateLimitException catch (e) {
  final wait = e.retryAfter ?? const Duration(seconds: 60);
  print('Rate limited. Retry after $wait');
} on MisskeyApiException catch (e) {
  print('API error (${e.statusCode}): ${e.message} [${e.code}]');
} on MisskeyNetworkException {
  print('Check your network connection');
}
```

### Inspection du code d'erreur Misskey

```dart
try {
  await client.following.create(userId: userId);
} on MisskeyApiException catch (e) {
  switch (e.code) {
    case 'ALREADY_FOLLOWING':
      print('Already following this user');
    case 'BLOCKING':
      print('Cannot follow a user you have blocked');
    default:
      rethrow;
  }
}
```

## Gestion des limites de débit

```dart
Future<T> withRetry<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on MisskeyRateLimitException catch (e) {
    final wait = e.retryAfter ?? const Duration(seconds: 60);
    await Future<void>.delayed(wait);
    return action();
  }
}

// Usage
final timeline = await withRetry(
  () => client.notes.timelineHome(limit: 20),
);
```

## Gestion des erreurs réseau

`MisskeyNetworkException` encapsule les échecs au niveau de la connexion, tels que les délais dépassés et les erreurs DNS. Le champ `cause` contient l'exception sous-jacente :

```dart
try {
  final notes = await client.notes.timelineLocal();
} on MisskeyNetworkException catch (e) {
  print('Network error at ${e.endpoint}: ${e.cause}');
}
```

Le client effectue automatiquement jusqu'à `MisskeyClientConfig.maxRetries` tentatives (par défaut : 3) pour les requêtes idempotentes avant de lever l'exception.
