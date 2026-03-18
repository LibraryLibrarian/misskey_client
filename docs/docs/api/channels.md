---
sidebar_position: 6
title: "Channels & Antennas"
---

# Channels & Antennas

Channels are topical spaces where notes are visible only within that channel. Antennas are custom timeline filters that automatically collect notes matching your criteria.

## Channels

The `client.channels` API handles all channel operations. The `client.channels.mute` sub-API manages channel mutes.

### Creating and updating a channel

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

Optional fields on `create`: `bannerId` (Drive file ID), `isSensitive`, `allowRenoteToExternal`.

### Channel timeline

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

All timeline methods also accept `sinceId`, `sinceDate`, and `untilDate`.

### Follow, favorite, and discover

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

### Search

```dart
// Search name and description (default)
final results = await client.channels.search(query: 'gaming', limit: 20);

// Name only
final results = await client.channels.search(
  query: 'gaming',
  type: 'nameOnly',
);
```

## Channel mutes

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

## Antennas

Antennas automatically collect notes from across the server based on keywords, users, or lists.

### Creating an antenna

`keywords` uses outer-OR / inner-AND matching: each inner list is an AND group, outer lists combine with OR.

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

To restrict to a user list, set `src: 'list'` and pass `userListId`.

### Fetching antenna notes

```dart
final notes = await client.antennas.notes(antennaId: antenna.id, limit: 20);

// Paginate
final older = await client.antennas.notes(
  antennaId: antenna.id,
  limit: 20,
  untilId: notes.last.id,
);
```

### Listing, updating, and deleting

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
