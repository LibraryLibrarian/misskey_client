---
sidebar_position: 6
title: "Kanaele & Antennen"
---

# Kanaele & Antennen

Kanaele sind thematische Raeume, in denen Notizen nur innerhalb dieses Kanals sichtbar sind. Antennen sind benutzerdefinierte Timeline-Filter, die automatisch Notizen sammeln, die Ihren Kriterien entsprechen.

## Kanaele

Die `client.channels`-API verwaltet alle Kanaloperationen. Die Unter-API `client.channels.mute` verwaltet Kanal-Stummschaltungen.

### Einen Kanal erstellen und aktualisieren

```dart
final channel = await client.channels.create(
  name: 'Tech Talk',
  description: 'Discussions about software and technology.',
  color: '#3498db',
);

// Aktualisieren — nur die angegebenen Felder werden geaendert
await client.channels.update(
  channelId: channel.id,
  name: 'Tech Talk (v2)',
  isArchived: false,
  pinnedNoteIds: [noteId1, noteId2],
);
```

Optionale Felder bei `create`: `bannerId` (Drive-Datei-ID), `isSensitive`, `allowRenoteToExternal`.

### Kanal-Timeline

```dart
final notes = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
);

// Aeltere Notizen
final older = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
  untilId: notes.last.id,
);
```

Alle Timeline-Methoden akzeptieren auch `sinceId`, `sinceDate` und `untilDate`.

### Folgen, favorisieren und entdecken

```dart
await client.channels.follow(channelId: channelId);
await client.channels.unfollow(channelId: channelId);

await client.channels.favorite(channelId: channelId);
await client.channels.unfavorite(channelId: channelId);

// Vom authentifizierten Benutzer favorisierte Kanaele
final favorites = await client.channels.myFavorites();

// Entdeckungslistings
final featured = await client.channels.featured();
final followed = await client.channels.followed(limit: 20);
final owned    = await client.channels.owned(limit: 20);
```

### Suche

```dart
// Name und Beschreibung durchsuchen (Standard)
final results = await client.channels.search(query: 'gaming', limit: 20);

// Nur Name
final results = await client.channels.search(
  query: 'gaming',
  type: 'nameOnly',
);
```

## Kanal-Stummschaltungen

```dart
// Unbefristet stummschalten
await client.channels.mute.create(channelId: channelId);

// Stummschalten mit Ablaufzeit (Unix-Zeitstempel in Millisekunden)
await client.channels.mute.create(
  channelId: channelId,
  expiresAt: DateTime.now()
      .add(const Duration(days: 7))
      .millisecondsSinceEpoch,
);

await client.channels.mute.delete(channelId: channelId);

final muted = await client.channels.mute.list();
```

## Antennen

Antennen sammeln automatisch Notizen aus dem gesamten Server anhand von Schluesselbegriffen, Benutzern oder Listen.

### Eine Antenne erstellen

`keywords` verwendet ODER-aussen / UND-innen-Abgleich: Jede innere Liste ist eine UND-Gruppe, aeussere Listen werden mit ODER verknuepft.

```dart
final antenna = await client.antennas.create(
  name: 'Dart news',
  src: 'all',             // 'home' | 'all' | 'users' | 'list' | 'users_blacklist'
  keywords: [
    ['dart', 'flutter'], // erfasst Notizen, die sowohl "dart" ALS AUCH "flutter" enthalten
    ['misskey'],          // ODER Notizen, die "misskey" enthalten
  ],
  excludeKeywords: [['spam']],
  users: [],
  caseSensitive: false,
  withReplies: false,
  withFile: false,
);
```

Um auf eine Benutzerliste zu beschraenken, setzen Sie `src: 'list'` und uebergeben `userListId`.

### Antennen-Notizen abrufen

```dart
final notes = await client.antennas.notes(antennaId: antenna.id, limit: 20);

// Seitennavigation
final older = await client.antennas.notes(
  antennaId: antenna.id,
  limit: 20,
  untilId: notes.last.id,
);
```

### Auflisten, aktualisieren und loeschen

```dart
final antennas = await client.antennas.list();
final detail   = await client.antennas.show(antennaId: antennaId);

// Nur antennaId ist erforderlich; andere Felder werden selektiv aktualisiert
await client.antennas.update(
  antennaId: antennaId,
  name: 'Dart & Flutter news',
  excludeBots: true,
);

await client.antennas.delete(antennaId: antennaId);
```
