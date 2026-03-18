---
sidebar_position: 4
title: "Account & Profile"
---

# Account & Profile

The `client.account` API provides operations for the currently authenticated user — fetching and updating profile information, managing credentials, exporting/importing data, and accessing sub-APIs for the registry, two-factor authentication, and webhooks.

## Fetching your profile

```dart
final me = await client.account.i();
print(me.name);        // Display name
print(me.username);    // Username (without @)
print(me.description); // Bio text
```

## Updating your profile

`update` accepts any combination of fields. Only fields you pass are sent to the server; omitted fields are left unchanged and the updated `MisskeyUser` is returned.

```dart
final updated = await client.account.update(
  name: Optional('Alice'),
  description: Optional('Hello from Misskey!'),
  lang: Optional('en'),
  isLocked: false,
);
```

### The Optional type

Fields that the server can accept as `null` (to clear the value) use the `Optional<T>` wrapper. This lets the library distinguish between three states:

- Parameter omitted — field is not included in the request; server value unchanged.
- `Optional('value')` — field is set to the given value.
- `Optional.null_()` — field is explicitly cleared.

```dart
// Set the avatar to a Drive file and clear the birthday
await client.account.update(
  avatarId: Optional('driveFileId123'),
  birthday: Optional.null_(),
);
```

### Privacy and visibility

```dart
await client.account.update(
  followingVisibility: 'followers', // 'public', 'followers', or 'private'
  followersVisibility: 'public',
  publicReactions: true,
  isLocked: true,                   // require follow approval
  hideOnlineStatus: true,
  noCrawle: true,
  preventAiLearning: true,
);
```

## Pinning and unpinning notes

```dart
// Pin a note to your profile
final updated = await client.account.pin(noteId: noteId);

// Unpin it
final updated = await client.account.unpin(noteId: noteId);
```

Both methods return the updated `MisskeyUser`.

## Favorites

```dart
final favs = await client.account.favorites(limit: 20);
for (final fav in favs) {
  print(fav.note.text);
}
```

Paginate with `sinceId` / `untilId` or `sinceDate` / `untilDate` (Unix timestamp in milliseconds).

```dart
final older = await client.account.favorites(
  limit: 20,
  untilId: favs.last.id,
);
```

## Password, email, and token management

### Change password

```dart
await client.account.changePassword(
  currentPassword: 'hunter2',
  newPassword: 'correct-horse-battery-staple',
);
```

If two-factor authentication is enabled, pass the current TOTP code as `token`.

### Update email address

```dart
final updated = await client.account.updateEmail(
  password: 'mypassword',
  email: Optional('newemail@example.com'),
);

// Remove the email address
await client.account.updateEmail(
  password: 'mypassword',
  email: Optional.null_(),
);
```

### Regenerate API token

The current token is invalidated immediately after the call completes.

```dart
await client.account.regenerateToken(password: 'mypassword');
```

### Revoke a token

```dart
await client.account.revokeTokenById(tokenId);
await client.account.revokeTokenByToken(tokenString);
```

## Export and import

All export operations are queued as asynchronous jobs. A notification is sent upon completion.

### Exporting data

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

### Importing data

Pass the Drive file ID of the previously exported file.

```dart
// Upload the file to Drive first, then pass its ID
await client.account.importFollowing(fileId: driveFileId, withReplies: true);
await client.account.importBlocking(fileId: driveFileId);
await client.account.importMuting(fileId: driveFileId);
await client.account.importAntennas(fileId: driveFileId);
await client.account.importUserLists(fileId: driveFileId);
```

## Sign-in history

```dart
final history = await client.account.signinHistory(limit: 20);
for (final entry in history) {
  print('${entry.createdAt} — ${entry.ip}');
}
```

## Sub-APIs

`AccountApi` exposes three sub-APIs as properties.

### Registry

The registry stores arbitrary key-value data for client applications (equivalent to browser localStorage, but synced across devices).

```dart
// Read a value
final value = await client.account.registry.get(
  key: 'theme',
  scope: ['my-app'],
);

// Write a value
await client.account.registry.set(
  key: 'theme',
  value: 'dark',
  scope: ['my-app'],
);
```

### Two-factor authentication

```dart
// Begin TOTP registration
final reg = await client.account.twoFactor.registerTotp(password: 'mypassword');
print(reg.qr); // QR code data URL to show in the UI

// Confirm and activate TOTP with the first code from the authenticator app
await client.account.twoFactor.done(token: '123456');
```

### Webhooks

```dart
// Create a webhook
final webhook = await client.account.webhooks.create(
  name: 'My webhook',
  url: 'https://example.com/hook',
  on: ['note', 'follow'],
  secret: 'supersecret',
);

// List webhooks
final webhooks = await client.account.webhooks.list();
```
