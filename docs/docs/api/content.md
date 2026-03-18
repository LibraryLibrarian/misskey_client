---
sidebar_position: 7
title: "Content"
---

# Content

This page covers four content-focused APIs: clips for bookmarking notes, Flash (Play) for AiScript mini-apps, gallery for photo collections, and pages for rich-text documents.

## Clips

Clips are named collections of bookmarked notes.

```dart
final clip = await client.clips.create(
  name: 'Interesting reads',
  isPublic: true,
  description: 'Notes I want to revisit.',
);

// Add / remove notes
await client.clips.addNote(clipId: clip.id, noteId: noteId);
await client.clips.removeNote(clipId: clip.id, noteId: noteId);

// Notes in a clip (supports search and pagination)
final notes = await client.clips.notes(clipId: clip.id, limit: 20);
final found = await client.clips.notes(clipId: clip.id, search: 'Misskey');

// List your clips
final clips = await client.clips.list(limit: 20);

// Favorite clips
await client.clips.favorite(clipId: clip.id);
await client.clips.unfavorite(clipId: clip.id);
final favorites = await client.clips.myFavorites();

// Update and delete
await client.clips.update(clipId: clip.id, name: 'Must-reads');
await client.clips.delete(clipId: clip.id);
```

## Flash

Flash (also called Play) lets users create and run small AiScript-powered mini-apps.

### Creating a Flash

```dart
final flash = await client.flash.create(
  title: 'Hello World',
  summary: 'A simple greeting app.',
  script: 'Mk:dialog("Hello", "Hello, World!", "info")',
  permissions: [],
  visibility: 'public', // 'public' or 'private'
);
```

### Fetching and searching

```dart
// Single Flash by ID (no auth required)
final flash = await client.flash.show(flashId: flashId);

// Your Flashes
final myFlashes = await client.flash.my(limit: 20);

// Featured (offset-based pagination)
final featured = await client.flash.featured(limit: 10, offset: 0);

// Search
final results = await client.flash.search(query: 'game', limit: 10);
```

### Likes, update, and delete

```dart
await client.flash.like(flashId: flashId);
await client.flash.unlike(flashId: flashId);
final liked = await client.flash.myLikes(limit: 20);

await client.flash.update(flashId: flash.id, title: 'Hello World v2');
await client.flash.delete(flashId: flash.id);
```

## Gallery

Gallery posts are curated collections of Drive files (images, videos).

### Browsing posts

```dart
// Featured (ranking cache, 30-minute TTL)
final featured = await client.gallery.featured(limit: 10);

// Popular (sorted by like count)
final popular = await client.gallery.popular();

// All posts, newest first — paginate with untilId
final posts = await client.gallery.posts(limit: 20);
final older = await client.gallery.posts(limit: 20, untilId: posts.last.id);

// Single post
final post = await client.gallery.postsShow(postId: postId);
```

### Creating and managing posts

`fileIds` accepts 1 to 32 unique Drive file IDs.

```dart
final post = await client.gallery.postsCreate(
  title: 'Summer photos',
  fileIds: [fileId1, fileId2, fileId3],
  description: 'A few shots from the trip.',
);

await client.gallery.postsUpdate(
  postId: post.id,
  title: 'Summer 2025 photos',
);

await client.gallery.postsDelete(postId: post.id);

await client.gallery.postsLike(postId: postId);
await client.gallery.postsUnlike(postId: postId);
```

## Pages

Pages are rich documents composed of content blocks and AiScript variables.

### Fetching pages

```dart
// By ID (no auth required)
final page = await client.pages.showById(pageId: pageId);

// By username and URL path name (no auth required)
final page = await client.pages.showByName(
  name: 'my-first-page',
  username: 'alice',
);

// Featured pages (sorted by like count)
final featured = await client.pages.featured();
```

### Creating a page

`content` is a list of block objects; `variables` is a list of variable definitions; `script` is AiScript run at page load.

```dart
final page = await client.pages.create(
  title: 'My First Page',
  name: 'my-first-page', // URL path name — must be unique per user
  content: [
    {'type': 'text', 'text': 'Welcome to my page!'},
  ],
  variables: [],
  script: '',
  summary: 'An introduction.',
);
```

### Update, delete, and like

```dart
await client.pages.update(
  pageId: page.id,
  title: 'Updated Title',
  content: [{'type': 'text', 'text': 'New content.'}],
);

await client.pages.delete(pageId: page.id);

await client.pages.like(pageId: pageId);
await client.pages.unlike(pageId: pageId);
```
