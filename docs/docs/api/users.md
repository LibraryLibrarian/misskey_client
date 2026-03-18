---
sidebar_position: 2
title: Users
---

# Users

The `client.users` API provides operations for looking up users, managing follow relationships, and handling blocks and mutes. Profile management for the authenticated user is under `client.account`.

## Fetching users

### By user ID

```dart
final user = await client.users.showOneByUserId('9abc');
print(user.name);     // Display name
print(user.username); // Username (without @)
print(user.host);     // null for local users, hostname for remote
```

### By username

```dart
// Local user
final user = await client.users.showOneByUsername('alice');

// Remote user
final user = await client.users.showOneByUsername('alice', host: 'other.example.com');
```

### Multiple users at once

```dart
final users = await client.users.showMany(
  userIds: ['9abc', '9def', '9ghi'],
);
```

### Listing users (directory)

```dart
// Local users sorted by follower count
final users = await client.users.list(
  limit: 20,
  sort: '+follower',
  origin: 'local',
);
```

Available `sort` values: `+follower`, `-follower`, `+createdAt`, `-createdAt`, `+updatedAt`, `-updatedAt`.
Available `origin` values: `local`, `remote`, `combined`.

## Followers and following

```dart
// Followers of a user (by ID)
final followers = await client.users.followersByUserId(userId, limit: 20);

// Followers of a user (by username)
final followers = await client.users.followersByUsername('alice', limit: 20);

// Accounts a user follows
final following = await client.users.followingByUserId(userId, limit: 20);
```

Paginate with `sinceId` / `untilId` / `sinceDate` / `untilDate`.

## Notes by a user

```dart
final notes = await client.users.notes(
  userId: userId,
  limit: 20,
  withReplies: false,
  withRenotes: true,
);
```

`withReplies` and `withFiles` cannot both be `true` simultaneously (server constraint).

## Following operations

### Follow a user

```dart
final user = await client.following.create(userId: userId);
```

If the target requires follow approval, a request is sent instead.

### Unfollow

```dart
await client.following.delete(userId: userId);
```

### Update follow settings

```dart
// Change notification level for a specific follow
await client.following.update(
  userId: userId,
  notify: 'normal', // 'normal' or 'none'
  withReplies: true,
);
```

### Remove a follower

```dart
// Forcibly removes someone following you
await client.following.invalidate(userId: userId);
```

### Follow requests

```dart
// List pending incoming requests
final requests = await client.following.requests.listReceived();

// Accept or reject
await client.following.requests.accept(userId: userId);
await client.following.requests.reject(userId: userId);

// Cancel an outgoing request you sent
await client.following.requests.cancel(userId: userId);
```

## Blocking

```dart
// Block a user (removes the mutual follow relationship)
await client.blocking.create(userId: userId);

// Unblock
await client.blocking.delete(userId: userId);

// List your blocked users
final blocked = await client.blocking.list(limit: 20);
```

## Muting

```dart
// Mute a user
await client.mute.create(userId: userId);

// Mute with an expiry (Unix timestamp in milliseconds)
await client.mute.create(userId: userId, expiresAt: expiresAt);

// Unmute
await client.mute.delete(userId: userId);

// List your muted users
final muted = await client.mute.list(limit: 20);
```

## Account management

Profile operations for the authenticated user live under `client.account`.

### Fetch own profile

```dart
final me = await client.account.i();
print(me.name);
print(me.description);
```

### Update profile

```dart
final updated = await client.account.update(
  name: 'Alice',
  description: 'Hello from Misskey!',
  lang: 'en',
);
```

Only specified fields are changed; omitted fields remain as-is.

## User search

```dart
final results = await client.users.search(
  query: 'alice',
  limit: 20,
  origin: 'combined',
);
```

## User lists

User lists are accessible via `client.users.lists`:

```dart
// Create a list
final list = await client.users.lists.create(name: 'Friends');

// Add a user to a list
await client.users.lists.push(listId: list.id, userId: userId);

// Remove a user from a list
await client.users.lists.pull(listId: list.id, userId: userId);

// Fetch your lists
final lists = await client.users.lists.list();

// Fetch members of a list
final members = await client.users.lists.getMemberships(listId: list.id);
```
