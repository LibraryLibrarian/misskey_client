---
sidebar_position: 3
title: Notifications
---

# Notifications

L'API `client.notifications` gère la récupération des notifications, le marquage en masse et la création de notifications personnalisées.

## Récupération des notifications

### Liste

```dart
final notifications = await client.notifications.list(limit: 20);

for (final n in notifications) {
  print('${n.type}: ${n.userId}');
}
```

Par défaut, la récupération marque les notifications comme lues. Passez `markAsRead: false` pour désactiver ce comportement :

```dart
final notifications = await client.notifications.list(
  limit: 20,
  markAsRead: false,
);
```

### Notifications groupées

Les réactions et renotes sur une même note sont fusionnées en une seule entrée :

```dart
final grouped = await client.notifications.listGrouped(limit: 20);
```

### Filtrage par type

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

Types de notifications courants : `follow`, `mention`, `reply`, `renote`, `quote`, `reaction`, `pollEnded`, `achievementEarned`, `app`.

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

`sinceDate` et `untilDate` acceptent des horodatages Unix en millisecondes comme alternative à la pagination par identifiant.

## Marquage comme lu

### Tout marquer comme lu

```dart
await client.notifications.markAllAsRead();
```

### Vider toutes les notifications

Supprime définitivement toutes les notifications :

```dart
await client.notifications.flush();
```

## Création de notifications

### Notification d'application

Envoie une notification personnalisée depuis votre application à l'utilisateur authentifié. Nécessite la permission `write:notifications`.

```dart
await client.notifications.create(
  body: 'Your export is ready to download.',
  header: 'Export complete',
  icon: 'https://example.com/icon.png',
);
```

`header` utilise par défaut le nom du jeton d'accès et `icon` utilise par défaut l'URL d'icône du jeton s'ils sont omis.

### Notification de test

Envoie une notification de test (`type: test`) à l'utilisateur authentifié. Utile pour vérifier que la gestion des notifications fonctionne correctement.

```dart
await client.notifications.testNotification();
```

`create` et `testNotification` ont tous deux une limite de débit de 10 requêtes par minute.
