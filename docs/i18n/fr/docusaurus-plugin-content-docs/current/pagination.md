---
sidebar_position: 3
title: Pagination
---

# Pagination

Misskey utilise une pagination basée sur curseur. Les API qui renvoient des listes acceptent directement les paramètres de pagination et retournent un `List<T>` — il n'existe pas de type enveloppe. L'appelant passe les paramètres et vérifie la longueur du résultat retourné pour savoir s'il reste des pages.

## Paramètres de pagination

| Paramètre   | Type   | Description                                                    |
|-------------|--------|----------------------------------------------------------------|
| `sinceId`   | String | Renvoie les résultats **plus récents** que cet ID              |
| `untilId`   | String | Renvoie les résultats **plus anciens** que cet ID              |
| `sinceDate` | int    | Renvoie les résultats plus récents que ce timestamp Unix (ms)  |
| `untilDate` | int    | Renvoie les résultats plus anciens que ce timestamp Unix (ms)  |
| `limit`     | int    | Nombre maximum d'éléments à retourner (généralement 1–100)     |
| `offset`    | int    | Ignorer ce nombre d'éléments (API à pagination par offset uniquement) |

Toutes les API ne prennent pas en charge tous les paramètres. Consultez la référence API de chaque point de terminaison.

## Pagination basée sur curseur (par ID)

Utilisez `untilId` pour charger des pages plus anciennes et `sinceId` pour les pages plus récentes.

### Charger des pages plus anciennes

```dart
// Première page — notifications les plus récentes
List<MisskeyNotification> page = await client.notifications.list(limit: 20);

// Page suivante — plus ancienne que le dernier élément de la page précédente
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

### Charger des pages plus récentes

```dart
// Mémoriser l'ID le plus récent du dernier appel
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

## Pagination basée sur horodatage

Utilisez `sinceDate` et `untilDate` lorsque vous devez paginer par temps plutôt que par ID.

```dart
final now = DateTime.now().millisecondsSinceEpoch;
final oneDayAgo = now - const Duration(days: 1).inMilliseconds;

final notes = await client.notes.timelineLocal(
  limit: 30,
  sinceDate: oneDayAgo,
  untilDate: now,
);
```

## Pagination par offset

Certaines API prennent en charge `offset` plutôt que des paramètres de curseur. Cette approche est utile lorsque la navigation par curseur n'est pas disponible.

```dart
const pageSize = 50;
var offset = 0;

while (true) {
  final users = await client.users.list(
    limit: pageSize,
    offset: offset,
  );
  // traiter users...
  if (users.length < pageSize) break; // dernière page
  offset += users.length;
}
```

## Détecter la dernière page

Il n'existe pas de flag `hasNext`. Une page est la dernière lorsque le nombre d'éléments retournés est inférieur à `limit`.

```dart
const limit = 20;
final page = await client.blocking.list(limit: limit);
final isLastPage = page.length < limit;
```

## Parcourir toutes les pages

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

## API prenant en charge la pagination

La plupart des API renvoyant des listes prennent en charge `sinceId`/`untilId` et `limit` :

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
- `client.users.list` (par offset)
- `client.notes.search` (par offset)
