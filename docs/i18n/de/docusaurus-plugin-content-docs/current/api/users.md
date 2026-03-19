---
sidebar_position: 2
title: Benutzer
---

# Benutzer

Die `client.users`-API bietet Operationen zum Nachschlagen von Benutzern, Verwalten von Folgebeziehungen sowie Umgang mit Blockierungen und Stummschaltungen. Profilverwaltung fuer den authentifizierten Benutzer erfolgt ueber `client.account`.

## Benutzer abrufen

### Nach Benutzer-ID

```dart
final user = await client.users.showOneByUserId('9abc');
print(user.name);     // Anzeigename
print(user.username); // Benutzername (ohne @)
print(user.host);     // null fuer lokale Benutzer, Hostname fuer entfernte
```

### Nach Benutzername

```dart
// Lokaler Benutzer
final user = await client.users.showOneByUsername('alice');

// Entfernter Benutzer
final user = await client.users.showOneByUsername('alice', host: 'other.example.com');
```

### Mehrere Benutzer gleichzeitig

```dart
final users = await client.users.showMany(
  userIds: ['9abc', '9def', '9ghi'],
);
```

### Benutzer auflisten (Verzeichnis)

```dart
// Lokale Benutzer, sortiert nach Followeranzahl
final users = await client.users.list(
  limit: 20,
  sort: '+follower',
  origin: 'local',
);
```

Verfuegbare `sort`-Werte: `+follower`, `-follower`, `+createdAt`, `-createdAt`, `+updatedAt`, `-updatedAt`.
Verfuegbare `origin`-Werte: `local`, `remote`, `combined`.

## Follower und Folgende

```dart
// Follower eines Benutzers (nach ID)
final followers = await client.users.followersByUserId(userId, limit: 20);

// Follower eines Benutzers (nach Benutzername)
final followers = await client.users.followersByUsername('alice', limit: 20);

// Konten, denen ein Benutzer folgt
final following = await client.users.followingByUserId(userId, limit: 20);
```

Seitennavigation mit `sinceId` / `untilId` / `sinceDate` / `untilDate`.

## Notizen eines Benutzers

```dart
final notes = await client.users.notes(
  userId: userId,
  limit: 20,
  withReplies: false,
  withRenotes: true,
);
```

`withReplies` und `withFiles` koennen nicht gleichzeitig `true` sein (Servereinschraenkung).

## Folgeoperationen

### Einem Benutzer folgen

```dart
final user = await client.following.create(userId: userId);
```

Wenn der Zielbenutzer eine Folgebestaetigung erfordert, wird stattdessen eine Anfrage gesendet.

### Entfolgen

```dart
await client.following.delete(userId: userId);
```

### Folgeeinstellungen aktualisieren

```dart
// Benachrichtigungsstufe fuer ein bestimmtes Follow aendern
await client.following.update(
  userId: userId,
  notify: 'normal', // 'normal' oder 'none'
  withReplies: true,
);
```

### Einen Follower entfernen

```dart
// Entfernt jemanden, der Ihnen folgt, zwangsweise
await client.following.invalidate(userId: userId);
```

### Folgeanfragen

```dart
// Ausstehende eingehende Anfragen auflisten
final requests = await client.following.requests.listReceived();

// Annehmen oder ablehnen
await client.following.requests.accept(userId: userId);
await client.following.requests.reject(userId: userId);

// Eine ausgehende Anfrage, die Sie gesendet haben, abbrechen
await client.following.requests.cancel(userId: userId);
```

## Blockieren

```dart
// Einen Benutzer blockieren (entfernt die gegenseitige Folgebeziehung)
await client.blocking.create(userId: userId);

// Blockierung aufheben
await client.blocking.delete(userId: userId);

// Eigene blockierte Benutzer auflisten
final blocked = await client.blocking.list(limit: 20);
```

## Stummschalten

```dart
// Einen Benutzer stummschalten
await client.mute.create(userId: userId);

// Stummschalten mit Ablaufzeit (Unix-Zeitstempel in Millisekunden)
await client.mute.create(userId: userId, expiresAt: expiresAt);

// Stummschaltung aufheben
await client.mute.delete(userId: userId);

// Eigene stummgeschaltete Benutzer auflisten
final muted = await client.mute.list(limit: 20);
```

## Kontoverwaltung

Profiloperationen fuer den authentifizierten Benutzer befinden sich unter `client.account`.

### Eigenes Profil abrufen

```dart
final me = await client.account.i();
print(me.name);
print(me.description);
```

### Profil aktualisieren

```dart
final updated = await client.account.update(
  name: 'Alice',
  description: 'Hello from Misskey!',
  lang: 'en',
);
```

Es werden nur die angegebenen Felder geaendert; ausgelassene Felder bleiben unveraendert.

## Benutzersuche

```dart
final results = await client.users.search(
  query: 'alice',
  limit: 20,
  origin: 'combined',
);
```

## Benutzerlisten

Benutzerlisten sind ueber `client.users.lists` zugaenglich:

```dart
// Eine Liste erstellen
final list = await client.users.lists.create(name: 'Friends');

// Einen Benutzer zur Liste hinzufuegen
await client.users.lists.push(listId: list.id, userId: userId);

// Einen Benutzer aus der Liste entfernen
await client.users.lists.pull(listId: list.id, userId: userId);

// Eigene Listen abrufen
final lists = await client.users.lists.list();

// Mitglieder einer Liste abrufen
final members = await client.users.lists.getMemberships(listId: list.id);
```
