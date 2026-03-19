---
sidebar_position: 2
title: 网盘上传
---

# 网盘上传

Misskey 的网盘是文件存储系统。所有附加到笔记的文件必须先上传到你的网盘。`client.drive` 外观对象暴露了 `files`、`folders` 和 `stats` 子 API。

## 上传文件

```dart
import 'dart:io';

final bytes = await File('photo.jpg').readAsBytes();
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'photo.jpg',
  comment: 'Alt text for accessibility',
);

print(driveFile.id);  // 使用此 ID 附加到笔记
print(driveFile.url); // 公开 URL
```

### 指定文件夹和敏感度上传

```dart
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'nsfw.jpg',
  folderId: myFolderId,
  isSensitive: true,
  force: true, // 即使存在同名文件也强制上传
);
```

### 上传进度

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

### 从 URL 上传

```dart
await client.drive.files.uploadFromUrl(
  url: 'https://example.com/image.jpg',
  folderId: myFolderId,
  isSensitive: false,
);
```

这是一个即发即忘的端点；文件会异步出现在网盘中。

## 将网盘文件附加到笔记

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

可以通过在 `fileIds` 中传入多个 ID 来附加多个文件。

## 列出文件

```dart
// 列出根文件夹中的文件
final files = await client.drive.files.list(limit: 20);

// 列出特定文件夹中的文件
final files = await client.drive.files.list(
  limit: 20,
  folderId: myFolderId,
);

// 按 MIME 类型过滤
final images = await client.drive.files.list(type: 'image/*');

// 按大小降序排序
final large = await client.drive.files.list(sort: '-size');
```

`sort` 接受：`+createdAt`、`-createdAt`、`+name`、`-name`、`+size`、`-size`。

### 流（所有文件，不过滤文件夹）

```dart
final all = await client.drive.stream(limit: 20, type: 'video/*');
```

### 按名称搜索

```dart
final found = await client.drive.files.find(
  name: 'photo.jpg',
  folderId: myFolderId,
);
```

### 检查重复文件

```dart
final exists = await client.drive.files.checkExistence(md5: fileMd5);
```

## 获取文件详情

```dart
// 通过文件 ID
final file = await client.drive.files.showByFileId(fileId);

// 通过 URL
final file = await client.drive.files.showByUrl('https://example.com/file.jpg');
```

## 更新文件属性

```dart
final updated = await client.drive.files.update(
  fileId: driveFile.id,
  name: 'new-name.jpg',
  comment: 'Updated alt text',
  isSensitive: false,
);
```

移动到其他文件夹：

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  folderId: newFolderId,
);
```

移动到根目录：

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  moveToRoot: true,
);
```

## 删除文件

```dart
await client.drive.files.delete(fileId: driveFile.id);
```

## 文件夹管理

```dart
// 列出根文件夹
final folders = await client.drive.folders.list();

// 创建文件夹
final folder = await client.drive.folders.create(
  name: 'Vacation Photos',
);

// 创建嵌套文件夹
final nested = await client.drive.folders.create(
  name: 'Day 1',
  parentId: folder.id,
);

// 重命名文件夹
await client.drive.folders.update(
  folderId: folder.id,
  name: 'Summer 2025',
);

// 移动到根目录
await client.drive.folders.update(
  folderId: folder.id,
  moveToRoot: true,
);

// 删除文件夹（必须为空）
await client.drive.folders.delete(folderId: folder.id);
```

## 网盘统计

```dart
final capacity = await client.drive.stats.getCapacity();
print('Used: ${capacity.usage} bytes');
print('Capacity: ${capacity.capacity} bytes');
```
