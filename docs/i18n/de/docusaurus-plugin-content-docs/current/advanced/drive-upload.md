---
sidebar_position: 2
title: Drive-Upload
---

# Drive-Upload

Misskeys Drive ist das Dateispeichersystem. Alle an Notizen angehefteten Dateien muessen zuerst in Ihr Drive hochgeladen werden. Das `client.drive`-Facade stellt die Unter-APIs `files`, `folders` und `stats` bereit.

## Eine Datei hochladen

```dart
import 'dart:io';

final bytes = await File('photo.jpg').readAsBytes();
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'photo.jpg',
  comment: 'Alt text for accessibility',
);

print(driveFile.id);  // Diese ID zum Anhaengen an eine Notiz verwenden
print(driveFile.url); // Oeffentliche URL
```

### Mit Ordner und Sensitivitaet hochladen

```dart
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'nsfw.jpg',
  folderId: myFolderId,
  isSensitive: true,
  force: true, // Hochladen, auch wenn eine Datei mit demselben Namen existiert
);
```

### Upload-Fortschritt

```dart
final driveFile = await client.drive.files.create(
  bytes: largeBytes,
  filename: 'large-video.mp4',
  onSendProgress: (sent, total) {
    final percent = (sent / total * 100).toStringAsFixed(1);
    print('Uploading: $percent%');
  },
);
```

### Von URL hochladen

```dart
await client.drive.files.uploadFromUrl(
  url: 'https://example.com/image.jpg',
  folderId: myFolderId,
  isSensitive: false,
);
```

Dies ist ein Fire-and-Forget-Endpunkt; die Datei erscheint asynchron im Drive.

## Drive-Dateien an Notizen anhaengen

```dart
final driveFile = await client.drive.files.create(
  bytes: imageBytes,
  filename: 'photo.jpg',
);

final note = await client.notes.create(
  text: 'Check this out!',
  fileIds: [driveFile.id],
);
```

Mehrere Dateien koennen durch Angabe mehrerer IDs in `fileIds` angehaengt werden.

## Dateien auflisten

```dart
// Dateien im Stammordner auflisten
final files = await client.drive.files.list(limit: 20);

// Dateien in einem bestimmten Ordner auflisten
final files = await client.drive.files.list(
  limit: 20,
  folderId: myFolderId,
);

// Nach MIME-Typ filtern
final images = await client.drive.files.list(type: 'image/*');

// Absteigend nach Groesse sortieren
final large = await client.drive.files.list(sort: '-size');
```

`sort` akzeptiert: `+createdAt`, `-createdAt`, `+name`, `-name`, `+size`, `-size`.

### Stream (alle Dateien, kein Ordnerfilter)

```dart
final all = await client.drive.stream(limit: 20, type: 'video/*');
```

### Nach Name suchen

```dart
final found = await client.drive.files.find(
  name: 'photo.jpg',
  folderId: myFolderId,
);
```

### Auf Duplikate pruefen

```dart
final exists = await client.drive.files.checkExistence(md5: fileMd5);
```

## Dateidetails abrufen

```dart
// Nach Datei-ID
final file = await client.drive.files.showByFileId(fileId);

// Nach URL
final file = await client.drive.files.showByUrl('https://example.com/file.jpg');
```

## Dateiattribute aktualisieren

```dart
final updated = await client.drive.files.update(
  fileId: driveFile.id,
  name: 'new-name.jpg',
  comment: 'Updated alt text',
  isSensitive: false,
);
```

In einen anderen Ordner verschieben:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  folderId: newFolderId,
);
```

In den Stammordner verschieben:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  moveToRoot: true,
);
```

## Dateien loeschen

```dart
await client.drive.files.delete(fileId: driveFile.id);
```

## Ordnerverwaltung

```dart
// Stammordner auflisten
final folders = await client.drive.folders.list();

// Einen Ordner erstellen
final folder = await client.drive.folders.create(
  name: 'Vacation Photos',
);

// Einen verschachtelten Ordner erstellen
final nested = await client.drive.folders.create(
  name: 'Day 1',
  parentId: folder.id,
);

// Einen Ordner umbenennen
await client.drive.folders.update(
  folderId: folder.id,
  name: 'Summer 2025',
);

// In den Stammordner verschieben
await client.drive.folders.update(
  folderId: folder.id,
  moveToRoot: true,
);

// Einen Ordner loeschen (muss leer sein)
await client.drive.folders.delete(folderId: folder.id);
```

## Drive-Statistiken

```dart
final capacity = await client.drive.stats.getCapacity();
print('Used: ${capacity.usage} bytes');
print('Capacity: ${capacity.capacity} bytes');
```
