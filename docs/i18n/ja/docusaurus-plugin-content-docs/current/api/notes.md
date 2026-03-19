---
sidebar_position: 1
---

# ノート

## ノートの取得

IDを指定してノートを取得します。

```dart
final note = await client.notes.show(noteId: 'abc123');
print(note.text);
print(note.user.username);
```

## タイムライン

ホームタイムライン、ローカルタイムライン、ソーシャルタイムラインを取得できます。

```dart
// ホームタイムライン
final homeTimeline = await client.notes.timeline();

// ローカルタイムライン
final localTimeline = await client.notes.localTimeline();

// ソーシャルタイムライン
final socialTimeline = await client.notes.hybridTimeline();

// 古いノートを続けて取得（ページング）
final olderNotes = await client.notes.timeline(
  untilId: homeTimeline.last.id,
);
```

## ノートの作成

### テキストノート

```dart
final note = await client.notes.create(
  text: 'Hello, Misskey!',
);
```

### ファイル添付

```dart
final note = await client.notes.create(
  text: '写真を投稿しました',
  fileIds: ['file_id_1', 'file_id_2'],
);
```

### 投票付きノート

```dart
final note = await client.notes.create(
  text: '好きな季節は？',
  poll: NotePollRequest(
    choices: ['春', '夏', '秋', '冬'],
    expiredAfter: 86400000, // 24時間（ミリ秒）
  ),
);
```

### コンテンツワーニング

```dart
final note = await client.notes.create(
  text: '本文テキスト',
  cw: 'ここをクリックして展開',
);
```

## リアクション

```dart
// リアクションを追加
await client.notes.reactions.create(
  noteId: 'abc123',
  reaction: ':heart:',
);

// リアクションを削除
await client.notes.reactions.delete(noteId: 'abc123');

// リアクション一覧を取得
final reactions = await client.notes.reactions.list(noteId: 'abc123');
```

## リノート

```dart
// リノート
await client.notes.create(renoteId: 'abc123');

// 引用リノート
await client.notes.create(
  text: '参考になります',
  renoteId: 'abc123',
);
```

## 検索

```dart
final results = await client.notes.search(query: 'Misskey');
```

## お気に入り

```dart
await client.notes.favorites.create(noteId: 'abc123');
await client.notes.favorites.delete(noteId: 'abc123');
final favorites = await client.notes.favorites.list();
```
