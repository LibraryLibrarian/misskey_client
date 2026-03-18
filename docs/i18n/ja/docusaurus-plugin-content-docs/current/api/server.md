---
sidebar_position: 8
title: "サーバーとフェデレーション"
---

# サーバーとフェデレーション

サーバーメタデータ・フェデレーション・ロール・チャート・ActivityPub に関するAPIを説明します。

## MetaApi

`client.meta` はサーバーメタデータの取得と機能検出を提供します。

### メタデータの取得

```dart
final meta = await client.meta.getMeta();
print(meta.name);        // サーバー名
print(meta.description); // サーバーの説明
```

初回取得後はメモリにキャッシュされます。キャッシュをバイパスするには `refresh: true` を指定します。

```dart
final fresh = await client.meta.getMeta(refresh: true);
```

軽量レスポンス（`MetaLite` 相当）を取得するには `detail: false` を渡します。

```dart
final lite = await client.meta.getMeta(detail: false);
```

### 機能検出

`supports()` を呼ぶ前に `getMeta()` を少なくとも一度呼び出してください。
ドット記法のキーパスでレスポンスのフィールドを確認します。

```dart
await client.meta.getMeta();

if (client.meta.supports('features.miauth')) {
  // MiAuth が利用可能
}

if (client.meta.supports('policies.canInvite')) {
  // 招待機能が有効
}
```

### サーバー情報・統計・ping

```dart
// マシン情報（CPU・メモリ・ディスク）
final info = await client.meta.getServerInfo();
print(info.cpu.model);
print(info.mem.total);

// インスタンス統計（ユーザー数・ノート数など）
final stats = await client.meta.getStats();
print(stats.usersCount);
print(stats.notesCount);

// ping — サーバー時刻をUnixタイムスタンプ（ms）で返す
final timestamp = await client.meta.ping();
```

### エンドポイント情報

```dart
// 全エンドポイント名の一覧
final endpoints = await client.meta.getEndpoints();

// 特定エンドポイントのパラメーター情報
final info = await client.meta.getEndpoint(endpoint: 'notes/create');
if (info != null) {
  for (final param in info.params) {
    print('${param.name}: ${param.type}');
  }
}
```

### カスタム絵文字

```dart
// 絵文字一覧（カテゴリ・名前順）
final emojis = await client.meta.getEmojis();

// ショートコードで1件取得
final emoji = await client.meta.getEmoji(name: 'blobcat');
print(emoji.url);
```

### その他のサーバー情報

```dart
// 管理者が設定したピン留めユーザー
final pinned = await client.meta.getPinnedUsers();

// 現在オンラインのユーザー数（60秒キャッシュ）
final count = await client.meta.getOnlineUsersCount();

// 利用可能なアバターデコレーション
final decorations = await client.meta.getAvatarDecorations();

// ユーザーリテンションデータ（最大30件・3600秒キャッシュ）
final retention = await client.meta.getRetention();
for (final record in retention) {
  print('${record.createdAt}: ${record.users} 登録');
}
```

## FederationApi

`client.federation` は連合しているインスタンスの情報を提供します。

### インスタンス一覧

```dart
// 連合している全インスタンス
final instances = await client.federation.instances(limit: 30);

// ステータスフラグでフィルター
final blocked = await client.federation.instances(blocked: true, limit: 20);
final suspended = await client.federation.instances(suspended: true);
final active = await client.federation.instances(federating: true, limit: 50);

// フォロワー数の降順でソート
final top = await client.federation.instances(
  sort: '-followers',
  limit: 10,
);
```

`sort` に指定できる値: `+pubSub` / `-pubSub`、`+notes` / `-notes`、
`+users` / `-users`、`+following` / `-following`、`+followers` / `-followers`、
`+firstRetrievedAt` / `-firstRetrievedAt`、`+latestRequestReceivedAt` / `-latestRequestReceivedAt`

### インスタンス詳細

```dart
final instance = await client.federation.showInstance(host: 'mastodon.social');
if (instance != null) {
  print(instance.usersCount);
  print(instance.notesCount);
}
```

### リモートインスタンスのフォロー関係

```dart
// リモートインスタンスからのフォロー
final followers = await client.federation.followers(
  host: 'mastodon.social',
  limit: 20,
);

// リモートインスタンスへのフォロー
final following = await client.federation.following(
  host: 'mastodon.social',
  limit: 20,
);

// リモートインスタンスの既知ユーザー
final users = await client.federation.users(
  host: 'mastodon.social',
  limit: 20,
);
```

### フェデレーション統計

```dart
// フォロー数上位インスタンス
final stats = await client.federation.stats(limit: 10);
print(stats.topSubInstances.first.host);
```

### リモートユーザーの更新

```dart
// リモートユーザーのActivityPubプロフィールを再取得（認証必須）
await client.federation.updateRemoteUser(userId: remoteUserId);
```

## RolesApi

`client.roles` は公開ロール情報を提供します。

```dart
// 公開・探索可能なロール一覧（認証必須）
final roles = await client.roles.list();

// 特定ロールの詳細（認証不要）
final role = await client.roles.show(roleId: 'roleId123');
print(role.name);
print(role.color);

// ロールに属するユーザーのノート（認証必須）
final notes = await client.roles.notes(roleId: role.id, limit: 20);

// ロールに属するユーザー（認証不要）
final members = await client.roles.users(roleId: role.id, limit: 20);
```

リスト系のメソッドはすべて `sinceId`・`untilId`・`sinceDate`・`untilDate` によるページネーションに対応しています。

## ChartsApi

`client.charts` は時系列データを返します。すべてのメソッドで `span`（`'day'` または `'hour'`）・`limit`（1〜500、デフォルト30）・`offset` を指定できます。

```dart
// 過去30日間のアクティブユーザー数
final activeUsers = await client.charts.getActiveUsers(span: 'day');

// ノート数（ローカル・リモート）
final notes = await client.charts.getNotes(span: 'day', limit: 14);

// ユーザー数（ローカル・リモート）
final users = await client.charts.getUsers(span: 'hour', limit: 24);

// フェデレーションアクティビティ
final fed = await client.charts.getFederation(span: 'day');

// ActivityPubリクエスト統計
final ap = await client.charts.getApRequest(span: 'hour', limit: 48);

// インスタンス別チャート
final inst = await client.charts.getInstance(
  host: 'mastodon.social',
  span: 'day',
  limit: 7,
);

// ユーザー別チャート
final userNotes = await client.charts.getUserNotes(
  userId: userId,
  span: 'day',
  limit: 30,
);
```

各レスポンスは `Map<String, dynamic>` で、末端の値は `List<num>` の時系列配列です。

## ApApi

`client.ap` はリモートサーバーのActivityPubオブジェクトを解決します（認証必須、レート制限: 30回/時間）。

```dart
// APURIからユーザーまたはノートを解決
final result = await client.ap.show(
  uri: 'https://mastodon.social/users/alice',
);
if (result is ApShowUser) {
  print(result.user.username);
} else if (result is ApShowNote) {
  print(result.note.text);
}

// 生のAPオブジェクトを取得（管理者専用）
final raw = await client.ap.get(
  uri: 'https://mastodon.social/users/alice',
);
print(raw['type']); // 例: 'Person'
```
