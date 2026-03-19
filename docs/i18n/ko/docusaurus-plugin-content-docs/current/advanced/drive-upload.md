---
sidebar_position: 2
title: 드라이브 업로드
---

# 드라이브 업로드

Misskey의 드라이브는 파일 저장 시스템입니다. 노트에 첨부되는 모든 파일은 먼저 드라이브에 업로드해야 합니다. `client.drive` 파사드는 `files`, `folders`, `stats` 하위 API를 제공합니다.

## 파일 업로드

```dart
import 'dart:io';

final bytes = await File('photo.jpg').readAsBytes();
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'photo.jpg',
  comment: '접근성을 위한 대체 텍스트',
);

print(driveFile.id);  // 노트에 첨부할 때 사용하는 ID
print(driveFile.url); // 공개 URL
```

### 폴더 지정 및 민감도 설정하여 업로드

```dart
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'nsfw.jpg',
  folderId: myFolderId,
  isSensitive: true,
  force: true, // 같은 이름의 파일이 있어도 업로드
);
```

### 업로드 진행률

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

### URL에서 업로드

```dart
await client.drive.files.uploadFromUrl(
  url: 'https://example.com/image.jpg',
  folderId: myFolderId,
  isSensitive: false,
);
```

이 엔드포인트는 fire-and-forget 방식이며, 파일은 비동기적으로 드라이브에 나타납니다.

## 드라이브 파일을 노트에 첨부

```dart
final driveFile = await client.drive.files.create(
  bytes: imageBytes,
  filename: 'photo.jpg',
);

final note = await client.notes.create(
  text: '확인해 보세요!',
  fileIds: [driveFile.id],
);
```

`fileIds`에 여러 ID를 전달하면 여러 파일을 첨부할 수 있습니다.

## 파일 목록 조회

```dart
// 루트 폴더의 파일 목록
final files = await client.drive.files.list(limit: 20);

// 특정 폴더의 파일 목록
final files = await client.drive.files.list(
  limit: 20,
  folderId: myFolderId,
);

// MIME 타입으로 필터링
final images = await client.drive.files.list(type: 'image/*');

// 크기 기준 내림차순 정렬
final large = await client.drive.files.list(sort: '-size');
```

`sort` 허용 값: `+createdAt`, `-createdAt`, `+name`, `-name`, `+size`, `-size`.

### 스트림 (폴더 필터 없이 모든 파일)

```dart
final all = await client.drive.stream(limit: 20, type: 'video/*');
```

### 이름으로 검색

```dart
final found = await client.drive.files.find(
  name: 'photo.jpg',
  folderId: myFolderId,
);
```

### 중복 확인

```dart
final exists = await client.drive.files.checkExistence(md5: fileMd5);
```

## 파일 상세 정보 조회

```dart
// 파일 ID로 조회
final file = await client.drive.files.showByFileId(fileId);

// URL로 조회
final file = await client.drive.files.showByUrl('https://example.com/file.jpg');
```

## 파일 속성 업데이트

```dart
final updated = await client.drive.files.update(
  fileId: driveFile.id,
  name: 'new-name.jpg',
  comment: '업데이트된 대체 텍스트',
  isSensitive: false,
);
```

다른 폴더로 이동:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  folderId: newFolderId,
);
```

루트로 이동:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  moveToRoot: true,
);
```

## 파일 삭제

```dart
await client.drive.files.delete(fileId: driveFile.id);
```

## 폴더 관리

```dart
// 루트 폴더 목록
final folders = await client.drive.folders.list();

// 폴더 생성
final folder = await client.drive.folders.create(
  name: 'Vacation Photos',
);

// 중첩 폴더 생성
final nested = await client.drive.folders.create(
  name: 'Day 1',
  parentId: folder.id,
);

// 폴더 이름 변경
await client.drive.folders.update(
  folderId: folder.id,
  name: 'Summer 2025',
);

// 루트로 이동
await client.drive.folders.update(
  folderId: folder.id,
  moveToRoot: true,
);

// 폴더 삭제 (비어 있어야 함)
await client.drive.folders.delete(folderId: folder.id);
```

## 드라이브 통계

```dart
final capacity = await client.drive.stats.getCapacity();
print('Used: ${capacity.usage} bytes');
print('Capacity: ${capacity.capacity} bytes');
```
