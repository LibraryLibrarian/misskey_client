---
sidebar_position: 2
---

# ドライブアップロード

Misskeyのドライブはファイルストレージ機能です。画像や動画などのファイルをアップロードし、ノートに添付できます。

## ファイルのアップロード

```dart
import 'dart:io';

final file = File('/path/to/image.jpg');
final bytes = await file.readAsBytes();

final driveFile = await client.drive.files.create(
  name: 'image.jpg',
  type: 'image/jpeg',
  bytes: bytes,
);

print(driveFile.id);
print(driveFile.url);
```

## ファイル一覧の取得

```dart
// ドライブのファイル一覧
final files = await client.drive.files.list();

// フォルダを指定して取得
final filesInFolder = await client.drive.files.list(
  folderId: 'folder_id',
);

// ページング
final olderFiles = await client.drive.files.list(
  untilId: files.last.id,
);
```

## フォルダ管理

```dart
// フォルダを作成
final folder = await client.drive.folders.create(name: '写真');

// サブフォルダを作成
final subfolder = await client.drive.folders.create(
  name: '2024年',
  parentId: folder.id,
);

// フォルダ一覧
final folders = await client.drive.folders.list();

// フォルダを削除
await client.drive.folders.delete(folderId: folder.id);
```

## ノートへの添付

アップロードしたファイルのIDをノート作成時に指定します。

```dart
// ファイルをアップロード
final driveFile = await client.drive.files.create(
  name: 'photo.jpg',
  type: 'image/jpeg',
  bytes: imageBytes,
);

// ノートに添付して投稿
final note = await client.notes.create(
  text: '今日の写真です',
  fileIds: [driveFile.id],
);
```

複数ファイルを同時に添付することもできます（最大16件）。

```dart
final note = await client.notes.create(
  text: 'アルバム',
  fileIds: [file1.id, file2.id, file3.id],
);
```

## ドライブの使用容量

```dart
final stats = await client.drive.stats();
print('使用容量: ${stats.usage} バイト');
print('容量上限: ${stats.capacity} バイト');
```
