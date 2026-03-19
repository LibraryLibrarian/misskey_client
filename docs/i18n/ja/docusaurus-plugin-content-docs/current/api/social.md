---
sidebar_position: 5
title: "ソーシャル"
---

# ソーシャル

ソーシャル API はフォロー関係、フォローリクエスト、ブロック、ミュートを扱います。すべての操作には認証が必要です。

## フォロー (`client.following`)

### ユーザーをフォローする

```dart
final user = await client.following.create(userId: userId);
```

対象ユーザーがフォール承認を必要とする設定の場合、即時フォローの代わりにリクエストが送信されます。更新後の `MisskeyUser` が返されます。

`withReplies: true` を渡すと、そのユーザーのリプライもタイムラインに表示されます。

```dart
await client.following.create(userId: userId, withReplies: true);
```

### フォロー解除

```dart
await client.following.delete(userId: userId);
```

### フォロー設定の更新

個別のフォロー関係に対して、通知とリプライ表示の設定を変更します。

```dart
await client.following.update(
  userId: userId,
  notify: 'normal',   // 'normal' または 'none'
  withReplies: true,
);
```

### 全フォローの一括更新

フォローしているすべてのアカウントに同じ設定を適用します。レート制限：10リクエスト/時間。

```dart
await client.following.updateAll(notify: 'none', withReplies: false);
```

### フォロワーを削除する

自分をフォローしているユーザーを強制的に削除します。

```dart
await client.following.invalidate(userId: userId);
```

## フォローリクエスト (`client.following.requests`)

### 受信したリクエスト

```dart
// 自分への保留中のリクエスト一覧
final incoming = await client.following.requests.list(limit: 20);
for (final req in incoming) {
  print(req.follower.username);
}

// リクエストを承認する
await client.following.requests.accept(userId: userId);

// リクエストを拒否する
await client.following.requests.reject(userId: userId);
```

### 送信したリクエスト

```dart
// 自分が送信したリクエスト一覧
final sent = await client.following.requests.sent(limit: 20);

// 送信したリクエストをキャンセルする
await client.following.requests.cancel(userId: userId);
```

すべてのリスト系メソッドは `sinceId` / `untilId` および `sinceDate` / `untilDate` でページングできます。

## ブロック (`client.blocking`)

ブロックすると、自分と対象ユーザーの相互フォロー関係が解除されます。ブロックされたユーザーはあなたをフォローできなくなり、あなたもそのユーザーのコンテンツを閲覧できなくなります。

### ユーザーをブロックする

```dart
await client.blocking.create(userId: userId);
```

### ブロック解除

```dart
await client.blocking.delete(userId: userId);
```

### ブロックリストの取得

```dart
final blocked = await client.blocking.list(limit: 20);
for (final b in blocked) {
  print(b.blockee.username);
}
```

`sinceId` / `untilId` または `sinceDate` / `untilDate` でページングできます。

## ミュート (`client.mute`)

ミュートすると、対象ユーザーのノート・リノート・リアクションがタイムラインに表示されなくなります。ブロックと異なり、相手にはミュートされていることが通知されません。

### ユーザーをミュートする

```dart
// 永続的なミュート
await client.mute.create(userId: userId);
```

### 期限付きミュート

Unixタイムスタンプ（ミリ秒）を渡すと、指定時刻に自動でミュートが解除されます。

```dart
// 24時間ミュートする
final expiresAt = DateTime.now()
    .add(const Duration(hours: 24))
    .millisecondsSinceEpoch;

await client.mute.create(userId: userId, expiresAt: expiresAt);
```

### ミュート解除

```dart
await client.mute.delete(userId: userId);
```

### ミュートリストの取得

```dart
final muted = await client.mute.list(limit: 20);
for (final m in muted) {
  print(m.mutee.username);
}
```

## リノートミュート (`client.renoteMute`)

リノートミュートは、対象ユーザーのリノートだけをタイムラインから非表示にします。本人のオリジナルノートは引き続き表示されます。相手のオリジナル投稿は見たいが、転送コンテンツは見たくない場合に便利です。

### リノートミュートを設定する

```dart
await client.renoteMute.create(userId: userId);
```

### リノートミュートを解除する

```dart
await client.renoteMute.delete(userId: userId);
```

### リノートミュートリストの取得

```dart
final renoteMuted = await client.renoteMute.list(limit: 20);
for (final rm in renoteMuted) {
  print(rm.mutee.username);
}
```

`sinceId` / `untilId` または `sinceDate` / `untilDate` でページングできます。

## 比較：ミュート vs リノートミュート

| | 通常ミュート | リノートミュート |
|---|---|---|
| オリジナルノートを非表示 | あり | なし |
| リノートを非表示 | あり | あり |
| 相手への通知 | なし | なし |
| 期限付き | 対応 | 非対応 |
