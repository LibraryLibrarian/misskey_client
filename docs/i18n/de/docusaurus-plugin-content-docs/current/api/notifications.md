---
sidebar_position: 3
title: Benachrichtigungen
---

# Benachrichtigungen

Die `client.notifications`-API verwaltet das Abrufen von Benachrichtigungen, das Massenmarkieren und das Erstellen benutzerdefinierter Benachrichtigungen.

## Benachrichtigungen abrufen

### Liste

```dart
final notifications = await client.notifications.list(limit: 20);

for (final n in notifications) {
  print('${n.type}: ${n.userId}');
}
```

Standardmaessig markiert das Abrufen Benachrichtigungen als gelesen. Uebergeben Sie `markAsRead: false`, um dies zu unterdruecken:

```dart
final notifications = await client.notifications.list(
  limit: 20,
  markAsRead: false,
);
```

### Gruppierte Benachrichtigungen

Reaktionen und Renotes auf derselben Notiz werden in einem einzelnen Eintrag zusammengefasst:

```dart
final grouped = await client.notifications.listGrouped(limit: 20);
```

### Nach Typ filtern

```dart
// Nur Erwaehungen und Reaktionen
final notifications = await client.notifications.list(
  includeTypes: ['mention', 'reaction'],
);

// Alles ausser Follows
final notifications = await client.notifications.list(
  excludeTypes: ['follow'],
);
```

Haeufige Benachrichtigungstypen: `follow`, `mention`, `reply`, `renote`, `quote`, `reaction`, `pollEnded`, `achievementEarned`, `app`.

### Seitennavigation

```dart
// Aeltere Benachrichtigungen
final older = await client.notifications.list(
  limit: 20,
  untilId: notifications.last.id,
);

// Neue Benachrichtigungen seit dem letzten Abruf
final newer = await client.notifications.list(
  limit: 20,
  sinceId: notifications.first.id,
);
```

`sinceDate` und `untilDate` akzeptieren Unix-Zeitstempel in Millisekunden als Alternative zur ID-basierten Seitennavigation.

## Als gelesen markieren

### Alle als gelesen markieren

```dart
await client.notifications.markAllAsRead();
```

### Alle Benachrichtigungen loeschen

Loescht alle Benachrichtigungen dauerhaft:

```dart
await client.notifications.flush();
```

## Benachrichtigungen erstellen

### App-Benachrichtigung

Sendet eine benutzerdefinierte Benachrichtigung von Ihrer App an den authentifizierten Benutzer. Erfordert die Berechtigung `write:notifications`.

```dart
await client.notifications.create(
  body: 'Your export is ready to download.',
  header: 'Export complete',
  icon: 'https://example.com/icon.png',
);
```

`header` entspricht standardmaessig dem Namen des Zugriffstokens und `icon` der Icon-URL des Tokens, wenn sie nicht angegeben werden.

### Testbenachrichtigung

Sendet eine Testbenachrichtigung (`type: test`) an den authentifizierten Benutzer. Nuetzlich, um zu pruefen, ob die Benachrichtigungsverarbeitung korrekt funktioniert.

```dart
await client.notifications.testNotification();
```

Sowohl `create` als auch `testNotification` haben ein Anfragelimit von 10 Anfragen pro Minute.
