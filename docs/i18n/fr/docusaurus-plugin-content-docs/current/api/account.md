---
sidebar_position: 4
title: "Compte & Profil"
---

# Compte & Profil

L'API `client.account` fournit des opérations pour l'utilisateur actuellement authentifié — récupération et mise à jour des informations de profil, gestion des identifiants, exportation/importation de données, et accès aux sous-API pour le registre, l'authentification à deux facteurs et les webhooks.

## Récupérer votre profil

```dart
final me = await client.account.i();
print(me.name);        // Display name
print(me.username);    // Username (without @)
print(me.description); // Bio text
```

## Mettre à jour votre profil

`update` accepte n'importe quelle combinaison de champs. Seuls les champs que vous transmettez sont envoyés au serveur ; les champs omis restent inchangés, et le `MisskeyUser` mis à jour est retourné.

```dart
final updated = await client.account.update(
  name: Optional('Alice'),
  description: Optional('Hello from Misskey!'),
  lang: Optional('en'),
  isLocked: false,
);
```

### Le type Optional

Les champs que le serveur peut accepter comme `null` (pour effacer la valeur) utilisent l'enveloppe `Optional<T>`. Cela permet à la bibliothèque de distinguer trois états :

- Paramètre omis — le champ n'est pas inclus dans la requête ; la valeur côté serveur reste inchangée.
- `Optional('value')` — le champ est défini à la valeur donnée.
- `Optional.null_()` — le champ est explicitement effacé.

```dart
// Set the avatar to a Drive file and clear the birthday
await client.account.update(
  avatarId: Optional('driveFileId123'),
  birthday: Optional.null_(),
);
```

### Confidentialité et visibilité

```dart
await client.account.update(
  followingVisibility: 'followers', // 'public', 'followers', or 'private'
  followersVisibility: 'public',
  publicReactions: true,
  isLocked: true,                   // require follow approval
  hideOnlineStatus: true,
  noCrawle: true,
  preventAiLearning: true,
);
```

## Épingler et désépingler des notes

```dart
// Pin a note to your profile
final updated = await client.account.pin(noteId: noteId);

// Unpin it
final updated = await client.account.unpin(noteId: noteId);
```

Les deux méthodes retournent le `MisskeyUser` mis à jour.

## Favoris

```dart
final favs = await client.account.favorites(limit: 20);
for (final fav in favs) {
  print(fav.note?.text);
}
```

Paginez avec `sinceId` / `untilId` ou `sinceDate` / `untilDate` (horodatage Unix en millisecondes).

```dart
final older = await client.account.favorites(
  limit: 20,
  untilId: favs.last.id,
);
```

## Gestion du mot de passe, de l'email et des jetons

### Changer de mot de passe

```dart
await client.account.changePassword(
  currentPassword: 'hunter2',
  newPassword: 'correct-horse-battery-staple',
);
```

Si l'authentification à deux facteurs est activée, passez le code TOTP actuel via `token`.

### Mettre à jour l'adresse email

```dart
final updated = await client.account.updateEmail(
  password: 'mypassword',
  email: Optional('newemail@example.com'),
);

// Remove the email address
await client.account.updateEmail(
  password: 'mypassword',
  email: Optional.null_(),
);
```

### Régénérer le jeton API

Le jeton actuel est invalidé immédiatement après la fin de l'appel.

```dart
await client.account.regenerateToken(password: 'mypassword');
```

### Révoquer un jeton

```dart
await client.account.revokeTokenById(tokenId);
await client.account.revokeTokenByToken(tokenString);
```

`revokeTokenById` prend l’identifiant de l’enregistrement du jeton (par exemple, obtenu avec `client.account.apps()`), tandis que `revokeTokenByToken` prend la chaîne du jeton. Ce point d’accès a été ajouté dans Misskey 12.27.0, et la forme utilisant une chaîne dans 2023.11.0. Les deux formes sont prises en charge à partir de 2026.5.1.

L’authentification est requise. Misskey 2026.5.1 et 2026.7.0 nécessitent le jeton API principal de l’utilisateur. Depuis Misskey 2026.9.0, un jeton d’accès d’une application tierce peut se révoquer lui-même en passant son propre identifiant ou sa propre chaîne ; il ne peut pas révoquer un autre jeton d’accès du même utilisateur. Un jeton API principal peut révoquer tout jeton d’accès appartenant à cet utilisateur.

Les deux méthodes ne renvoient aucun contenu (HTTP 204). Une cible absente ou appartenant à un autre utilisateur, ainsi qu’une chaîne de jeton vide, ne modifient rien. Depuis Misskey 2026.9.0, les erreurs courantes sont `CREDENTIAL_REQUIRED` (aucun identifiant d’authentification) et `PERMISSION_DENIED` (un jeton d’accès tente de révoquer un autre jeton du même utilisateur).

## Exportation et importation

Toutes les opérations d'exportation sont mises en file d'attente en tant que tâches asynchrones. Une notification est envoyée à l'achèvement.

### Exportation des données

```dart
await client.account.exportNotes();
await client.account.exportFollowing(excludeMuting: true, excludeInactive: true);
await client.account.exportBlocking();
await client.account.exportMute();
await client.account.exportFavorites();
await client.account.exportAntennas();
await client.account.exportClips();
await client.account.exportUserLists();
```

### Importation des données

Passez l’identifiant Drive du fichier préalablement exporté.

```dart
// Upload the file to Drive first, then pass its ID
await client.account.importFollowing(fileId: driveFileId, withReplies: true);
await client.account.importBlocking(fileId: driveFileId);
await client.account.importMuting(fileId: driveFileId);
await client.account.importAntennas(fileId: driveFileId);
await client.account.importUserLists(fileId: driveFileId);
```

## Historique des connexions

```dart
final history = await client.account.signinHistory(limit: 20);
for (final entry in history) {
  print('${entry.createdAt} — ${entry.ip}');
}
```

## Sous-APIs

`AccountApi` expose trois sous-APIs en tant que propriétés.

### Registre

Le registre stocke des données clé-valeur arbitraires pour les applications clientes (équivalent au localStorage du navigateur, mais synchronisé entre les appareils).

Si vous stockez `null` avec `registry.set`, `registry.get` renvoie `null`. Une chaîne stockée est renvoyée telle quelle, sans guillemets supplémentaires.

```dart
// Read a value
final value = await client.account.registry.get(
  key: 'theme',
  scope: ['my-app'],
);

// Write a value
await client.account.registry.set(
  key: 'theme',
  value: 'dark',
  scope: ['my-app'],
);
```

### Authentification à deux facteurs

```dart
// Begin TOTP registration
final reg = await client.account.twoFactor.register(password: 'mypassword');
final qr = reg.qr ?? generateQrDataUrl(reg.url);
print(qr); // QR code data URL to show in the UI

// Confirm and activate TOTP with the first code from the authenticator app
await client.account.twoFactor.done(token: '123456');
```

Depuis Misskey 2026.11.0, `qr` n’est plus renvoyé. Dans cet exemple, `generateQrDataUrl` est une fonction à fournir dans votre application qui utilise une bibliothèque de codes QR pour encoder l’URL `otpauth` de `reg.url` en URL de données d’une image QR.

### Webhooks

```dart
// Create a webhook
final webhook = await client.account.webhooks.create(
  name: 'My webhook',
  url: 'https://example.com/hook',
  on: ['note', 'follow'],
  secret: 'supersecret',
);

// List webhooks
final webhooks = await client.account.webhooks.list();
```
