---
sidebar_position: 7
title: "Inhalte"
---

# Inhalte

Diese Seite behandelt vier inhaltsorientierte APIs: Clips zum Lesezeichen von Notizen, Play (Flash) fuer AiScript-Mini-Apps, Gallery fuer Fotosammlungen und Pages fuer Rich-Text-Dokumente.

## Clips

Clips sind benannte Sammlungen von als Lesezeichen gespeicherten Notizen.

```dart
final clip = await client.clips.create(
  name: 'Interesting reads',
  isPublic: true,
  description: 'Notes I want to revisit.',
);

// Notizen hinzufuegen / entfernen
await client.clips.addNote(clipId: clip.id, noteId: noteId);
await client.clips.removeNote(clipId: clip.id, noteId: noteId);

// Notizen in einem Clip (unterstuetzt Suche und Seitennavigation)
final notes = await client.clips.notes(clipId: clip.id, limit: 20);
final found = await client.clips.notes(clipId: clip.id, search: 'Misskey');

// Eigene Clips auflisten
final clips = await client.clips.list(limit: 20);

// Clips favorisieren
await client.clips.favorite(clipId: clip.id);
await client.clips.unfavorite(clipId: clip.id);
final favorites = await client.clips.myFavorites();

// Aktualisieren und loeschen
await client.clips.update(clipId: clip.id, name: 'Must-reads');
await client.clips.delete(clipId: clip.id);
```

## Play

Play (unter dem Legacy-API-Namen Flash bekannt) ermoeglicht Benutzern, kleine AiScript-basierte Mini-Apps zu erstellen und auszufuehren.

### Ein Play erstellen

```dart
final flash = await client.flash.create(
  title: 'Hello World',
  summary: 'A simple greeting app.',
  script: 'Mk:dialog("Hello", "Hello, World!", "info")',
  permissions: [],
  visibility: 'public', // 'public' oder 'private'
);
```

### Abrufen und suchen

```dart
// Einzelner Flash nach ID (keine Authentifizierung erforderlich)
final flash = await client.flash.show(flashId: flashId);

// Eigene Flashes
final myFlashes = await client.flash.my(limit: 20);

// Vorgestellt (Offset-basierte Seitennavigation)
final featured = await client.flash.featured(limit: 10, offset: 0);

// Suche
final results = await client.flash.search(query: 'game', limit: 10);
```

### Likes, aktualisieren und loeschen

```dart
await client.flash.like(flashId: flashId);
await client.flash.unlike(flashId: flashId);
final liked = await client.flash.myLikes(limit: 20);

await client.flash.update(flashId: flash.id, title: 'Hello World v2');
await client.flash.delete(flashId: flash.id);
```

## Gallery

Galerie-Beitraege sind kuratierte Sammlungen von Drive-Dateien (Bilder, Videos).

### Beitraege durchsuchen

```dart
// Vorgestellt (Ranking-Cache, 30-Minuten-TTL)
final featured = await client.gallery.featured(limit: 10);

// Beliebt (sortiert nach Anzahl der Likes)
final popular = await client.gallery.popular();

// Alle Beitraege, neueste zuerst — Seitennavigation mit untilId
final posts = await client.gallery.posts(limit: 20);
final older = await client.gallery.posts(limit: 20, untilId: posts.last.id);

// Einzelner Beitrag
final post = await client.gallery.postsShow(postId: postId);
```

### Beitraege erstellen und verwalten

`fileIds` akzeptiert 1 bis 32 eindeutige Drive-Datei-IDs.

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

Pages sind reichhaltige Dokumente, die aus Inhaltsloecken und AiScript-Variablen zusammengesetzt sind.

### Seiten abrufen

```dart
// Nach ID (keine Authentifizierung erforderlich)
final page = await client.pages.showById(pageId: pageId);

// Nach Benutzername und URL-Pfadname (keine Authentifizierung erforderlich)
final page = await client.pages.showByName(
  name: 'my-first-page',
  username: 'alice',
);

// Vorgestellte Seiten (sortiert nach Anzahl der Likes)
final featured = await client.pages.featured();
```

### Eine Seite erstellen

`content` ist eine Liste von Block-Objekten; `variables` ist eine Liste von Variablendefinitionen; `script` ist AiScript, das beim Laden der Seite ausgefuehrt wird.

```dart
final page = await client.pages.create(
  title: 'My First Page',
  name: 'my-first-page', // URL-Pfadname — muss pro Benutzer eindeutig sein
  content: [
    {'type': 'text', 'text': 'Welcome to my page!'},
  ],
  variables: [],
  script: '',
  summary: 'An introduction.',
);
```

### Aktualisieren, loeschen und liken

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
