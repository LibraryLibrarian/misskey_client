---
sidebar_position: 6
title: "チャンネルとアンテナ"
---

# チャンネルとアンテナ

チャンネルはサーバー内のトピックスペースで、投稿はそのチャンネル内でのみ表示されます。アンテナは条件に合うノートを自動収集するカスタムタイムラインフィルターです。

## チャンネル

チャンネル操作には `client.channels` API を使います。チャンネルミュートには `client.channels.mute` サブ API を使います。

### チャンネルの作成と更新

```dart
final channel = await client.channels.create(
  name: 'Tech Talk',
  description: 'Discussions about software and technology.',
  color: '#3498db',
);

// 更新 — 指定したフィールドのみ変更される
await client.channels.update(
  channelId: channel.id,
  name: 'Tech Talk (v2)',
  isArchived: false,
  pinnedNoteIds: [noteId1, noteId2],
);
```

`create` のオプションフィールド: `bannerId`（Drive ファイル ID）、`isSensitive`、`allowRenoteToExternal`。

### チャンネルタイムライン

```dart
final notes = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
);

// 古いノートを取得
final older = await client.channels.timeline(
  channelId: channelId,
  limit: 20,
  untilId: notes.last.id,
);
```

`sinceId`、`sinceDate`、`untilDate` も使用できます。

### フォロー・お気に入り・探索

```dart
await client.channels.follow(channelId: channelId);
await client.channels.unfollow(channelId: channelId);

await client.channels.favorite(channelId: channelId);
await client.channels.unfavorite(channelId: channelId);

// お気に入り登録したチャンネル一覧
final favorites = await client.channels.myFavorites();

// 探索用リスト
final featured = await client.channels.featured();
final followed = await client.channels.followed(limit: 20);
final owned    = await client.channels.owned(limit: 20);
```

### 検索

```dart
// 名前と説明文で検索（デフォルト）
final results = await client.channels.search(query: 'gaming', limit: 20);

// 名前のみで検索
final results = await client.channels.search(
  query: 'gaming',
  type: 'nameOnly',
);
```

## チャンネルミュート

```dart
// 無期限ミュート
await client.channels.mute.create(channelId: channelId);

// 期限付きミュート（ミリ秒単位のUnixタイムスタンプ）
await client.channels.mute.create(
  channelId: channelId,
  expiresAt: DateTime.now()
      .add(const Duration(days: 7))
      .millisecondsSinceEpoch,
);

await client.channels.mute.delete(channelId: channelId);

final muted = await client.channels.mute.list();
```

## アンテナ

アンテナはキーワード・ユーザー・リストの条件に基づいてノートを自動収集します。

### アンテナの作成

`keywords` は外側 OR・内側 AND のマッチングです。内側の配列が AND グループ、外側が OR で結合されます。

```dart
final antenna = await client.antennas.create(
  name: 'Dart news',
  src: 'all',              // 'home' | 'all' | 'users' | 'list' | 'users_blacklist'
  keywords: [
    ['dart', 'flutter'],  // "dart" AND "flutter" を含むノートにマッチ
    ['misskey'],           // または "misskey" を含むノートにマッチ
  ],
  excludeKeywords: [['spam']],
  users: [],
  caseSensitive: false,
  withReplies: false,
  withFile: false,
);
```

ユーザーリストに絞る場合は `src: 'list'` と `userListId` を指定します。

### アンテナのノートを取得

```dart
final notes = await client.antennas.notes(antennaId: antenna.id, limit: 20);

// ページネーション
final older = await client.antennas.notes(
  antennaId: antenna.id,
  limit: 20,
  untilId: notes.last.id,
);
```

### 一覧・更新・削除

```dart
final antennas = await client.antennas.list();
final detail   = await client.antennas.show(antennaId: antennaId);

// antennaId のみ必須。他のフィールドは指定したものだけ更新される
await client.antennas.update(
  antennaId: antennaId,
  name: 'Dart & Flutter news',
  excludeBots: true,
);

await client.antennas.delete(antennaId: antennaId);
```
