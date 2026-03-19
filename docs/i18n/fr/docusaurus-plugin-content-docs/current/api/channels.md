---
sidebar_position: 6
title: "Canaux & Antennes"
---

# Canaux & Antennes

Les canaux sont des espaces thématiques où les notes ne sont visibles qu'au sein de ce canal. Les antennes sont des filtres de fil d'actualité personnalisés qui collectent automatiquement les notes correspondant à vos critères.

## Canaux

L'API `client.channels` gère toutes les opérations sur les canaux. La sous-API `client.channels.mute` gère les mises en sourdine de canaux.

### Créer et mettre à jour un canal

```dart
final channel = await client.channels.create(
  name: 'Tech Talk',
  description: 'Discussions about software and technology.',
  color: '#3498db',
);

// Update — only the specified fields change
await client.channels.update(
  channelId: channel.id,
  name: 'Tech Talk (v2)',
  isArchived: false,
  pinnedNoteIds: [noteId1, noteId2],
);
```

Champs optionnels pour `create` : `bannerId` (identifiant de fichier Drive), `isSensitive`, `allowRenoteToExternal`.

### Fil d'actualité d'un canal

```dart
final notes = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
);

// Older notes
final older = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
  untilId: notes.last.id,
);
```

Toutes les méthodes de fil d'actualité acceptent également `sinceId`, `sinceDate` et `untilDate`.

### Suivre, mettre en favori et découvrir

```dart
await client.channels.follow(channelId: channelId);
await client.channels.unfollow(channelId: channelId);

await client.channels.favorite(channelId: channelId);
await client.channels.unfavorite(channelId: channelId);

// Channels the authenticated user has favorited
final favorites = await client.channels.myFavorites();

// Discovery listings
final featured = await client.channels.featured();
final followed = await client.channels.followed(limit: 20);
final owned    = await client.channels.owned(limit: 20);
```

### Recherche

```dart
// Search name and description (default)
final results = await client.channels.search(query: 'gaming', limit: 20);

// Name only
final results = await client.channels.search(
  query: 'gaming',
  type: 'nameOnly',
);
```

## Mises en sourdine de canaux

```dart
// Mute indefinitely
await client.channels.mute.create(channelId: channelId);

// Mute with expiry (Unix timestamp in milliseconds)
await client.channels.mute.create(
  channelId: channelId,
  expiresAt: DateTime.now()
      .add(const Duration(days: 7))
      .millisecondsSinceEpoch,
);

await client.channels.mute.delete(channelId: channelId);

final muted = await client.channels.mute.list();
```

## Antennes

Les antennes collectent automatiquement des notes depuis l'ensemble du serveur en fonction de mots-clés, d'utilisateurs ou de listes.

### Créer une antenne

`keywords` utilise une correspondance OU-externe / ET-interne : chaque liste interne est un groupe ET, les listes externes se combinent avec OU.

```dart
final antenna = await client.antennas.create(
  name: 'Dart news',
  src: 'all',             // 'home' | 'all' | 'users' | 'list' | 'users_blacklist'
  keywords: [
    ['dart', 'flutter'], // matches notes containing both "dart" AND "flutter"
    ['misskey'],          // OR notes containing "misskey"
  ],
  excludeKeywords: [['spam']],
  users: [],
  caseSensitive: false,
  withReplies: false,
  withFile: false,
);
```

Pour restreindre à une liste d'utilisateurs, définissez `src: 'list'` et passez `userListId`.

### Récupérer les notes d'une antenne

```dart
final notes = await client.antennas.notes(antennaId: antenna.id, limit: 20);

// Paginate
final older = await client.antennas.notes(
  antennaId: antenna.id,
  limit: 20,
  untilId: notes.last.id,
);
```

### Lister, mettre à jour et supprimer

```dart
final antennas = await client.antennas.list();
final detail   = await client.antennas.show(antennaId: antennaId);

// Only antennaId is required; other fields update selectively
await client.antennas.update(
  antennaId: antennaId,
  name: 'Dart & Flutter news',
  excludeBots: true,
);

await client.antennas.delete(antennaId: antennaId);
```
