---
sidebar_position: 2
---

# ユーザー

## ユーザーの取得

IDまたはユーザー名でユーザーを取得します。

```dart
// IDで取得
final user = await client.users.show(userId: 'user_id');

// ユーザー名とホストで取得
final user = await client.users.show(
  username: 'alice',
  host: 'misskey.example.com',
);

print(user.name);
print(user.followersCount);
```

## ユーザーリスト

### 作成と管理

```dart
// ユーザーリストを作成
final list = await client.userLists.create(name: '友達');

// リストにユーザーを追加
await client.userLists.push(
  listId: list.id,
  userId: 'user_id',
);

// リストのタイムラインを取得
final timeline = await client.notes.userListTimeline(
  listId: list.id,
);
```

## フォロー

```dart
// フォローする
await client.following.create(userId: 'user_id');

// フォロー解除
await client.following.delete(userId: 'user_id');

// フォロワー一覧
final followers = await client.users.followers(userId: 'user_id');

// フォロー中一覧
final following = await client.users.following(userId: 'user_id');
```

## ブロック

```dart
// ブロックする
await client.blocking.create(userId: 'user_id');

// ブロック解除
await client.blocking.delete(userId: 'user_id');

// ブロックリスト
final blocked = await client.blocking.list();
```

## ミュート

```dart
// ミュートする
await client.mute.create(userId: 'user_id');

// ミュート解除
await client.mute.delete(userId: 'user_id');

// ミュートリスト
final muted = await client.mute.list();
```

## プロフィール更新

自分のプロフィールを更新します。

```dart
await client.account.update(
  name: '新しい表示名',
  description: 'プロフィールの説明文',
  isLocked: false,
);
```

## ユーザー検索

```dart
final results = await client.users.search(query: 'alice');
```
