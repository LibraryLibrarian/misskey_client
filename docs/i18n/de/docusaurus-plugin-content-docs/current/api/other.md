---
sidebar_position: 9
title: "Weitere APIs"
---

# Weitere APIs

Diese Seite behandelt Chat, Ankuendigungen, Hashtags, Einladungscodes und Service-Worker-Push-Benachrichtigungen.

## ChatApi

`client.chat` bietet Direktnachrichten und Gruppenraum-Messaging. Alle Chat-Endpunkte erfordern Authentifizierung.

### Verlauf und Lesestatus

```dart
// Aktueller DM-Gespraechsverlauf
final dmHistory = await client.chat.history(limit: 10);

// Aktueller Raumverlauf
final roomHistory = await client.chat.history(limit: 10, room: true);

// Alle Nachrichten als gelesen markieren
await client.chat.readAll();
```

### Direktnachrichten

```dart
// Eine Nachricht an einen Benutzer senden
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Hello!',
);

// Eine Drive-Datei anhaengen
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Here is the file.',
  fileId: driveFileId,
);

// Eine Nachricht loeschen
await client.chat.messages.delete(messageId: msg.id);

// Auf eine Nachricht reagieren
await client.chat.messages.react(messageId: msg.id, reaction: ':heart:');

// Eine Reaktion entfernen
await client.chat.messages.unreact(messageId: msg.id, reaction: ':heart:');
```

### Nachrichtenverlaeufe

```dart
// Direktnachrichtenverlauf mit einem Benutzer (cursorbasierte Seitennavigation)
final messages = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
);

// Aeltere Nachrichten abrufen
final older = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
  untilId: messages.last.id,
);

// Raumverlauf
final roomMessages = await client.chat.messages.roomTimeline(
  roomId: roomId,
  limit: 20,
);
```

### Nachrichtensuche

```dart
final results = await client.chat.messages.search(
  query: 'meeting',
  limit: 20,
  userId: targetUserId, // optional: auf ein Gespraech beschraenken
);
```

### Chat-Raeume

```dart
// Einen Raum erstellen
final room = await client.chat.rooms.create(
  name: 'Project Alpha',
  description: 'Coordination channel',
);

// Raumdetails aktualisieren
await client.chat.rooms.update(
  roomId: room.id,
  name: 'Project Alpha — Active',
);

// Einen Raum loeschen
await client.chat.rooms.delete(roomId: room.id);

// Beitreten und verlassen
await client.chat.rooms.join(roomId: room.id);
await client.chat.rooms.leave(roomId: room.id);

// Raum stummschalten / Stummschaltung aufheben
await client.chat.rooms.setMute(roomId: room.id, mute: true);

// Mitgliederliste
final members = await client.chat.rooms.members(roomId: room.id, limit: 30);

// Eigene Raeume
final owned = await client.chat.rooms.owned(limit: 20);

// Beigetretene Raeume
final joined = await client.chat.rooms.joining(limit: 20);
```

### Raumeinladungen

```dart
// Einen Benutzer in einen Raum einladen
await client.chat.rooms.invitationsCreate(
  roomId: room.id,
  userId: targetUserId,
);

// Erhaltene Einladungen auflisten
final inbox = await client.chat.rooms.invitationsInbox(limit: 20);

// Gesendete Einladungen fuer einen Raum auflisten
final outbox = await client.chat.rooms.invitationsOutbox(
  roomId: room.id,
  limit: 20,
);

// Eine erhaltene Einladung ablehnen
await client.chat.rooms.invitationsIgnore(roomId: room.id);
```

## AnnouncementsApi

`client.announcements` ruft Serverankuendigungen ab. Authentifizierung ist optional;
bei Authentifizierung enthaelt jedes Element ein `isRead`-Flag.

```dart
// Aktive Ankuendigungen (Standard)
final active = await client.announcements.list(limit: 10);

// Inaktive Ankuendigungen ebenfalls einschliessen
final all = await client.announcements.list(isActive: false, limit: 20);

// Details zu einer einzelnen Ankuendigung
final ann = await client.announcements.show(announcementId: ann.id);
print(ann.title);
print(ann.text);
```

Seitennavigation mit `sinceId`, `untilId`, `sinceDate` und `untilDate`.

### Als gelesen markieren

Eine Ankuendigung ueber `client.account` als gelesen markieren:

```dart
await client.account.readAnnouncement(announcementId: ann.id);
```

## HashtagsApi

`client.hashtags` stellt Hashtag-Suche und Trendingdaten bereit. Keine Authentifizierung erforderlich.

### Auflisten und suchen

```dart
// Hashtags sortiert nach Anzahl der Benutzer, die sie gepostet haben
final tags = await client.hashtags.list(
  sort: '+mentionedUsers',
  limit: 20,
);

// Praefixsuche — gibt eine Liste von Tag-Name-Zeichenfolgen zurueck
final suggestions = await client.hashtags.search(
  query: 'miss',
  limit: 10,
);
```

Verfuegbare `sort`-Werte: `+mentionedUsers` / `-mentionedUsers`,
`+mentionedLocalUsers` / `-mentionedLocalUsers`,
`+mentionedRemoteUsers` / `-mentionedRemoteUsers`,
`+attachedUsers` / `-attachedUsers`,
`+attachedLocalUsers` / `-attachedLocalUsers`,
`+attachedRemoteUsers` / `-attachedRemoteUsers`.

### Tag-Details und Trends

```dart
// Detaillierte Statistiken fuer einen Tag
final tag = await client.hashtags.show(tag: 'misskey');
print(tag.mentionedUsersCount);

// Trending-Tags (bis zu 10, gecacht 60 s)
final trending = await client.hashtags.trend();
for (final t in trending) {
  print('${t.tag}: ${t.chart}');
}
```

### Benutzer fuer einen Tag

```dart
final users = await client.hashtags.users(
  tag: 'misskey',
  sort: '+follower',
  limit: 20,
  origin: 'local', // 'local', 'remote' oder 'combined'
  state: 'alive',  // 'all' oder 'alive'
);
```

## InviteApi

`client.invite` verwaltet Einladungscodes auf einladungsbasierten Servern. Alle Endpunkte erfordern
Authentifizierung und die Rollenrichtlinie `canInvite`.

```dart
// Einen Einladungscode erstellen
final code = await client.invite.create();
print(code.code);

// Verbleibendes Kontingent pruefen (null bedeutet unbegrenzt)
final remaining = await client.invite.limit();
if (remaining != null) {
  print('$remaining Einladung(en) verbleibend');
}

// Eigene ausgestellte Codes auflisten
final codes = await client.invite.list(limit: 20);

// Einen Code loeschen
await client.invite.delete(inviteId: code.id);
```

## SwApi

`client.sw` verwaltet Service-Worker-Push-Benachrichtigungsabonnements. Alle Endpunkte erfordern Authentifizierung.

### Registrieren

```dart
final registration = await client.sw.register(
  endpoint: 'https://push.example.com/subscribe/abc123',
  auth: 'auth-secret',
  publickey: 'vapid-public-key',
);
print(registration.state); // 'subscribed' oder 'already-subscribed'
```

Uebergeben Sie `sendReadMessage: true`, um auch Lesestatus-Benachrichtigungen zu erhalten.

### Registrierung pruefen

```dart
final sub = await client.sw.showRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
if (sub != null) {
  print(sub.sendReadMessage);
}
```

### Einstellungen aktualisieren

```dart
await client.sw.updateRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
  sendReadMessage: false,
);
```

### Registrierung aufheben

```dart
await client.sw.unregister(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
```
