---
sidebar_position: 3
title: Paginierung
---

# Paginierung

Misskey verwendet cursorbasierte Paginierung. APIs, die Listen zurückgeben, nehmen die Paginierungsparameter direkt entgegen und liefern `List<T>` — es gibt keinen Wrapper-Typ. Der Aufrufer übergibt die Parameter und prüft die Länge des zurückgegebenen Ergebnisses, um festzustellen, ob weitere Seiten vorhanden sind.

## Paginierungsparameter

| Parameter   | Typ    | Beschreibung                                              |
|-------------|--------|----------------------------------------------------------|
| `sinceId`   | String | Ergebnisse **neuer** als diese Notiz-/Objekt-ID zurückgeben |
| `untilId`   | String | Ergebnisse **aelter** als diese Notiz-/Objekt-ID zurückgeben |
| `sinceDate` | int    | Ergebnisse neuer als dieser Unix-Zeitstempel (ms) zurückgeben |
| `untilDate` | int    | Ergebnisse aelter als dieser Unix-Zeitstempel (ms) zurückgeben |
| `limit`     | int    | Maximale Anzahl zurückzugebender Eintraege (typischerweise 1–100) |
| `offset`    | int    | Diese Anzahl an Eintraegen ueberspringen (nur offsetbasierte APIs) |

Nicht jede API unterstuetzt alle Parameter. Bitte die API-Referenz des jeweiligen Endpunkts beachten.

## Cursorbasierte Paginierung (nach ID)

Mit `untilId` werden aeltere Seiten geladen, mit `sinceId` neuere.

### Aeltere Seiten laden

```dart
// Erste Seite — neueste Benachrichtigungen
List<MisskeyNotification> page = await client.notifications.list(limit: 20);

// Naechste Seite — aelter als der letzte Eintrag der vorherigen Seite
while (page.isNotEmpty) {
  final oldestId = page.last.id;
  final next = await client.notifications.list(
    limit: 20,
    untilId: oldestId,
  );
  if (next.isEmpty) break;
  page = next;
}
```

### Neuere Seiten laden

```dart
// Die neueste ID des letzten Abrufs speichern
String? latestId;

Future<List<MisskeyNote>> pollNewNotes() async {
  final notes = await client.notes.timelineHome(
    limit: 20,
    sinceId: latestId,
  );
  if (notes.isNotEmpty) {
    latestId = notes.first.id;
  }
  return notes;
}
```

## Zeitstempelbasierte Paginierung

Wenn nach Zeit statt nach ID paginiert werden soll, werden `sinceDate` und `untilDate` verwendet.

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final oneDayAgo = now - const Duration(days: 1).inMilliseconds;

final notes = await client.notes.timelineLocal(
  limit: 30,
  sinceDate: oneDayAgo,
  untilDate: now,
);
```

## Offsetbasierte Paginierung

Einige APIs unterstuetzen `offset` anstelle von Cursor-Parametern. Dies wird verwendet, wenn eine Cursor-Navigation nicht verfuegbar ist.

```dart
const pageSize = 50;
var offset = 0;

while (true) {
  final users = await client.users.list(
    limit: pageSize,
    offset: offset,
  );
  // users verarbeiten...
  if (users.length < pageSize) break; // letzte Seite
  offset += users.length;
}
```

## Die letzte Seite erkennen

Es gibt kein `hasNext`-Flag. Eine Seite ist die letzte, wenn die Anzahl der zurueckgegebenen Eintraege kleiner als `limit` ist.

```dart
const limit = 20;
final page = await client.blocking.list(limit: limit);
final isLastPage = page.length < limit;
```

## Alle Seiten durchlaufen

```dart
Future<List<MisskeyNote>> fetchAllFavorites() async {
  const limit = 100;
  final all = <MisskeyNote>[];
  String? untilId;

  while (true) {
    final page = await client.account.favorites(
      limit: limit,
      untilId: untilId,
    );
    all.addAll(page);
    if (page.length < limit) break;
    untilId = page.last.id;
  }

  return all;
}
```

## APIs mit Paginierungsunterstuetzung

Die meisten listenrueckgebenden APIs unterstuetzen `sinceId`/`untilId` und `limit`:

- `client.notes.timelineHome` / `timelineLocal` / `timelineGlobal`
- `client.notes.list`
- `client.notifications.list`
- `client.account.favorites`
- `client.blocking.list`
- `client.mute.list`
- `client.clips.list`
- `client.following.requests.list`
- `client.antennas.notes`
- `client.channels.timeline`
- `client.users.list` (offsetbasiert)
- `client.notes.search` (offsetbasiert)
