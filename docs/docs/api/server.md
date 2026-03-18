---
sidebar_position: 8
title: "Server & Federation"
---

# Server & Federation

This page covers APIs for querying server metadata, federation, roles, charts, and ActivityPub.

## MetaApi

`client.meta` provides server metadata and capability detection.

### Fetching metadata

```dart
final meta = await client.meta.getMeta();
print(meta.name);        // Server name
print(meta.description); // Server description
```

Results are cached in memory after the first call. Use `refresh: true` to bypass the cache:

```dart
final fresh = await client.meta.getMeta(refresh: true);
```

Pass `detail: false` for a lightweight response (equivalent to `MetaLite`):

```dart
final lite = await client.meta.getMeta(detail: false);
```

### Feature detection

Call `getMeta()` at least once before using `supports()`. It checks for a key
in the raw response using a dot-notation path:

```dart
await client.meta.getMeta();

if (client.meta.supports('features.miauth')) {
  // MiAuth is available on this server
}

if (client.meta.supports('policies.canInvite')) {
  // Invite feature is enabled
}
```

### Server info, stats, and ping

```dart
// Machine info: CPU, memory, disk
final info = await client.meta.getServerInfo();
print(info.cpu.model);
print(info.mem.total);

// Instance statistics: user count, note count, etc.
final stats = await client.meta.getStats();
print(stats.usersCount);
print(stats.notesCount);

// Ping — returns the server time as a Unix timestamp (ms)
final timestamp = await client.meta.ping();
```

### Endpoints

```dart
// All endpoint names
final endpoints = await client.meta.getEndpoints();

// Parameters for a specific endpoint
final info = await client.meta.getEndpoint(endpoint: 'notes/create');
if (info != null) {
  for (final param in info.params) {
    print('${param.name}: ${param.type}');
  }
}
```

### Custom emoji

```dart
// Full emoji list (sorted by category and name)
final emojis = await client.meta.getEmojis();

// Details for a single emoji by shortcode
final emoji = await client.meta.getEmoji(name: 'blobcat');
print(emoji.url);
```

### Other server queries

```dart
// Users pinned by administrators
final pinned = await client.meta.getPinnedUsers();

// Count of users active in the last few minutes (cached 60 s)
final count = await client.meta.getOnlineUsersCount();

// Available avatar decorations
final decorations = await client.meta.getAvatarDecorations();

// User retention data — up to 30 daily records (cached 3600 s)
final retention = await client.meta.getRetention();
for (final record in retention) {
  print('${record.createdAt}: ${record.users} registrations');
}
```

## FederationApi

`client.federation` provides information about instances the server federates with.

### Listing instances

```dart
// All known federated instances
final instances = await client.federation.instances(limit: 30);

// Filter by status flags
final blocked = await client.federation.instances(blocked: true, limit: 20);
final suspended = await client.federation.instances(suspended: true);
final active = await client.federation.instances(federating: true, limit: 50);

// Sort by follower count (descending)
final top = await client.federation.instances(
  sort: '-followers',
  limit: 10,
);
```

Available `sort` values: `+pubSub` / `-pubSub`, `+notes` / `-notes`,
`+users` / `-users`, `+following` / `-following`, `+followers` / `-followers`,
`+firstRetrievedAt` / `-firstRetrievedAt`, `+latestRequestReceivedAt` / `-latestRequestReceivedAt`.

### Instance details

```dart
final instance = await client.federation.showInstance(host: 'mastodon.social');
if (instance != null) {
  print(instance.usersCount);
  print(instance.notesCount);
}
```

### Followers and following for a host

```dart
// Relationships followed from a remote instance
final followers = await client.federation.followers(
  host: 'mastodon.social',
  limit: 20,
);

final following = await client.federation.following(
  host: 'mastodon.social',
  limit: 20,
);

// Users known from a remote instance
final users = await client.federation.users(
  host: 'mastodon.social',
  limit: 20,
);
```

### Federation statistics

```dart
// Top instances by follower/following counts
final stats = await client.federation.stats(limit: 10);
print(stats.topSubInstances.first.host);
```

### Refreshing a remote user

```dart
// Re-fetch the ActivityPub profile for a remote user (requires auth)
await client.federation.updateRemoteUser(userId: remoteUserId);
```

## RolesApi

`client.roles` exposes public role information.

```dart
// List all public, explorable roles (requires auth)
final roles = await client.roles.list();

// Details for a specific role (no auth required)
final role = await client.roles.show(roleId: 'roleId123');
print(role.name);
print(role.color);

// Notes from users belonging to a role (requires auth)
final notes = await client.roles.notes(roleId: role.id, limit: 20);

// Users belonging to a role (no auth required)
final members = await client.roles.users(roleId: role.id, limit: 20);
```

All list methods accept `sinceId`, `untilId`, `sinceDate`, and `untilDate` for pagination.

## ChartsApi

`client.charts` returns time-series data. All methods accept `span` (`'day'` or `'hour'`),
`limit` (1-500, default 30), and `offset`.

```dart
// Active users over the last 30 days
final activeUsers = await client.charts.getActiveUsers(span: 'day');

// Note counts (local and remote)
final notes = await client.charts.getNotes(span: 'day', limit: 14);

// User counts (local and remote)
final users = await client.charts.getUsers(span: 'hour', limit: 24);

// Federation activity
final fed = await client.charts.getFederation(span: 'day');

// ActivityPub request outcomes
final ap = await client.charts.getApRequest(span: 'hour', limit: 48);

// Per-instance chart
final inst = await client.charts.getInstance(
  host: 'mastodon.social',
  span: 'day',
  limit: 7,
);

// Per-user charts
final userNotes = await client.charts.getUserNotes(
  userId: userId,
  span: 'day',
  limit: 30,
);
```

Each response is a `Map<String, dynamic>` where leaf values are `List<num>` time-series arrays.

## ApApi

`client.ap` resolves ActivityPub objects from remote servers (requires auth, rate limit: 30/hour).

```dart
// Resolve a user or note from an AP URI
final result = await client.ap.show(
  uri: 'https://mastodon.social/users/alice',
);
if (result is ApShowUser) {
  print(result.user.username);
} else if (result is ApShowNote) {
  print(result.note.text);
}

// Fetch the raw AP object (admin-only)
final raw = await client.ap.get(
  uri: 'https://mastodon.social/users/alice',
);
print(raw['type']); // e.g. 'Person'
```
