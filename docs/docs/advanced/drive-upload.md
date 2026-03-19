---
sidebar_position: 2
title: Drive Upload
---

# Drive Upload

Misskey's Drive is the file storage system. All files attached to notes must first be uploaded to your Drive. The `client.drive` facade exposes `files`, `folders`, and `stats` sub-APIs.

## Uploading a file

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

### Upload with folder and sensitivity

```dart
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'nsfw.jpg',
  folderId: myFolderId,
  isSensitive: true,
  force: true, // Upload even if a file with the same name exists
);
```

### Upload progress

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

### Upload from URL

```dart
await client.drive.files.uploadFromUrl(
  url: 'https://example.com/image.jpg',
  folderId: myFolderId,
  isSensitive: false,
);
```

This is a fire-and-forget endpoint; the file appears in Drive asynchronously.

## Attaching Drive files to notes

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

Multiple files can be attached by passing multiple IDs in `fileIds`.

## Listing files

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

`sort` accepts: `+createdAt`, `-createdAt`, `+name`, `-name`, `+size`, `-size`.

### Stream (all files, no folder filter)

```dart
final all = await client.drive.stream(limit: 20, type: 'video/*');
```

### Search by name

```dart
final found = await client.drive.files.find(
  name: 'photo.jpg',
  folderId: myFolderId,
);
```

### Check for duplicates

```dart
final exists = await client.drive.files.checkExistence(md5: fileMd5);
```

## Fetching file details

```dart
// By file ID
final file = await client.drive.files.showByFileId(fileId);

// By URL
final file = await client.drive.files.showByUrl('https://example.com/file.jpg');
```

## Updating file attributes

```dart
final updated = await client.drive.files.update(
  fileId: driveFile.id,
  name: 'new-name.jpg',
  comment: 'Updated alt text',
  isSensitive: false,
);
```

Move to a different folder:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  folderId: newFolderId,
);
```

Move to root:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  moveToRoot: true,
);
```

## Deleting files

```dart
await client.drive.files.delete(fileId: driveFile.id);
```

## Folder management

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

## Drive statistics

```dart
final capacity = await client.drive.stats.getCapacity();
print('Used: ${capacity.usage} bytes');
print('Capacity: ${capacity.capacity} bytes');
```
