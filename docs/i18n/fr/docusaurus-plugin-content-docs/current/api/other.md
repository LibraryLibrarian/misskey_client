---
sidebar_position: 9
title: "Autres API"
---

# Autres API

Cette page couvre Chat, Annonces, Hashtags, Codes d'invitation et les notifications push Service Worker.

## ChatApi

`client.chat` fournit la messagerie directe et la messagerie de groupe. Tous les points d'accès du chat nécessitent une authentification.

### Historique et état de lecture

```dart
// Recent DM conversation history
final dmHistory = await client.chat.history(limit: 10);

// Recent room message history
final roomHistory = await client.chat.history(limit: 10, room: true);

// Mark all messages as read
await client.chat.readAll();
```

### Messages directs

```dart
// Send a message to a user
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Hello!',
);

// Attach a Drive file
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Here is the file.',
  fileId: driveFileId,
);

// Delete a message
await client.chat.messages.delete(messageId: msg.id);

// React to a message
await client.chat.messages.react(messageId: msg.id, reaction: ':heart:');

// Remove a reaction
await client.chat.messages.unreact(messageId: msg.id, reaction: ':heart:');
```

### Fils de messages

```dart
// Direct message history with a user (cursor-based pagination)
final messages = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
);

// Fetch older messages
final older = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
  untilId: messages.last.id,
);

// Room message timeline
final roomMessages = await client.chat.messages.roomTimeline(
  roomId: roomId,
  limit: 20,
);
```

### Recherche de messages

```dart
final results = await client.chat.messages.search(
  query: 'meeting',
  limit: 20,
  userId: targetUserId, // optional: restrict to one conversation
);
```

### Salons de discussion

```dart
// Create a room
final room = await client.chat.rooms.create(
  name: 'Project Alpha',
  description: 'Coordination channel',
);

// Update room details
await client.chat.rooms.update(
  roomId: room.id,
  name: 'Project Alpha — Active',
);

// Delete a room
await client.chat.rooms.delete(roomId: room.id);

// Join and leave
await client.chat.rooms.join(roomId: room.id);
await client.chat.rooms.leave(roomId: room.id);

// Mute/unmute a room
await client.chat.rooms.setMute(roomId: room.id, mute: true);

// Member list
final members = await client.chat.rooms.members(roomId: room.id, limit: 30);

// Rooms you own
final owned = await client.chat.rooms.owned(limit: 20);

// Rooms you have joined
final joined = await client.chat.rooms.joining(limit: 20);
```

### Invitations dans les salons

```dart
// Invite a user to a room
await client.chat.rooms.invitationsCreate(
  roomId: room.id,
  userId: targetUserId,
);

// List received invitations
final inbox = await client.chat.rooms.invitationsInbox(limit: 20);

// List sent invitations for a room
final outbox = await client.chat.rooms.invitationsOutbox(
  roomId: room.id,
  limit: 20,
);

// Dismiss a received invitation
await client.chat.rooms.invitationsIgnore(roomId: room.id);
```

## AnnouncementsApi

`client.announcements` récupère les annonces du serveur. L'authentification est optionnelle ;
lorsqu'elle est fournie, chaque élément inclut un indicateur `isRead`.

```dart
// Active announcements (default)
final active = await client.announcements.list(limit: 10);

// Include inactive announcements too
final all = await client.announcements.list(isActive: false, limit: 20);

// Details for a single announcement
final ann = await client.announcements.show(announcementId: ann.id);
print(ann.title);
print(ann.text);
```

Paginez avec `sinceId`, `untilId`, `sinceDate` et `untilDate`.

### Marquer comme lu

Marquez une annonce comme lue via `client.account` :

```dart
await client.account.readAnnouncement(announcementId: ann.id);
```

## HashtagsApi

`client.hashtags` fournit la recherche de hashtags et les données de tendances. Aucune authentification n'est requise.

### Lister et rechercher

```dart
// Hashtags sorted by number of users who have posted them
final tags = await client.hashtags.list(
  sort: '+mentionedUsers',
  limit: 20,
);

// Prefix search — returns a list of tag name strings
final suggestions = await client.hashtags.search(
  query: 'miss',
  limit: 10,
);
```

Valeurs `sort` disponibles : `+mentionedUsers` / `-mentionedUsers`,
`+mentionedLocalUsers` / `-mentionedLocalUsers`,
`+mentionedRemoteUsers` / `-mentionedRemoteUsers`,
`+attachedUsers` / `-attachedUsers`,
`+attachedLocalUsers` / `-attachedLocalUsers`,
`+attachedRemoteUsers` / `-attachedRemoteUsers`.

### Détails et tendances d'un hashtag

```dart
// Detailed stats for one tag
final tag = await client.hashtags.show(tag: 'misskey');
print(tag.mentionedUsersCount);

// Trending tags (up to 10, cached 60 s)
final trending = await client.hashtags.trend();
for (final t in trending) {
  print('${t.tag}: ${t.chart}');
}
```

### Utilisateurs pour un hashtag

```dart
final users = await client.hashtags.users(
  tag: 'misskey',
  sort: '+follower',
  limit: 20,
  origin: 'local', // 'local', 'remote', or 'combined'
  state: 'alive',  // 'all' or 'alive'
);
```

## InviteApi

`client.invite` gère les codes d'invitation sur les serveurs sur invitation uniquement. Tous les points d'accès nécessitent une authentification et la politique de rôle `canInvite`.

```dart
// Create an invite code
final code = await client.invite.create();
print(code.code);

// Check remaining quota (null means unlimited)
final remaining = await client.invite.limit();
if (remaining != null) {
  print('$remaining invite(s) remaining');
}

// List your issued codes
final codes = await client.invite.list(limit: 20);

// Delete a code
await client.invite.delete(inviteId: code.id);
```

## SwApi

`client.sw` gère les abonnements aux notifications push Service Worker. Tous les points d'accès nécessitent une authentification.

### Enregistrer

```dart
final registration = await client.sw.register(
  endpoint: 'https://push.example.com/subscribe/abc123',
  auth: 'auth-secret',
  publickey: 'vapid-public-key',
);
print(registration.state); // 'subscribed' or 'already-subscribed'
```

Passez `sendReadMessage: true` pour recevoir également les notifications de messages lus.

### Vérifier l'enregistrement

```dart
final sub = await client.sw.showRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
if (sub != null) {
  print(sub.sendReadMessage);
}
```

### Mettre à jour les paramètres

```dart
await client.sw.updateRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
  sendReadMessage: false,
);
```

### Se désabonner

```dart
await client.sw.unregister(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
```
