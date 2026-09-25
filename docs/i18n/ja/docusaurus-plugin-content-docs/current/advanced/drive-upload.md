---
sidebar_position: 2
title: ドライブアップロード
---

# ドライブアップロード

Misskey のドライブはファイルストレージ機能です。ノートに添付するファイルは、すべて事前にドライブへアップロードする必要があります。`client.drive` ファサードは `files`、`folders`、`stats` のサブ API を公開しています。

すべてのファイルの取得、一括移動、一括アップロード、フォルダの再帰的な削除など、複数のリクエストを組み合わせる操作については[ドライブヘルパー](./drive-helpers.md)も参照してください。

## ファイルのアップロード

```dart
import 'dart:io';

final bytes = await File('photo.jpg').readAsBytes();
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'photo.jpg',
  comment: 'Alt text for accessibility',
);

print(driveFile.id);  // ノートへの添付に使用する ID
print(driveFile.url); // 公開 URL
```

### フォルダとセンシティブ指定を伴うアップロード

```dart
final driveFile = await client.drive.files.create(
  bytes: bytes,
  filename: 'nsfw.jpg',
  folderId: myFolderId,
  isSensitive: true,
  force: true, // 同じ内容のファイルがすでに存在してもアップロードする
);
```

Misskey はアップロードを名前ではなく内容（MD5 ハッシュ）で重複排除します。`force` を指定しない場合、ドライブにすでに存在する内容をアップロードすると既存のファイルが返され、指定した `folderId`、`name`、`comment` は無視されます。バイト列の転送自体を避けたい場合は、[ドライブヘルパー](./drive-helpers.md#creatededuplicated)の `createDeduplicated()` を参照してください。

### アップロードの進捗

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

### URL からのアップロード

```dart
await client.drive.files.uploadFromUrl(
  url: 'https://example.com/image.jpg',
  folderId: myFolderId,
  isSensitive: false,
);
```

このエンドポイントは完了を待たずに戻り、ファイルは非同期でドライブに追加されます。`force` の意味は `create()` と同じです。作成されたファイルを待つには [`uploadFromUrlAndWait()`](./drive-helpers.md#waiting-for-url-uploads) を使用してください。

## ドライブのファイルをノートに添付する

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

`fileIds` に複数の ID を渡すと、複数のファイルを添付できます。

## ファイル一覧の取得

```dart
// ルートフォルダのファイル一覧
final files = await client.drive.files.list(limit: 20);

// 特定のフォルダのファイル一覧
final files = await client.drive.files.list(
  limit: 20,
  folderId: myFolderId,
);

// MIME タイプで絞り込む
final images = await client.drive.files.list(type: 'image/*');

// サイズの降順でソート
final large = await client.drive.files.list(sort: '+size');
```

`sort` には `+createdAt`、`-createdAt`、`+name`、`-name`、`+size`、`-size` を指定できます（`+` が降順）。

`untilId` によるページネーションと整合するのは `+createdAt`（または `sort` の指定なし）だけです。それ以外のソートでは順序が変わる一方で、カーソルは引き続き ID でフィルターするため、ページ間で項目が抜けたり重複したりします。すべてのファイルを取得するには `listAll()` を使用してローカルでソートしてください。詳細は[ドライブヘルパー](./drive-helpers.md#listing-everything)を参照してください。

### ストリーム（全ファイル、フォルダ指定なし）

```dart
final all = await client.drive.stream(limit: 20, type: 'video/*');
```

### 名前で検索

```dart
final found = await client.drive.files.find(
  name: 'photo.jpg',
  folderId: myFolderId,
);
```

### 重複の確認

```dart
final exists = await client.drive.files.checkExistence(md5: fileMd5);
```

## ファイルの詳細の取得

```dart
// ファイル ID で取得
final file = await client.drive.files.showByFileId(fileId);

// URL で取得
final file = await client.drive.files.showByUrl('https://example.com/file.jpg');
```

## ファイルの属性の更新

```dart
final updated = await client.drive.files.update(
  fileId: driveFile.id,
  name: 'new-name.jpg',
  comment: Optional('Updated alt text'), // Optional.null_() で削除する
  isSensitive: false,
);
```

別のフォルダへ移動する場合:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  folderId: newFolderId,
);
```

ルートへ移動する場合:

```dart
await client.drive.files.update(
  fileId: driveFile.id,
  moveToRoot: true,
);
```

## ファイルの削除

```dart
await client.drive.files.delete(fileId: driveFile.id);
```

## フォルダ管理

```dart
// ルートのフォルダ一覧
final folders = await client.drive.folders.list();

// フォルダを作成
final folder = await client.drive.folders.create(
  name: 'Vacation Photos',
);

// 入れ子のフォルダを作成
final nested = await client.drive.folders.create(
  name: 'Day 1',
  parentId: folder.id,
);

// フォルダ名を変更
await client.drive.folders.update(
  folderId: folder.id,
  name: 'Summer 2025',
);

// ルートへ移動
await client.drive.folders.update(
  folderId: folder.id,
  moveToRoot: true,
);

// フォルダを削除（空である必要があります）
await client.drive.folders.delete(folderId: folder.id);
```

## ドライブの統計

```dart
final capacity = await client.drive.stats.getCapacity();
print('Used: ${capacity.usage} bytes');
print('Capacity: ${capacity.capacity} bytes');
```
