---
sidebar_position: 8
title: "Server & Foederation"
---

# Server & Foederation

Diese Seite behandelt APIs zur Abfrage von Server-Metadaten, Foederation, Rollen, Diagrammen und ActivityPub.

## MetaApi

`client.meta` stellt Server-Metadaten und Funktionserkennung bereit.

### Metadaten abrufen

```dart
final meta = await client.meta.getMeta();
print(meta.name);        // Servername
print(meta.description); // Serverbeschreibung
```

Ergebnisse werden nach dem ersten Aufruf im Speicher zwischengespeichert. Verwenden Sie `refresh: true`, um den Cache zu umgehen:

```dart
final fresh = await client.meta.getMeta(refresh: true);
```

Uebergeben Sie `detail: false` fuer eine kompakte Antwort (entspricht `MetaLite`):

```dart
final lite = await client.meta.getMeta(detail: false);
```

### Funktionserkennung

Rufen Sie `getMeta()` mindestens einmal auf, bevor Sie `supports()` verwenden. Die Methode prueft einen Schluessel in der Rohantwort mithilfe eines Punktnotationspfads:

```dart
await client.meta.getMeta();

if (client.meta.supports('features.miauth')) {
  // MiAuth ist auf diesem Server verfuegbar
}

if (client.meta.supports('policies.canInvite')) {
  // Einladefunktion ist aktiviert
}
```

### Serverinformationen, Statistiken und Ping

```dart
// Maschineninformationen: CPU, Arbeitsspeicher, Festplatte
final info = await client.meta.getServerInfo();
print(info.cpu.model);
print(info.mem.total);

// Instanzstatistiken: Benutzeranzahl, Notizanzahl usw.
final stats = await client.meta.getStats();
print(stats.usersCount);
print(stats.notesCount);

// Ping — gibt die Serverzeit als Unix-Zeitstempel (ms) zurueck
final timestamp = await client.meta.ping();
```

### Endpunkte

```dart
// Alle Endpunktnamen
final endpoints = await client.meta.getEndpoints();

// Parameter fuer einen bestimmten Endpunkt
final info = await client.meta.getEndpoint(endpoint: 'notes/create');
if (info != null) {
  for (final param in info.params) {
    print('${param.name}: ${param.type}');
  }
}
```

### Benutzerdefinierte Emojis

```dart
// Vollstaendige Emoji-Liste (sortiert nach Kategorie und Name)
final emojis = await client.meta.getEmojis();

// Details zu einem einzelnen Emoji nach Kurzkuerzel
final emoji = await client.meta.getEmoji(name: 'blobcat');
print(emoji.url);
```

### Weitere Serverabfragen

```dart
// Von Administratoren angepinnte Benutzer
final pinned = await client.meta.getPinnedUsers();

// Anzahl der in den letzten Minuten aktiven Benutzer (gecacht 60 s)
final count = await client.meta.getOnlineUsersCount();

// Verfuegbare Avatar-Dekorationen
final decorations = await client.meta.getAvatarDecorations();

// Benutzerbindungsdaten — bis zu 30 Tagesaufzeichnungen (gecacht 3600 s)
final retention = await client.meta.getRetention();
for (final record in retention) {
  print('${record.createdAt}: ${record.users} Registrierungen');
}
```

## FederationApi

`client.federation` stellt Informationen ueber Instanzen bereit, mit denen der Server foederiert.

### Instanzen auflisten

```dart
// Alle bekannten foederierten Instanzen
final instances = await client.federation.instances(limit: 30);

// Nach Statusflags filtern
final blocked = await client.federation.instances(blocked: true, limit: 20);
final suspended = await client.federation.instances(suspended: true);
final active = await client.federation.instances(federating: true, limit: 50);

// Nach Followeranzahl absteigend sortieren
final top = await client.federation.instances(
  sort: '-followers',
  limit: 10,
);
```

Verfuegbare `sort`-Werte: `+pubSub` / `-pubSub`, `+notes` / `-notes`,
`+users` / `-users`, `+following` / `-following`, `+followers` / `-followers`,
`+firstRetrievedAt` / `-firstRetrievedAt`, `+latestRequestReceivedAt` / `-latestRequestReceivedAt`.

