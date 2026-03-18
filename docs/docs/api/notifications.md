---
sidebar_position: 3
title: Notifications
---

# Notifications

The `client.notifications` API manages notification retrieval, bulk marking, and creating custom notifications.

## Fetching notifications

### List

```dart
final notifications = await client.notifications.list(limit: 20);

for (final n in notifications) {
  print('${n.type}: ${n.userId}');
}
```

By default, fetching marks notifications as read. Pass `markAsRead: false` to suppress this:

```dart
final notifications = await client.notifications.list(
  limit: 20,
  markAsRead: false,
);
```

### Grouped notifications

Reactions and renotes on the same note are merged into a single entry:

```dart
final grouped = await client.notifications.listGrouped(limit: 20);
```

### Filtering by type

```dart
// Only mentions and reactions
final notifications = await client.notifications.list(
  includeTypes: ['mention', 'reaction'],
);

// Everything except follows
final notifications = await client.notifications.list(
  excludeTypes: ['follow'],
);
```

Common notification types: `follow`, `mention`, `reply`, `renote`, `quote`, `reaction`, `pollEnded`, `achievementEarned`, `app`.

### Pagination

```dart
// Older notifications
final older = await client.notifications.list(
  limit: 20,
  untilId: notifications.last.id,
);

// New notifications since last fetch
final newer = await client.notifications.list(
  limit: 20,
  sinceId: notifications.first.id,
);
```

`sinceDate` and `untilDate` accept Unix timestamps in milliseconds as an alternative to ID-based pagination.

## Marking as read

### Mark all as read

```dart
await client.notifications.markAllAsRead();
```

### Flush all notifications

Permanently deletes all notifications:

```dart
await client.notifications.flush();
```

## Creating notifications

### App notification

Sends a custom notification from your app to the authenticated user. Requires `write:notifications` permission.

```dart
await client.notifications.create(
  body: 'Your export is ready to download.',
  header: 'Export complete',
  icon: 'https://example.com/icon.png',
);
```

`header` defaults to the access token's name and `icon` defaults to the token's icon URL if omitted.

### Test notification

Sends a test notification (`type: test`) to the authenticated user. Useful for verifying that your notification handling works correctly.

```dart
await client.notifications.testNotification();
```

Both `create` and `testNotification` have a rate limit of 10 requests per minute.
