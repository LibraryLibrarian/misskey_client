---
sidebar_position: 3
---

# 通知

## 通知の取得

```dart
final notifications = await client.notifications.list();

for (final notification in notifications) {
  print('種別: ${notification.type}');
  print('時刻: ${notification.createdAt}');
}
```

ページングには `untilId` を使用します。

```dart
final olderNotifications = await client.notifications.list(
  untilId: notifications.last.id,
);
```

通知の種別でフィルタリングすることもできます。

```dart
// リアクション通知のみ取得
final reactions = await client.notifications.list(
  includeTypes: ['reaction'],
);
```

## 既読処理

### すべての通知を既読にする

```dart
await client.notifications.markAllAsRead();
```

### 特定の通知を既読にする

```dart
await client.notifications.read(notificationId: 'notif_id');
```

## カスタム通知の作成

アプリ内でカスタム通知を送ることができます。

```dart
await client.notifications.create(
  header: 'バックアップ完了',
  body: 'データのバックアップが正常に完了しました。',
  icon: 'https://example.com/icon.png',
);
```

## テスト通知

通知の動作確認用にテスト通知を送信します。

```dart
await client.notifications.test();
```

通知設定が正しく機能しているかを確認するために使用します。
