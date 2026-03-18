---
sidebar_position: 9
title: "その他のAPI"
---

# その他のAPI

チャット・お知らせ・ハッシュタグ・招待コード・Service Workerプッシュ通知のAPIを説明します。

## ChatApi

`client.chat` は直接メッセージとグループルームのメッセージング機能を提供します。チャットのエンドポイントはすべて認証が必要です。

### 履歴と既読管理

```dart
// DM会話の最新履歴
final dmHistory = await client.chat.history(limit: 10);

// ルームメッセージの最新履歴
final roomHistory = await client.chat.history(limit: 10, room: true);

// すべてのメッセージを既読にする
await client.chat.readAll();
```

### ダイレクトメッセージ

```dart
// ユーザーにメッセージを送信
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Hello!',
);

// Driveファイルを添付
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'ファイルを送ります。',
  fileId: driveFileId,
);

// メッセージを削除
await client.chat.messages.delete(messageId: msg.id);

// メッセージにリアクション
await client.chat.messages.react(messageId: msg.id, reaction: ':heart:');

// リアクションを削除
await client.chat.messages.unreact(messageId: msg.id, reaction: ':heart:');
```

### メッセージタイムライン

```dart
// ユーザーとのDMタイムライン（カーソルベースのページネーション）
final messages = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
);

// さらに古いメッセージを取得
final older = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
  untilId: messages.last.id,
);

// ルームのメッセージタイムライン
final roomMessages = await client.chat.messages.roomTimeline(
  roomId: roomId,
  limit: 20,
);
```

### メッセージ検索

```dart
final results = await client.chat.messages.search(
  query: 'ミーティング',
  limit: 20,
  userId: targetUserId, // 省略可: 特定の会話に絞り込む
);
```

### チャットルーム

```dart
// ルームを作成
final room = await client.chat.rooms.create(
  name: 'プロジェクトAlpha',
  description: '調整チャンネル',
);

// ルーム情報を更新
await client.chat.rooms.update(
  roomId: room.id,
  name: 'プロジェクトAlpha — 進行中',
);

// ルームを削除
await client.chat.rooms.delete(roomId: room.id);

// 参加・退出
await client.chat.rooms.join(roomId: room.id);
await client.chat.rooms.leave(roomId: room.id);

// ルームをミュート/解除
await client.chat.rooms.setMute(roomId: room.id, mute: true);

// メンバー一覧
final members = await client.chat.rooms.members(roomId: room.id, limit: 30);

// 自分が作成したルーム
final owned = await client.chat.rooms.owned(limit: 20);

// 自分が参加しているルーム
final joined = await client.chat.rooms.joining(limit: 20);
```

### ルーム招待

```dart
// ユーザーをルームに招待
await client.chat.rooms.invitationsCreate(
  roomId: room.id,
  userId: targetUserId,
);

// 受け取った招待の一覧
final inbox = await client.chat.rooms.invitationsInbox(limit: 20);

// 送った招待の一覧
final outbox = await client.chat.rooms.invitationsOutbox(
  roomId: room.id,
  limit: 20,
);

// 招待を無視する
await client.chat.rooms.invitationsIgnore(roomId: room.id);
```

## AnnouncementsApi

`client.announcements` はサーバーのお知らせを取得します。認証は任意で、認証済みの場合は各アイテムに `isRead` フラグが付きます。

```dart
// アクティブなお知らせ（デフォルト）
final active = await client.announcements.list(limit: 10);

// 非アクティブなお知らせも含める
final all = await client.announcements.list(isActive: false, limit: 20);

// 1件の詳細を取得
final ann = await client.announcements.show(announcementId: ann.id);
print(ann.title);
print(ann.text);
```

`sinceId`・`untilId`・`sinceDate`・`untilDate` でページネーションできます。

### 既読にする

`client.account` を通じてお知らせを既読にします。

```dart
await client.account.readAnnouncement(announcementId: ann.id);
```

## HashtagsApi

`client.hashtags` はハッシュタグの検索とトレンド情報を提供します。認証は不要です。

### 一覧と検索

```dart
// 利用ユーザー数でソートしたハッシュタグ一覧
final tags = await client.hashtags.list(
  sort: '+mentionedUsers',
  limit: 20,
);

// 前方一致検索 — タグ名の文字列リストを返す
final suggestions = await client.hashtags.search(
  query: 'miss',
  limit: 10,
);
```

`sort` に指定できる値: `+mentionedUsers` / `-mentionedUsers`、
`+mentionedLocalUsers` / `-mentionedLocalUsers`、
`+mentionedRemoteUsers` / `-mentionedRemoteUsers`、
`+attachedUsers` / `-attachedUsers`、
`+attachedLocalUsers` / `-attachedLocalUsers`、
`+attachedRemoteUsers` / `-attachedRemoteUsers`

### タグ詳細とトレンド

```dart
// タグの詳細統計
final tag = await client.hashtags.show(tag: 'misskey');
print(tag.mentionedUsersCount);

// トレンドタグ（最大10件・60秒キャッシュ）
final trending = await client.hashtags.trend();
for (final t in trending) {
  print('${t.tag}: ${t.chart}');
}
```

### タグを使用しているユーザー

```dart
final users = await client.hashtags.users(
  tag: 'misskey',
  sort: '+follower',
  limit: 20,
  origin: 'local', // 'local'・'remote'・'combined'
  state: 'alive',  // 'all'・'alive'
);
```

## InviteApi

`client.invite` は招待制サーバーの招待コードを管理します。すべてのエンドポイントで認証と `canInvite` ロールポリシーが必要です。

```dart
// 招待コードを作成
final code = await client.invite.create();
print(code.code);

// 残り招待可能数を確認（null は無制限）
final remaining = await client.invite.limit();
if (remaining != null) {
  print('残り $remaining 件');
}

// 発行済みコード一覧
final codes = await client.invite.list(limit: 20);

// コードを削除
await client.invite.delete(inviteId: code.id);
```

## SwApi

`client.sw` はService Workerのプッシュ通知サブスクリプションを管理します。すべてのエンドポイントで認証が必要です。

### 登録

```dart
final registration = await client.sw.register(
  endpoint: 'https://push.example.com/subscribe/abc123',
  auth: 'auth-secret',
  publickey: 'vapid-public-key',
);
print(registration.state); // 'subscribed' または 'already-subscribed'
```

既読通知も受け取る場合は `sendReadMessage: true` を指定します。

### 登録確認

```dart
final sub = await client.sw.showRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
if (sub != null) {
  print(sub.sendReadMessage);
}
```

### 設定更新

```dart
await client.sw.updateRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
  sendReadMessage: false,
);
```

### 登録解除

```dart
await client.sw.unregister(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
```
