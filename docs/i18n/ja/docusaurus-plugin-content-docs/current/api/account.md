---
sidebar_position: 4
title: "アカウントとプロフィール"
---

# アカウントとプロフィール

`client.account` は認証済みユーザー自身に関する操作を提供します。プロフィールの取得・更新、認証情報の管理、データのエクスポート/インポート、そしてレジストリ・二要素認証・Webhookのサブ API へのアクセスが含まれます。

## プロフィールの取得

```dart
final me = await client.account.i();
print(me.name);        // 表示名
print(me.username);    // ユーザー名（@ なし）
print(me.description); // 自己紹介文
```

## プロフィールの更新

`update` には更新したいフィールドだけを渡します。指定しなかったフィールドはサーバー側の値が保持されます。更新後の `MisskeyUser` が返されます。

```dart
final updated = await client.account.update(
  name: Optional('Alice'),
  description: Optional('Hello from Misskey!'),
  lang: Optional('ja'),
  isLocked: false,
);
```

### Optional 型について

サーバーが `null` を受け付けるフィールド（値をクリアできるフィールド）は `Optional<T>` 型でラップされています。これにより、次の 3 つの状態を区別できます。

- パラメータを省略 — リクエストに含まれず、サーバー側の値は変わらない。
- `Optional('value')` — フィールドを指定した値に設定する。
- `Optional.null_()` — フィールドを明示的にクリアする。

```dart
// アバターを Drive ファイルに設定し、誕生日をクリアする
await client.account.update(
  avatarId: Optional('driveFileId123'),
  birthday: Optional.null_(),
);
```

### プライバシーと公開設定

```dart
await client.account.update(
  followingVisibility: 'followers', // 'public'、'followers'、または 'private'
  followersVisibility: 'public',
  publicReactions: true,
  isLocked: true,           // フォローに承認を必要とする
  hideOnlineStatus: true,
  noCrawle: true,
  preventAiLearning: true,
);
```

## ノートのピン留め / 解除

```dart
// ノートをプロフィールにピン留めする
final updated = await client.account.pin(noteId: noteId);

// ピン留めを解除する
final updated = await client.account.unpin(noteId: noteId);
```

いずれも更新後の `MisskeyUser` を返します。

## お気に入り

```dart
final favs = await client.account.favorites(limit: 20);
for (final fav in favs) {
  print(fav.note.text);
}
```

`sinceId` / `untilId` またはUnixタイムスタンプ（ミリ秒）の `sinceDate` / `untilDate` でページングできます。

```dart
final older = await client.account.favorites(
  limit: 20,
  untilId: favs.last.id,
);
```

## パスワード・メール・トークン管理

### パスワード変更

```dart
await client.account.changePassword(
  currentPassword: 'hunter2',
  newPassword: 'correct-horse-battery-staple',
);
```

二要素認証が有効な場合は、現在のTOTPコードを `token` として渡します。

### メールアドレスの更新

```dart
final updated = await client.account.updateEmail(
  password: 'mypassword',
  email: Optional('newemail@example.com'),
);

// メールアドレスを削除する
await client.account.updateEmail(
  password: 'mypassword',
  email: Optional.null_(),
);
```

### APIトークンの再生成

呼び出しが完了すると、現在のトークンは即座に無効になります。

```dart
await client.account.regenerateToken(password: 'mypassword');
```

### トークンの失効

```dart
await client.account.revokeTokenById(tokenId);
await client.account.revokeTokenByToken(tokenString);
```

## エクスポートとインポート

エクスポート操作はすべて非同期ジョブとしてキューに積まれます。完了するとサーバーから通知が届きます。

### データのエクスポート

```dart
await client.account.exportNotes();
await client.account.exportFollowing(excludeMuting: true, excludeInactive: true);
await client.account.exportBlocking();
await client.account.exportMute();
await client.account.exportFavorites();
await client.account.exportAntennas();
await client.account.exportClips();
await client.account.exportUserLists();
```

### データのインポート

事前にエクスポートしたファイルの Drive ファイルIDを渡します。

```dart
// 先にファイルを Drive にアップロードしてから ID を渡す
await client.account.importFollowing(fileId: driveFileId, withReplies: true);
await client.account.importBlocking(fileId: driveFileId);
await client.account.importMuting(fileId: driveFileId);
await client.account.importAntennas(fileId: driveFileId);
await client.account.importUserLists(fileId: driveFileId);
```

## サインイン履歴

```dart
final history = await client.account.signinHistory(limit: 20);
for (final entry in history) {
  print('${entry.createdAt} — ${entry.ip}');
}
```

## サブ API

`AccountApi` は 3 つのサブ API をプロパティとして公開しています。

### レジストリ

レジストリはクライアントアプリケーション向けの任意のキーバリューストアです（ブラウザのローカルストレージに相当し、デバイス間で同期されます）。

```dart
// 値を読み取る
final value = await client.account.registry.get(
  key: 'theme',
  scope: ['my-app'],
);

// 値を書き込む
await client.account.registry.set(
  key: 'theme',
  value: 'dark',
  scope: ['my-app'],
);
```

### 二要素認証

```dart
// TOTP の登録を開始する
final reg = await client.account.twoFactor.registerTotp(password: 'mypassword');
print(reg.qr); // UIに表示するQRコードのデータURL

// 認証アプリの最初のコードで TOTP を確認・有効化する
await client.account.twoFactor.done(token: '123456');
```

### Webhook

```dart
// Webhook を作成する
final webhook = await client.account.webhooks.create(
  name: 'My webhook',
  url: 'https://example.com/hook',
  on: ['note', 'follow'],
  secret: 'supersecret',
);

// Webhook 一覧を取得する
final webhooks = await client.account.webhooks.list();
```
