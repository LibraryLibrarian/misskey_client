---
sidebar_position: 1
title: Notizen
---

# Notizen

Die `client.notes`-API bietet Operationen zum Abrufen, Erstellen und Interagieren mit Notizen (Beitraegen).

## Notizen abrufen

### Einzelne Notiz

```dart
final note = await client.notes.show(noteId: '9xyz');
print(note.text);      // Notizinhalt
print(note.user.name); // Anzeigename des Autors
```

### Liste oeffentlicher Notizen

```dart
final notes = await client.notes.list(limit: 20);
```

Akzeptiert die Filter `local`, `reply`, `renote`, `withFiles` und `poll`.

### Antworten und Kinder

```dart
// Direkte Antworten auf eine Notiz
final replies = await client.notes.replies(noteId: '9xyz', limit: 10);

// Alle Kinder (Antworten und zitierende Renotes)
final children = await client.notes.children(noteId: '9xyz', limit: 10);

// Elternkette (Vorfahren)
final ancestors = await client.notes.conversation(noteId: '9xyz', limit: 10);
```

## Timelines

Alle Timeline-Methoden akzeptieren `limit`, `sinceId`, `untilId`, `sinceDate` und `untilDate` zur Seitennavigation.

### Startseiten-Timeline (Authentifizierung erforderlich)

```dart
final notes = await client.notes.timelineHome(limit: 20);
```

### Lokale Timeline

```dart
final notes = await client.notes.timelineLocal(limit: 20);
```

### Globale Timeline

```dart
final notes = await client.notes.timelineGlobal(limit: 20);
```

### Hybride Timeline (Authentifizierung erforderlich)

```dart
final notes = await client.notes.timelineHybrid(limit: 20);
```

### Cursorbasierte Seitennavigation

```dart
// Naechste Seite abrufen, anhand der ID der aeltesten bereits geladenen Notiz
final older = await client.notes.timelineHome(
  limit: 20,
  untilId: notes.last.id,
);

// Neuere Notizen seit der zuletzt geladenen Notiz abrufen
final newer = await client.notes.timelineHome(
  limit: 20,
  sinceId: notes.first.id,
);
```

## Notizen erstellen

Mindestens eines der Felder `text`, `renoteId`, `fileIds` oder `pollChoices` muss angegeben werden.

### Einfacher Text

```dart
final note = await client.notes.create(
  text: 'Hello, Misskey!',
  visibility: 'public',
);
print(note.id);
```

### Mit Inhaltswarnung

```dart
final note = await client.notes.create(
  text: 'This contains spoilers.',
  cw: 'Spoiler warning',
);
```

### Mit Dateien aus dem Drive

```dart
// Zuerst eine Datei in das Drive hochladen
final file = await client.drive.files.create(
  bytes: imageBytes,
  filename: 'photo.jpg',
);

// Die Drive-Datei-ID an die Notiz anhaengen
final note = await client.notes.create(
  text: 'Check this out!',
  fileIds: [file.id],
);
```

### Mit einer Umfrage

```dart
final note = await client.notes.create(
  text: 'What do you prefer?',
  pollChoices: ['Option A', 'Option B', 'Option C'],
  pollMultiple: false,
  pollExpiredAfter: 86400000, // 24 Stunden in Millisekunden
);
```

### Antwort und Renote

```dart
// Antwort
final reply = await client.notes.create(
  text: 'Great point!',
  replyId: originalNoteId,
);

// Reines Renote (kein Text)
final renote = await client.notes.create(renoteId: originalNoteId);

// Zitierendes Renote
final quote = await client.notes.create(
  text: 'My thoughts on this:',
  renoteId: originalNoteId,
);
```

### Sichtbarkeitsoptionen

```dart
// 'public', 'home', 'followers', 'specified'
final note = await client.notes.create(
  text: 'Followers only',
  visibility: 'followers',
);

// Direktnachricht an bestimmte Benutzer
final dm = await client.notes.create(
  text: 'Hey!',
  visibility: 'specified',
  visibleUserIds: [targetUserId],
);
```

## Notiz-Interaktionen

### Reaktionen

```dart
// Reaktion hinzufuegen (Unicode-Emoji oder benutzerdefiniertes Emoji-Kurzkuerzel)
await client.notes.reactionsCreate(noteId: noteId, reaction: '👍');
await client.notes.reactionsCreate(noteId: noteId, reaction: ':awesome:');

// Eigene Reaktion entfernen
await client.notes.reactionsDelete(noteId: noteId);

// Reaktionen einer Notiz abrufen
final reactions = await client.notes.reactions(noteId: noteId, limit: 20);
for (final r in reactions) {
  print('${r.reaction}: ${r.user.username}');
}
```

### Renotes

```dart
// Renote (kein Text)
await client.notes.create(renoteId: noteId);

// Alle eigenen Renotes einer Notiz zuruecknehmen
await client.notes.unrenote(noteId: noteId);

// Benutzer auflisten, die renotiert haben
final renotes = await client.notes.renotes(noteId: noteId, limit: 20);
```

### Umfrageabstimmung

```dart
// choice ist ein nullbasierter Index
await client.notes.pollsVote(noteId: noteId, choice: 0);
```

### Notiz loeschen

```dart
await client.notes.delete(noteId: noteId);
```

## Suche

### Volltextsuche

```dart
final results = await client.notes.search(
  query: 'Misskey',
  limit: 20,
);
```

Nach Benutzer oder Kanal filtern:

```dart
final results = await client.notes.search(
  query: 'hello',
  userId: someUserId,
  channelId: someChannelId,
);
```

### Nach Hashtag suchen

```dart
// Einfache Tag-Suche
final results = await client.notes.searchByTag(tag: 'misskey');

// Komplexe Abfrage: (tagA AND tagB) OR tagC
final results = await client.notes.searchByTag(
  queryTags: [
    ['tagA', 'tagB'],
    ['tagC'],
  ],
);
```

## Favoriten und Entwerfe

```dart
// Favoriten hinzufuegen / entfernen
await client.notes.favoritesCreate(noteId: noteId);
await client.notes.favoritesDelete(noteId: noteId);

// Eigene Favoriten abrufen
final favs = await client.account.favorites(limit: 20);

// Entwerfe auflisten
final drafts = await client.notes.draftsList(limit: 20);

// Entwurfanzahl
final count = await client.notes.draftsCount();
```

## Uebersetzung

```dart
final translation = await client.notes.translate(
  noteId: noteId,
  targetLang: 'en',
);
print(translation.text);
```
