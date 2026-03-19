---
sidebar_position: 2
title: Utilisateurs
---

# Utilisateurs

L'API `client.users` fournit des opérations pour rechercher des utilisateurs, gérer les relations d'abonnement, et gérer les blocages et mises en sourdine. La gestion du profil de l'utilisateur authentifié se trouve sous `client.account`.

## Récupération d'utilisateurs

### Par identifiant d'utilisateur

```dart
final user = await client.users.showOneByUserId('9abc');
print(user.name);     // Display name
print(user.username); // Username (without @)
print(user.host);     // null for local users, hostname for remote
```

### Par nom d'utilisateur

```dart
// Local user
final user = await client.users.showOneByUsername('alice');

// Remote user
final user = await client.users.showOneByUsername('alice', host: 'other.example.com');
```

### Plusieurs utilisateurs à la fois

```dart
final users = await client.users.showMany(
  userIds: ['9abc', '9def', '9ghi'],
);
```

### Liste d'utilisateurs (annuaire)

```dart
// Local users sorted by follower count
final users = await client.users.list(
  limit: 20,
  sort: '+follower',
  origin: 'local',
);
```

Valeurs `sort` disponibles : `+follower`, `-follower`, `+createdAt`, `-createdAt`, `+updatedAt`, `-updatedAt`.
Valeurs `origin` disponibles : `local`, `remote`, `combined`.

## Abonnés et abonnements

```dart
// Followers of a user (by ID)
final followers = await client.users.followersByUserId(userId, limit: 20);

// Followers of a user (by username)
final followers = await client.users.followersByUsername('alice', limit: 20);

// Accounts a user follows
final following = await client.users.followingByUserId(userId, limit: 20);
```

Paginez avec `sinceId` / `untilId` / `sinceDate` / `untilDate`.

## Notes d'un utilisateur

```dart
final notes = await client.users.notes(
  userId: userId,
  limit: 20,
  withReplies: false,
  withRenotes: true,
);
```

`withReplies` et `withFiles` ne peuvent pas être tous deux `true` simultanément (contrainte serveur).

## Opérations d'abonnement

### S'abonner à un utilisateur

```dart
final user = await client.following.create(userId: userId);
```

Si la cible nécessite une approbation, une demande est envoyée à la place.

### Se désabonner

```dart
await client.following.delete(userId: userId);
```

### Mettre à jour les paramètres d'abonnement

```dart
// Change notification level for a specific follow
await client.following.update(
  userId: userId,
  notify: 'normal', // 'normal' or 'none'
  withReplies: true,
);
```

### Supprimer un abonné

```dart
// Forcibly removes someone following you
await client.following.invalidate(userId: userId);
```

### Demandes d'abonnement

```dart
// List pending incoming requests
final requests = await client.following.requests.listReceived();

// Accept or reject
await client.following.requests.accept(userId: userId);
await client.following.requests.reject(userId: userId);

// Cancel an outgoing request you sent
await client.following.requests.cancel(userId: userId);
```

## Blocage

```dart
// Block a user (removes the mutual follow relationship)
await client.blocking.create(userId: userId);

// Unblock
await client.blocking.delete(userId: userId);

// List your blocked users
final blocked = await client.blocking.list(limit: 20);
```

## Mise en sourdine

```dart
// Mute a user
await client.mute.create(userId: userId);

// Mute with an expiry (Unix timestamp in milliseconds)
await client.mute.create(userId: userId, expiresAt: expiresAt);

// Unmute
await client.mute.delete(userId: userId);

// List your muted users
final muted = await client.mute.list(limit: 20);
```

## Gestion du compte

Les opérations de profil pour l'utilisateur authentifié se trouvent sous `client.account`.

### Récupérer son propre profil

```dart
final me = await client.account.i();
print(me.name);
print(me.description);
```

### Mettre à jour le profil

```dart
final updated = await client.account.update(
  name: 'Alice',
  description: 'Hello from Misskey!',
  lang: 'en',
);
```

Seuls les champs spécifiés sont modifiés ; les champs omis restent inchangés.

## Recherche d'utilisateurs

```dart
final results = await client.users.search(
  query: 'alice',
  limit: 20,
  origin: 'combined',
);
```

## Listes d'utilisateurs

Les listes d'utilisateurs sont accessibles via `client.users.lists` :

```dart
// Create a list
final list = await client.users.lists.create(name: 'Friends');

// Add a user to a list
await client.users.lists.push(listId: list.id, userId: userId);

// Remove a user from a list
await client.users.lists.pull(listId: list.id, userId: userId);

// Fetch your lists
final lists = await client.users.lists.list();

// Fetch members of a list
final members = await client.users.lists.getMemberships(listId: list.id);
```
