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
final homeTimeline = await client.notes.timelineHome();

// ローカルタイムライン
final localTimeline = await client.notes.timelineLocal();

// ソーシャルタイムライン
final socialTimeline = await client.notes.timelineHybrid();

// 古いノートを続けて取得（ページング）
final olderNotes = await client.notes.timelineHome(
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
  pollChoices: ['春', '夏', '秋', '冬'],
  pollExpiredAfter: 86400000, // 24時間（ミリ秒）
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
await client.notes.reactionsCreate(
  noteId: 'abc123',
  reaction: ':heart:',
);

// リアクションを削除
await client.notes.reactionsDelete(noteId: 'abc123');

// リアクション一覧を取得
final reactions = await client.notes.reactions(noteId: 'abc123');
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

`rangeStartAt` / `rangeEndAt`（Unix ミリ秒、両端を含む）で投稿日時の期間を絞り込めます。ページネーション用のカーソルである `sinceDate` / `untilDate` とは異なり、こちらは検索条件です。Misskey 2026.6.0 以降が必要で、それより古いサーバーではこの指定が無視され、期間で絞り込まれていない結果が返ります。

```dart
final results = await client.notes.search(
  query: 'hello',
  rangeStartAt: DateTime.utc(2026, 1, 1).millisecondsSinceEpoch,
  rangeEndAt: DateTime.utc(2026, 2, 1).millisecondsSinceEpoch - 1,
);
```

## お気に入り

```dart
await client.notes.favoritesCreate(noteId: 'abc123');
await client.notes.favoritesDelete(noteId: 'abc123');
final favorites = await client.account.favorites();
```
