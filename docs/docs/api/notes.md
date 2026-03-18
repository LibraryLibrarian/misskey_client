---
sidebar_position: 1
title: Notes
---

# Notes

The `client.notes` API provides operations for fetching, creating, and interacting with notes (posts).

## Fetching notes

### Single note

```dart
final note = await client.notes.show(noteId: '9xyz');
print(note.text);      // Note body
print(note.user.name); // Author's display name
```

### Public notes list

```dart
final notes = await client.notes.list(limit: 20);
```

Accepts `local`, `reply`, `renote`, `withFiles`, and `poll` filters.

### Replies and children

```dart
// Direct replies to a note
final replies = await client.notes.replies(noteId: '9xyz', limit: 10);

// All children (replies and quote renotes)
final children = await client.notes.children(noteId: '9xyz', limit: 10);

// Parent chain (ancestors)
final ancestors = await client.notes.conversation(noteId: '9xyz', limit: 10);
```

## Timelines

All timeline methods accept `limit`, `sinceId`, `untilId`, `sinceDate`, and `untilDate` for pagination.

### Home timeline (requires auth)

```dart
final notes = await client.notes.timelineHome(limit: 20);
```

### Local timeline

```dart
final notes = await client.notes.timelineLocal(limit: 20);
```

### Global timeline

```dart
final notes = await client.notes.timelineGlobal(limit: 20);
```

### Hybrid timeline (requires auth)

```dart
final notes = await client.notes.timelineHybrid(limit: 20);
```

### Cursor-based pagination

```dart
// Fetch the next page using the ID of the oldest note already loaded
final older = await client.notes.timelineHome(
  limit: 20,
  untilId: notes.last.id,
);

// Fetch newer notes since the last loaded note
final newer = await client.notes.timelineHome(
  limit: 20,
  sinceId: notes.first.id,
);
```

## Creating notes

At least one of `text`, `renoteId`, `fileIds`, or `pollChoices` must be provided.

### Plain text

```dart
final note = await client.notes.create(
  text: 'Hello, Misskey!',
  visibility: 'public',
);
print(note.id);
```

### With a content warning

```dart
final note = await client.notes.create(
  text: 'This contains spoilers.',
  cw: 'Spoiler warning',
);
```

### With files from Drive

```dart
// First upload a file to Drive
final file = await client.drive.files.create(
  bytes: imageBytes,
  filename: 'photo.jpg',
);

// Attach the Drive file ID to the note
final note = await client.notes.create(
  text: 'Check this out!',
  fileIds: [file.id],
);
```

### With a poll

```dart
final note = await client.notes.create(
  text: 'What do you prefer?',
  pollChoices: ['Option A', 'Option B', 'Option C'],
  pollMultiple: false,
  pollExpiredAfter: 86400000, // 24 hours in milliseconds
);
```

### Reply and renote

```dart
// Reply
final reply = await client.notes.create(
  text: 'Great point!',
  replyId: originalNoteId,
);

// Pure renote (no text)
final renote = await client.notes.create(renoteId: originalNoteId);

// Quote renote
final quote = await client.notes.create(
  text: 'My thoughts on this:',
  renoteId: originalNoteId,
);
```

### Visibility options

```dart
// 'public', 'home', 'followers', 'specified'
final note = await client.notes.create(
  text: 'Followers only',
  visibility: 'followers',
);

// Direct message to specific users
final dm = await client.notes.create(
  text: 'Hey!',
  visibility: 'specified',
  visibleUserIds: [targetUserId],
);
```

## Note interactions

### Reactions

```dart
// Add a reaction (Unicode emoji or custom emoji shortcode)
await client.notes.reactionsCreate(noteId: noteId, reaction: '👍');
await client.notes.reactionsCreate(noteId: noteId, reaction: ':awesome:');

// Remove your reaction
await client.notes.reactionsDelete(noteId: noteId);

// Fetch reactions on a note
final reactions = await client.notes.reactions(noteId: noteId, limit: 20);
for (final r in reactions) {
  print('${r.reaction}: ${r.user.username}');
}
```

### Renotes

```dart
// Renote (no text)
await client.notes.create(renoteId: noteId);

// Cancel all your renotes of a note
await client.notes.unrenote(noteId: noteId);

// List users who renoted
final renotes = await client.notes.renotes(noteId: noteId, limit: 20);
```

### Poll vote

```dart
// choice is a zero-based index
await client.notes.pollsVote(noteId: noteId, choice: 0);
```

### Delete a note

```dart
await client.notes.delete(noteId: noteId);
```

## Search

### Full-text search

```dart
final results = await client.notes.search(
  query: 'Misskey',
  limit: 20,
);
```

Filter by user or channel:

```dart
final results = await client.notes.search(
  query: 'hello',
  userId: someUserId,
  channelId: someChannelId,
);
```

### Search by hashtag

```dart
// Simple tag search
final results = await client.notes.searchByTag(tag: 'misskey');

// Complex query: (tagA AND tagB) OR tagC
final results = await client.notes.searchByTag(
  queryTags: [
    ['tagA', 'tagB'],
    ['tagC'],
  ],
);
```

## Favorites and drafts

```dart
// Add / remove a favorite
await client.notes.favoritesCreate(noteId: noteId);
await client.notes.favoritesDelete(noteId: noteId);

// Fetch your favorited notes
final favs = await client.account.favorites(limit: 20);

// List drafts
final drafts = await client.notes.draftsList(limit: 20);

// Draft count
final count = await client.notes.draftsCount();
```

## Translation

```dart
final translation = await client.notes.translate(
  noteId: noteId,
  targetLang: 'en',
);
print(translation.text);
```
