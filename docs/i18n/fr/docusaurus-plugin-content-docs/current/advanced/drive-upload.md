---
sidebar_position: 2
title: Téléversement Drive
---

# Téléversement Drive

Le Drive de Misskey est le système de stockage de fichiers. Tous les fichiers joints aux notes doivent d'abord être téléversés vers votre Drive. La facade `client.drive` expose les sous-API `files`, `folders` et `stats`.

## Téléverser un fichier

```dart
import 'dart:io';

final bytes = await File('photo.jpg').readAsBytes();
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'photo.jpg',
  comment: 'Alt text for accessibility',
);

print(driveFile.id);  // Use this ID to attach to a note
print(driveFile.url); // Public URL
```

### Téléversement avec dossier et sensibilité

```dart
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'nsfw.jpg',
  folderId: myFolderId,
  isSensitive: true,
  force: true, // Upload even if a file with the same name exists
);
```

### Progression du téléversement

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

### Téléversement depuis une URL

```dart
await client.drive.files.uploadFromUrl(
  url: 'https://example.com/image.jpg',
  folderId: myFolderId,
  isSensitive: false,
);
```

Il s'agit d'un point d'accès de type fire-and-forget ; le fichier apparaît dans le Drive de façon asynchrone.

## Joindre des fichiers Drive aux notes

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

Plusieurs fichiers peuvent être joints en passant plusieurs identifiants dans `fileIds`.

## Lister les fichiers

```dart
// List files in the root folder
final files = await client.drive.files.list(limit: 20);

// List files in a specific folder
final files = await client.drive.files.list(
  limit: 20,
  folderId: myFolderId,
);

// Filter by MIME type
final images = await client.drive.files.list(type: 'image/*');

// Sort by size descending
final large = await client.drive.files.list(sort: '-size');
```

`sort` accepte : `+createdAt`, `-createdAt`, `+name`, `-name`, `+size`, `-size`.

### Flux (tous les fichiers, sans filtre de dossier)

```dart
final all = await client.drive.stream(limit: 20, type: 'video/*');
```

### Rechercher par nom

```dart
final found = await client.drive.files.find(
  name: 'photo.jpg',
  folderId: myFolderId,
);
```

### Vérifier les doublons

```dart
final exists = await client.drive.files.checkExistence(md5: fileMd5);
```

## Récupérer les détails d'un fichier

```dart
// By file ID
final file = await client.drive.files.showByFileId(fileId);

// By URL
final file = await client.drive.files.showByUrl('https://example.com/file.jpg');
```

## Mettre à jour les attributs d'un fichier

```dart
final updated = await client.drive.files.update(
  fileId: driveFile.id,
  name: 'new-name.jpg',
  comment: 'Updated alt text',
  isSensitive: false,
);
```

Déplacer vers un autre dossier :

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  folderId: newFolderId,
);
```

Déplacer vers la racine :

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  moveToRoot: true,
);
```

## Supprimer des fichiers

```dart
await client.drive.files.delete(fileId: driveFile.id);
```

## Gestion des dossiers

```dart
// List root folders
final folders = await client.drive.folders.list();

// Create a folder
final folder = await client.drive.folders.create(
  name: 'Vacation Photos',
);

// Create a nested folder
final nested = await client.drive.folders.create(
  name: 'Day 1',
  parentId: folder.id,
);

// Rename a folder
await client.drive.folders.update(
  folderId: folder.id,
  name: 'Summer 2025',
);

// Move to root
await client.drive.folders.update(
  folderId: folder.id,
  moveToRoot: true,
);

// Delete a folder (must be empty)
await client.drive.folders.delete(folderId: folder.id);
```

## Statistiques du Drive

```dart
final capacity = await client.drive.stats.getCapacity();
print('Used: ${capacity.usage} bytes');
print('Capacity: ${capacity.capacity} bytes');
```
