---
sidebar_position: 3
title: ページネーション
---

# ページネーション

Misskey はカーソルベースのページネーションを採用しています。リストを返す API はページネーションパラメータを直接受け取り、`List<T>` を返します。ラッパー型は存在しません。呼び出し側でパラメータを渡し、返却されたリストの件数を見て次ページの有無を判断します。

## ページネーションパラメータ

| パラメータ    | 型      | 説明                                                  |
|-------------|--------|------------------------------------------------------|
| `sinceId`   | String | このノート/オブジェクト ID **より新しい** 結果を返す       |
| `untilId`   | String | このノート/オブジェクト ID **より古い** 結果を返す         |
| `sinceDate` | int    | このUnixタイムスタンプ（ms）より新しい結果を返す           |
| `untilDate` | int    | このUnixタイムスタンプ（ms）より古い結果を返す             |
| `limit`     | int    | 返却する最大件数（通常 1〜100）                          |
| `offset`    | int    | 指定件数をスキップする（オフセット方式の API のみ）         |

すべての API がすべてのパラメータに対応しているわけではありません。各エンドポイントの API リファレンスを参照してください。

## カーソルベースのページネーション（ID による）

古いページを取得するには `untilId`、新しいページを取得するには `sinceId` を使用します。

### 古いページの取得

```dart
// 最初のページ — 最新の通知
List<MisskeyNotification> page = await client.notifications.list(limit: 20);

// 次のページ — 前ページの最後のアイテムより古いもの
while (page.isNotEmpty) {
  final oldestId = page.last.id;
  final next = await client.notifications.list(
    limit: 20,
    untilId: oldestId,
  );
  if (next.isEmpty) break;
  page = next;
}
```

### 新しいページの取得

```dart
// 最後に取得した最新 ID を保持する
String? latestId;

Future<List<MisskeyNote>> pollNewNotes() async {
  final notes = await client.notes.timelineHome(
    limit: 20,
    sinceId: latestId,
  );
  if (notes.isNotEmpty) {
    latestId = notes.first.id;
  }
  return notes;
}
```

## タイムスタンプベースのページネーション

ID ではなく時刻でページングしたい場合は `sinceDate` / `untilDate` を使用します。

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final oneDayAgo = now - const Duration(days: 1).inMilliseconds;

final notes = await client.notes.timelineLocal(
  limit: 30,
  sinceDate: oneDayAgo,
  untilDate: now,
);
```

## オフセットベースのページネーション

一部の API はカーソルパラメータの代わりに `offset` に対応しています。カーソルによるナビゲーションが使えない場合に利用します。

```dart
const pageSize = 50;
var offset = 0;

while (true) {
  final users = await client.users.list(
    limit: pageSize,
    offset: offset,
  );
  // users を処理する...
  if (users.length < pageSize) break; // 最終ページ
  offset += users.length;
}
```

## 最終ページの判定

`hasNext` のようなフラグはありません。返却件数が `limit` を下回った場合が最終ページです。

```dart
const limit = 20;
final page = await client.blocking.list(limit: limit);
final isLastPage = page.length < limit;
```

## 全ページを取得する

```dart
Future<List<MisskeyNote>> fetchAllFavorites() async {
  const limit = 100;
  final all = <MisskeyNote>[];
  String? untilId;

  while (true) {
    final page = await client.account.favorites(
      limit: limit,
      untilId: untilId,
    );
    all.addAll(page);
    if (page.length < limit) break;
    untilId = page.last.id;
  }

  return all;
}
```

## ページネーションに対応する主な API

リストを返す API の多くは `sinceId`/`untilId` と `limit` に対応しています。

- `client.notes.timelineHome` / `timelineLocal` / `timelineGlobal`
- `client.notes.list`
- `client.notifications.list`
- `client.account.favorites`
- `client.blocking.list`
- `client.mute.list`
- `client.clips.list`
- `client.following.requests.list`
- `client.antennas.notes`
- `client.channels.timeline`
- `client.users.list`（オフセット方式）
- `client.notes.search`（オフセット方式）