### Instanzdetails

```dart
final instance = await client.federation.showInstance(host: 'mastodon.social');
if (instance != null) {
  print(instance.usersCount);
  print(instance.notesCount);
}
```

### Follower und Folgende fuer einen Host

```dart
// Beziehungen, die von einer entfernten Instanz gefolgt werden
final followers = await client.federation.followers(
  host: 'mastodon.social',
  limit: 20,
);

final following = await client.federation.following(
  host: 'mastodon.social',
  limit: 20,
);

// Von einer entfernten Instanz bekannte Benutzer
final users = await client.federation.users(
  host: 'mastodon.social',
  limit: 20,
);
```

### Foederationsstatistiken

```dart
// Top-Instanzen nach Follower-/Folgende-Anzahl
final stats = await client.federation.stats(limit: 10);
print(stats.topSubInstances.first.host);
```

### Einen entfernten Benutzer aktualisieren

```dart
// ActivityPub-Profil fuer einen entfernten Benutzer erneut abrufen (Authentifizierung erforderlich)
await client.federation.updateRemoteUser(userId: remoteUserId);
```

## RolesApi

`client.roles` stellt oeffentliche Rolleninformationen bereit.

```dart
// Alle oeffentlichen, durchsuchbaren Rollen auflisten (Authentifizierung erforderlich)
final roles = await client.roles.list();

// Details zu einer bestimmten Rolle (keine Authentifizierung erforderlich)
final role = await client.roles.show(roleId: 'roleId123');
print(role.name);
print(role.color);

// Notizen von Benutzern, die einer Rolle angehoeren (Authentifizierung erforderlich)
final notes = await client.roles.notes(roleId: role.id, limit: 20);

// Benutzer, die einer Rolle angehoeren (keine Authentifizierung erforderlich)
final members = await client.roles.users(roleId: role.id, limit: 20);
```

Alle Listen-Methoden akzeptieren `sinceId`, `untilId`, `sinceDate` und `untilDate` fuer die Seitennavigation.

## ChartsApi

`client.charts` liefert Zeitreihendaten. Alle Methoden akzeptieren `span` (`'day'` oder `'hour'`),
`limit` (1-500, Standard 30) und `offset`.

```dart
// Aktive Benutzer der letzten 30 Tage
final activeUsers = await client.charts.getActiveUsers(span: 'day');

// Notizanzahl (lokal und entfernt)
final notes = await client.charts.getNotes(span: 'day', limit: 14);

// Benutzeranzahl (lokal und entfernt)
final users = await client.charts.getUsers(span: 'hour', limit: 24);

// Foederationsaktivitaet
final fed = await client.charts.getFederation(span: 'day');

// ActivityPub-Anfrageresultate
final ap = await client.charts.getApRequest(span: 'hour', limit: 48);

// Diagramm pro Instanz
final inst = await client.charts.getInstance(
  host: 'mastodon.social',
  span: 'day',
  limit: 7,
);

// Diagramme pro Benutzer
final userNotes = await client.charts.getUserNotes(
  userId: userId,
  span: 'day',
  limit: 30,
);
```

Jede Antwort ist eine `Map<String, dynamic>`, wobei Blattwerte `List<num>`-Zeitreihen-Arrays sind.

## ApApi

`client.ap` loest ActivityPub-Objekte von entfernten Servern auf (Authentifizierung erforderlich, Anfragelimit: 30/Stunde).

```dart
// Einen Benutzer oder eine Notiz von einer AP-URI aufloesen
final result = await client.ap.show(
  uri: 'https://mastodon.social/users/alice',
);
if (result is ApShowUser) {
  print(result.user.username);
} else if (result is ApShowNote) {
  print(result.note.text);
}

// Das rohe AP-Objekt abrufen (nur fuer Administratoren)
final raw = await client.ap.get(
  uri: 'https://mastodon.social/users/alice',
);
print(raw['type']); // z. B. 'Person'
```
