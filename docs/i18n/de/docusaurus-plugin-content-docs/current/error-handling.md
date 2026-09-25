---
sidebar_position: 4
title: Fehlerbehandlung
---

# Fehlerbehandlung

Diese Bibliothek bildet Misskey-API-Fehler auf eine Sealed-Class-Hierarchie ab, die bei `MisskeyClientException` verwurzelt ist.

## Ausnahmehierarchie

```
MisskeyClientException (sealed)
├── MisskeyApiException              // Allgemeine HTTP-Antwortfehler
│   ├── MisskeyUnauthorizedException // 401 - Ungueltiges oder fehlendes Token
│   ├── MisskeyForbiddenException    // 403 - Operation nicht erlaubt
│   ├── MisskeyNotFoundException     // 404 - Ressource nicht gefunden
│   ├── MisskeyRateLimitException    // 429 - Anfragelimit erreicht
│   │   └── retryAfter               //   Vom Server empfohlene Wartezeit
│   ├── MisskeyValidationException   // 422 - Ungueltiger Anfrage-Body
│   └── MisskeyServerException       // 5xx - Serverseitiger Fehler
└── MisskeyNetworkException          // Timeout, Verbindung abgelehnt usw.
```

`MisskeyApiException` enthaelt ausserdem Misskey-spezifische Felder:

- `code` — Misskey-Fehlercodezeichenfolge (z. B. `AUTHENTICATION_FAILED`, `NO_SUCH_NOTE`)
- `errorId` — UUID zur Identifizierung des Misskey-Fehlertyps
- `endpoint` — Der API-Pfad, bei dem der Fehler aufgetreten ist

## Ausnahmen außerhalb der Hierarchie {#exceptions-outside-the-hierarchy}

`MisskeyClientException` deckt API- und Transportfehler ab. Einige Helfer-APIs, etwa die [Drive-Helfer](./advanced/drive-helpers.md), können außerdem folgende Ausnahmen auslösen:

- `ArgumentError` — ungültige Argumente (zum Beispiel ein nicht positives `concurrency` oder ein außerhalb des gültigen Bereichs liegendes `pageSize`). Die Ausnahme wird ausgelöst, bevor eine Anfrage gesendet wird.
- `StateError` — nicht erfüllte Voraussetzungen, etwa der Aufruf von `client.drive.uploadFromUrlAndWait()` ohne ein verbundenes `main`-Streaming-Abonnement.
- `DriveFolderAmbiguousException` — wird von `resolvePath()` und `getOrCreate()` ausgelöst, wenn mehrere Unterordner denselben Namen haben. Die Ausnahme gehört nicht zur versiegelten Hierarchie und wird daher nicht von `on MisskeyClientException` abgefangen.

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}"');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

Sobald Batch-Helfer, die viele Elemente ändern (zum Beispiel `createMany()`, `moveBulkAll()`, `dissolveFolder()` und `deleteFolderRecursive()`), mit Änderungen begonnen haben, werden Fehler einzelner Vorgänge in einem `MisskeyBatchResult` (oder einem Ergebnis, das ein solches enthält) als Fehlschlag mit Fehlerursache oder als Überspringen mit Begründung erfasst, statt ausgelöst zu werden. Fehler vor jeder Änderung, etwa eine fehlgeschlagene Prüfung des Zielordners, werden weiterhin ausgelöst. Ein Fehler, den ein `onProgress`-Callback beim Melden eines abgeschlossenen Elements auslöst, wird erneut ausgelöst, nachdem laufende Vorgänge beendet sind; abgeschlossene Änderungen werden nicht rückgängig gemacht.

## Grundlegende Abfangmuster

### Alle Fehler abfangen

```dart
try {
  final note = await client.notes.show(noteId: '9xyz');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

### Nach HTTP-Status behandeln

```dart
try {
  final note = await client.notes.show(noteId: noteId);
} on MisskeyNotFoundException {
  print('Note not found');
} on MisskeyUnauthorizedException {
  print('Token is invalid. Please re-authenticate');
} on MisskeyForbiddenException {
  print('You do not have permission to view this note');
} on MisskeyRateLimitException catch (e) {
  final wait = e.retryAfter ?? const Duration(seconds: 60);
  print('Rate limited. Retry after $wait');
} on MisskeyApiException catch (e) {
  print('API error (${e.statusCode}): ${e.message} [${e.code}]');
} on MisskeyNetworkException {
  print('Check your network connection');
}
```

### Den Misskey-Fehlercode pruefen

```dart
try {
  await client.following.create(userId: userId);
} on MisskeyApiException catch (e) {
  switch (e.code) {
    case 'ALREADY_FOLLOWING':
      print('Already following this user');
    case 'BLOCKING':
      print('Cannot follow a user you have blocked');
    default:
      rethrow;
  }
}
```

## Anfragelimits behandeln

```dart
Future<T> withRetry<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on MisskeyRateLimitException catch (e) {
    final wait = e.retryAfter ?? const Duration(seconds: 60);
    await Future<void>.delayed(wait);
    return action();
  }
}

// Verwendung
final timeline = await withRetry(
  () => client.notes.timelineHome(limit: 20),
);
```

## Netzwerkfehler behandeln

`MisskeyNetworkException` umschliesst Verbindungsfehler wie Timeouts und DNS-Fehler. Das `cause`-Feld enthaelt die zugrundeliegende Ausnahme:

```dart
try {
  final notes = await client.notes.timelineLocal();
} on MisskeyNetworkException catch (e) {
  print('Network error at ${e.endpoint}: ${e.cause}');
}
```

Der Client wiederholt idempotente Anfragen automatisch bis zu `MisskeyClientConfig.maxRetries` Mal (Standard: 3), bevor er eine Ausnahme wirft.
