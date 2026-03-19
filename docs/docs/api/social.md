---
sidebar_position: 5
title: "Social"
---

# Social

The social APIs cover follow relationships, follow requests, blocking, and muting. All operations require authentication.

## Following (`client.following`)

### Follow a user

```dart
final user = await client.following.create(userId: userId);
```

If the target user requires follow approval, a request is sent instead of an immediate follow. The method returns the updated `MisskeyUser`.

Pass `withReplies: true` to include the followed user's replies in your timeline:

```dart
await client.following.create(userId: userId, withReplies: true);
```

### Unfollow

```dart
await client.following.delete(userId: userId);
```

### Update follow settings

Change notification and reply display settings for an individual follow relationship.

```dart
await client.following.update(
  userId: userId,
  notify: 'normal',   // 'normal' or 'none'
  withReplies: true,
);
```

### Update all follows at once

Apply the same settings to every account you follow. Rate limit: 10 requests/hour.

```dart
await client.following.updateAll(notify: 'none', withReplies: false);
```

### Remove a follower

Forcibly removes someone who is following you.

```dart
await client.following.invalidate(userId: userId);
```

## Follow requests (`client.following.requests`)

### Incoming requests

```dart
// List pending requests sent to you
final incoming = await client.following.requests.list(limit: 20);
for (final req in incoming) {
  print(req.follower.username);
}

// Accept a request
await client.following.requests.accept(userId: userId);

// Reject a request
await client.following.requests.reject(userId: userId);
```

### Outgoing requests

```dart
// List requests you have sent
final sent = await client.following.requests.sent(limit: 20);

// Cancel a request you sent
await client.following.requests.cancel(userId: userId);
```

All list methods accept `sinceId` / `untilId` and `sinceDate` / `untilDate` for pagination.

## Blocking (`client.blocking`)

Blocking removes the mutual follow relationship between you and the target. A blocked user cannot follow you, and you will not see their content.

### Block a user

```dart
await client.blocking.create(userId: userId);
```

### Unblock

```dart
await client.blocking.delete(userId: userId);
```

### List blocked users

```dart
final blocked = await client.blocking.list(limit: 20);
for (final b in blocked) {
  print(b.blockee.username);
}
```

Paginate with `sinceId` / `untilId` or `sinceDate` / `untilDate`.

## Muting (`client.mute`)

Muting hides a user's notes, renotes, and reactions from your timeline. Unlike blocking, the target user is unaware they have been muted.

### Mute a user

```dart
// Permanent mute
await client.mute.create(userId: userId);
```

### Timed mute

Pass a Unix timestamp in milliseconds to expire the mute automatically.

```dart
// Mute for 24 hours
final expiresAt = DateTime.now()
    .add(const Duration(hours: 24))
    .millisecondsSinceEpoch;

await client.mute.create(userId: userId, expiresAt: expiresAt);
```

### Unmute

```dart
await client.mute.delete(userId: userId);
```

### List muted users

```dart
final muted = await client.mute.list(limit: 20);
for (final m in muted) {
  print(m.mutee.username);
}
```

## Renote muting (`client.renoteMute`)

Renote muting suppresses only a user's renotes from your timeline. Their original notes remain visible. This is useful when you want to follow someone's original content but not their reposted content.

### Renote-mute a user

```dart
await client.renoteMute.create(userId: userId);
```

### Remove a renote mute

```dart
await client.renoteMute.delete(userId: userId);
```

### List renote-muted users

```dart
final renoteMuted = await client.renoteMute.list(limit: 20);
for (final rm in renoteMuted) {
  print(rm.mutee.username);
}
```

Paginate with `sinceId` / `untilId` or `sinceDate` / `untilDate`.

## Comparison: mute vs renote mute

| | Regular mute | Renote mute |
|---|---|---|
| Original notes hidden | Yes | No |
| Renotes hidden | Yes | Yes |
| Target notified | No | No |
| Timed expiry | Yes | No |
