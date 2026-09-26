---
sidebar_position: 3
title: Drive-Helfer
---

# Drive-Helfer

Die Drive-Helfer sind höherstufige Hilfsmethoden, die mehrere Drive-API-Aufrufe zu einem Vorgang zusammenfassen: alle Seiten auflisten, den Ordnerbaum durchlaufen, viele Dateien verschieben oder hochladen und einen Ordner samt Inhalt löschen. Sie befinden sich auf denselben Facades wie die einfachen Endpunkte (`client.drive`, `client.drive.files` und `client.drive.folders`). Für Endpunkte mit nur einer Anfrage siehe [Drive-Upload](./drive-upload.md).

Da jeder Helfer mehrere Anfragen sendet, ist keiner davon atomar. Änderungen auf dem Server während der Ausführung eines Helfers (zum Beispiel durch einen anderen Client) können sich im Ergebnis widerspiegeln.

## Alles auflisten {#listing-everything}

Drei Helfer blättern eine Liste automatisch durch und geben einen `Stream` zurück:

| Methode | Auflistung | Filter |
|---|---|---|
| `client.drive.files.listAll()` | Dateien in einem Ordner (Stammordner, wenn `folderId` fehlt) | `folderId`, `type` |
| `client.drive.folders.listAll()` | Ordner in einem übergeordneten Ordner (Stammordner, wenn `folderId` fehlt) | `folderId` |
| `client.drive.streamAll()` | Dateien in allen Ordnern | `type` |

```dart
// Alle Bilder in einem Ordner
await for (final file in client.drive.files.listAll(
  folderId: myFolderId,
  type: 'image/*',
)) {
  print('${file.name} (${file.size} Bytes)');
}

// Bis zu 500 Dateien aus dem gesamten Drive
final recent = await client.drive.streamAll(maxItems: 500).toList();
```

### Nur ID-Reihenfolge, neueste zuerst {#newest-first-id-order-only}

Die Ergebnisse werden immer in absteigender ID-Reihenfolge, also mit den neuesten zuerst, zurückgegeben. `listAll()` akzeptiert kein `sort`: Der Server wendet den `untilId`-Cursor als ID-Filter an, auch wenn nach Name oder Größe sortiert wird; dadurch würden Einträge zwischen Seiten fehlen oder doppelt auftreten. Für eine andere Reihenfolge sammeln Sie die Ergebnisse und sortieren Sie lokal:

```dart
final files = await client.drive.files.listAll(folderId: myFolderId).toList();
files.sort((a, b) => b.size.compareTo(a.size)); // Größte zuerst
```

### Seitengröße und Grenzen {#page-size-and-limits}

- `pageSize` ist die Anzahl der pro Aufruf angeforderten Einträge (1–100, Standardwert 100).
- `maxItems` beendet den Stream nach dieser Anzahl von Einträgen. Bei `0` wird keine Anfrage gesendet.

Ungültige Werte lösen synchron beim Methodenaufruf einen `ArgumentError` aus.

### Stream-Verhalten {#stream-behavior}

Jeder Aufruf gibt einen kalten Stream zurück, der nur einmal abonniert werden kann. Anfragen werden erst beim Abonnement gesendet. Wird das Abonnement abgebrochen (oder eine `await for`-Schleife vorzeitig verlassen), werden keine weiteren Seiten angefordert. API-Fehler werden nach den bereits ausgegebenen Einträgen als Stream-Fehler gemeldet.

Die Auflistung ist keine Momentaufnahme. Während der Paginierung hinzugefügte, verschobene oder gelöschte Dateien können fehlen oder enthalten sein.

### MIME-Typ-Filter {#mime-type-filter}

`type` akzeptiert nur Buchstaben, `/`, `-` und `*`. Der Server weist Werte mit Ziffern zurück, daher schlägt `video/mp4` fehl. Verwenden Sie einen Platzhalter wie `video/*` und filtern Sie lokal, wenn Sie einen exakten Typ benötigen:

```dart
final mp4s = await client.drive
    .streamAll(type: 'video/*')
    .where((file) => file.type == 'video/mp4')
    .toList();
```

## Batch-Ergebnisse und Abbruch {#batch-results-and-cancellation}

Sobald Hilfsmethoden, die viele Elemente ändern, mit den Änderungen begonnen haben, wird der Fehler eines einzelnen Vorgangs nicht ausgelöst, sondern in einem `MisskeyBatchResult<I, T>` mit einem Ergebnis pro Eingabe in Eingabereihenfolge erfasst. Ein Fehler, den ein eigener `onProgress`-Callback beim Melden eines abgeschlossenen Elements auslöst, ist davon zu unterscheiden: Neue Arbeit wird angehalten, und der Fehler wird erneut ausgelöst, nachdem laufende Anfragen abgeschlossen sind. Bereits abgeschlossene Änderungen werden nicht rückgängig gemacht.

| Typ | Bedeutung | Felder |
|---|---|---|
| `MisskeyBatchSuccess<I, T>` | Der Vorgang war erfolgreich | `input`, `index`, `value` |
| `MisskeyBatchFailure<I, T>` | Der Vorgang hat eine Ausnahme ausgelöst | `input`, `index`, `error`, `stackTrace` |
| `MisskeyBatchSkipped<I, T>` | Der Vorgang wurde nicht gestartet | `input`, `index`, `reason`, `cause` |

`MisskeyBatchSkipReason` gibt an, warum ein Element übersprungen wurde:

| Wert | Bedeutung |
|---|---|
| `cancelled` | Der Abbruch wurde angefordert |
| `rateLimited` | Der Server hat eine Anfrage rate-limitiert (HTTP 429) in `createMany()`, `dissolveFolder()` oder `deleteFolderRecursive()` |
| `stoppedAfterError` | Ein vorheriger Fehler hat den Batch angehalten (`createMany()` mit `stopOnError` oder ein fehlgeschlagener Block in `moveBulkAll()`, einschließlich HTTP 429) |
| `dependencyFailed` | Ein erforderlicher Vorgang war nicht erfolgreich (zum Beispiel das Auflösen eines Ordners nach fehlgeschlagenen Dateiverschiebungen oder das Löschen eines Ordners, dessen Inhalt nicht gelöscht wurde) |

Das Ergebnis bietet außerdem `successes`, `failures`, `skipped` und `isComplete` (true, wenn alle Elemente erfolgreich waren, auch bei einem leeren Batch). Da `MisskeyBatchItemResult` sealed ist, ist ein `switch` über die Elemente vollständig:

```dart
final result = await client.drive.files.createMany(inputs);

for (final item in result.items) {
  switch (item) {
    case MisskeyBatchSuccess(:final value):
      print('#${item.index} ${value.file.id} (${value.outcome.name})');
    case MisskeyBatchFailure(:final error):
      print('#${item.index} fehlgeschlagen: $error');
    case MisskeyBatchSkipped(:final reason, :final cause):
      print('#${item.index} übersprungen: ${reason.name} ${cause ?? ''}');
  }
}
```

### Abbruch {#cancellation}

`createMany()` und `deleteFolderRecursive()` akzeptieren ein `MisskeyCancellationToken`. Der Abbruch erfolgt kooperativ: Neue Vorgänge werden nicht gestartet, laufende Anfragen jedoch nicht abgebrochen, sondern bis zum Abschluss abgewartet. Nicht gestartete Elemente werden in der Regel mit `cancelled` als übersprungen gemeldet. In `deleteFolderRecursive()` wird ein Ordner, dessen Wiederholung bei `HAS_CHILD_FILES_OR_FOLDERS` durch einen Abbruch unterbrochen wird, stattdessen als fehlgeschlagen gemeldet, da sein Löschvorgang bereits versucht wurde.

```dart
final token = MisskeyCancellationToken();
final future = client.drive.files.createMany(inputs, cancellation: token);

// Später, zum Beispiel wenn die Benutzerin oder der Benutzer auf „Abbrechen“ tippt
token.cancel();

final result = await future;
print('Hochgeladen: ${result.successes.length} von ${inputs.length}');
```

## Dateien gesammelt verschieben {#moving-files-in-bulk}

`moveBulkAll()` verschiebt eine beliebige Anzahl von Dateien in einen Ordner. Übergeben Sie `null` für `folderId` (oder lassen Sie es weg), um sie in den Stammordner zu verschieben.

```dart
final result = await client.drive.files.moveBulkAll(
  fileIds: selectedFileIds,
  folderId: targetFolderId,
);

if (!result.isComplete) {
  print('Nicht bestätigt: ${result.unconfirmedFileIds}');
}
```

- Doppelte IDs werden entfernt; die übrigen IDs werden in aufeinanderfolgenden Blöcken mit höchstens 100 Einträgen gesendet. Jeder Block bildet einen Eintrag in `result.chunks`.
- Nach dem ersten fehlgeschlagenen Block wird die Verarbeitung angehalten; spätere Blöcke werden als übersprungen gemeldet. `unconfirmedFileIds` enthält die IDs aus fehlgeschlagenen oder nicht gestarteten Blöcken.
- Wenn `folderId` nicht null ist, wird der Zielordner vor dem Verschieben geprüft, da der Server einen fehlenden Ordner andernfalls als allgemeinen Fehler 500 meldet. Eine fehlgeschlagene Prüfung löst eine Ausnahme aus (zum Beispiel `MisskeyApiException` mit dem Code `NO_SUCH_FOLDER`), und es werden keine Dateien verschoben. Wird der Ordner nach der Prüfung gelöscht, erscheint dies als fehlgeschlagener Block.
- Ein erfolgreicher Block bedeutet, dass der Server ihn angenommen hat, nicht, dass alle IDs verschoben wurden: Nicht vorhandene IDs oder IDs anderer Benutzer werden vom Server stillschweigend ignoriert.
- Bei leerem `fileIds` wird keinerlei Anfrage gesendet, auch keine Prüfung des Zielordners.

Dieser Helfer verwendet den Endpunkt `drive/files/move-bulk` und benötigt Misskey 2025.5.1 oder höher. Bei älteren Servern wird der Endpunktfehler als fehlgeschlagener Block zurückgegeben.

## Ordnerbaum und Nutzungsübersicht {#folder-tree-and-usage-summary}

### Ordnerbaum {#folder-tree}

`getTree()` gibt einen unveränderlichen `DriveFolderTree` mit den Ordnern zurück:

```dart
final tree = await client.drive.folders.getTree(maxDepth: 2);

for (final node in tree.nodes) {
  print('${'  ' * node.depth}${node.folder.name}');
}
print('${tree.folderCount} Ordner, gekürzt: ${tree.isTruncated}');
```

- Für jeden besuchten Ordner werden eine oder mehrere Auflistungsanfragen gesendet, daher sind große Bäume kostspielig. `concurrency` (Standardwert 4) begrenzt die parallelen Anfragen.
- Übergeben Sie `rootFolderId`, um bei diesem Ordner zu beginnen (verfügbar über `tree.rootNode`), oder lassen Sie es weg, um beim Drive-Stammordner zu beginnen.
- Mit `maxDepth` werden Ordner auf der Tiefengrenze aufgenommen, ihre Unterordner jedoch nicht aufgelistet: `DriveFolderNode.childrenLoaded` ist `false` und `tree.isTruncated` ist `true`. Ein abgeschnittener Baum bedeutet nicht, dass tiefere Ordner existieren.
- Der Vorgang ist schreibgeschützt; jeder Anfragefehler bricht den Durchlauf ab und wird als Ausnahme ausgelöst.

### Nutzungsübersicht {#usage-summary}

`getUsageSummary()` durchsucht den gesamten Drive und summiert die Anzahl der Dateien und Bytes nach Ordner und MIME-Typ:

```dart
final summary = await client.drive.getUsageSummary(
  onProgress: (scanned) => print('$scanned Dateien durchsucht'),
);

print('Gesamt: ${summary.total.totalBytes} Bytes in ${summary.total.fileCount} Dateien');
print('Stammordner: ${summary.root.totalBytes} Bytes');

for (final usage in summary.allFolders) {
  print('${usage.folder.name}: ${usage.recursive.totalBytes} Bytes');
}

summary.byMimeType.forEach((type, stats) {
  print('$type: ${stats.fileCount} Dateien');
});
```

Jedes `DriveFolderUsage` enthält Statistiken für `direct` (Dateien direkt im Ordner) und `recursive` (Ordner und alle Nachkommen). `summary.folderUsage(folderId)` ruft die Daten für einen Ordner ab.

- Aufwand: ungefähr eine `drive/stream`-Anfrage pro 100 Dateien sowie eine Ordnerauflistung pro Ordner.
- Es handelt sich nicht um eine atomare Momentaufnahme. Gleichzeitige Drive-Änderungen können zu kleineren Inkonsistenzen führen; Dateien in Ordnern, die im durchsuchten Baum fehlen, werden unter `unassigned` gezählt.
- Verknüpfte Dateien (nicht zwischengespeicherte Remote-Dateien mit `isLink`) werden hier berücksichtigt, jedoch nicht in der vom Server gemeldeten Nutzung; daher kann `summary.total` von `client.drive.stats.getCapacity()` abweichen.

## Pfade auflösen {#resolving-paths}

### resolvePath

`resolvePath()` sucht anhand einer Liste von Ordnernamen nach einem Ordner und sendet pro Segment eine `folders/find`-Anfrage. Wird ein Segment nicht gefunden, gibt die Methode `null` zurück. Dasselbe gilt, wenn `parentId` nicht existiert.

```dart
final folder = await client.drive.folders.resolvePath(['Photos', '2026', 'Trip']);
if (folder == null) {
  print('Nicht gefunden');
}
```

Jedes Listenelement ist ein vollständiger Ordnername, daher kann ein Name selbst `/` enthalten. Eine leere Liste, ein leeres Segment oder ein Segment mit mehr als 200 Zeichen (Unicode-Codepoints) löst vor jeder Anfrage `ArgumentError` aus.

### Gleichnamige Ordner {#same-named-folders}

Misskey erlaubt gleichnamige Ordner auf derselben Ebene, und `folders/find` gibt sie in nicht garantierter Reihenfolge zurück. `onAmbiguous` wählt die Richtlinie:

| `DriveFolderAmbiguityPolicy` | Verhalten |
|---|---|
| `error` (Standard) | Löst `DriveFolderAmbiguousException` aus |
| `oldest` | Wählt den frühesten `createdAt`-Wert, dann die niedrigste ID |
| `newest` | Wählt den spätesten `createdAt`-Wert, dann die höchste ID |

`DriveFolderAmbiguousException` enthält den mehrdeutigen `name`, dessen `parentId`, die passenden `candidates` und den `segmentIndex`. Die Ausnahme ist kein Subtyp von `MisskeyClientException`; fangen Sie sie daher ausdrücklich ab:

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} Ordner mit dem Namen "${e.name}" in Segment ${e.segmentIndex}');
}
```

### getOrCreate

`getOrCreate()` sucht unter `parentId` (Stammordner, wenn nicht angegeben) nach einem Ordner mit dem Namen oder erstellt ihn, falls keine Übereinstimmung vorliegt:

```dart
final result = await client.drive.folders.getOrCreate(
  name: 'Screenshots',
  parentId: photosFolderId,
  onAmbiguous: DriveFolderAmbiguityPolicy.oldest,
);
print('${result.folder.id} erstellt: ${result.created}');
```

- Akzeptiert dieselbe `onAmbiguous`-Richtlinie wie `resolvePath()`.
- Der Vorgang ist nicht atomar: Gleichzeitige Aufrufe können jeweils einen gleichnamigen Ordner erstellen.
- `folders/create` ist auf 10 Anfragen pro Stunde begrenzt. Eine `MisskeyRateLimitException` wird weitergegeben.
- Ein leerer oder mehr als 200 Zeichen langer Name löst `ArgumentError` aus. Bei einem nicht existierenden `parentId` wird nichts gefunden; anschließend schlägt die Erstellungsanfrage mit `NO_SUCH_FOLDER` als `MisskeyApiException` fehl.

## Ordner auflösen und löschen {#dissolving-and-deleting-folders}

### dissolveFolder

`dissolveFolder()` verschiebt die direkten Dateien und Unterordner eines Ordners in dessen übergeordneten Ordner (oder den Stammordner) und löscht anschließend den leeren Ordner. Es wird nichts umbenannt; Misskey erlaubt doppelte Namen.

```dart
final result = await client.drive.dissolveFolder(folderId: folderId);

if (!result.isComplete) {
  print('Dateiverschiebungen abgeschlossen: ${result.files.isComplete}');
  print('Unterordner-Verschiebungen abgeschlossen: ${result.subfolders.isComplete}');
  print('Löschung: ${result.deletion}');
}
```

- Wenn der Ordner, sein Inhalt oder der Ziel-Elternordner (wird geprüft, wenn Dateien zu verschieben sind) nicht gelesen werden kann, wird vor jeder Änderung eine Ausnahme ausgelöst.
- Dateien werden mit `moveBulkAll()` verschoben (aufeinanderfolgende Blöcke zu je 100, Misskey 2025.5.1 oder höher). Unterordner werden parallel verschoben, begrenzt durch `concurrency` (Standardwert 4). Sind die Dateiverschiebungen nicht vollständig, werden Unterordner-Verschiebungen und das Löschen übersprungen.
- Der Quellordner wird nur gelöscht, wenn alle Verschiebungen erfolgreich waren. Bei HTTP 429 werden keine neuen Unterordner-Verschiebungen gestartet, die übrigen Unterordner als `rateLimited` gemeldet und das Löschen übersprungen.
- Gleichzeitig zum Ordner hinzugefügte Elemente können dazu führen, dass das Löschen mit `HAS_CHILD_FILES_OR_FOLDERS` fehlschlägt; dies wird in `result.deletion` gemeldet.
- Nach einem Teilergebnis kann der Vorgang sicher erneut ausgeführt werden.

### deleteFolderRecursive

:::danger Unwiderruflich

`deleteFolderRecursive()` löscht einen Ordner, alle Unterordner und sämtliche darin enthaltenen Dateien dauerhaft. Gelöschte Dateien können nicht wiederhergestellt werden. Notizen und Galeriebeiträge, die eine gelöschte Datei verwenden, behalten einen ungültigen Verweis darauf; Chatnachrichten verlieren ihren Anhang. Führen Sie den Vorgang zuerst mit `dryRun: true` aus und prüfen Sie den Plan.

:::

```dart
// 1. Plan prüfen, ohne etwas zu löschen
final preview = await client.drive.deleteFolderRecursive(
  folderId: folderId,
  dryRun: true,
);
final plan = preview.plan;
print('${plan.fileCount} Dateien, ${plan.folderCount} Ordner, ${plan.totalBytes} Bytes');

// 2. Löschen
final result = await client.drive.deleteFolderRecursive(
  folderId: folderId,
  onProgress: (p) => print('${p.phase.name}: ${p.completed}/${p.total}'),
);

if (!result.isComplete) {
  print('Stammordner gelöscht: ${result.rootDeleted}');
  for (final failure in result.files.failures) {
    print('Datei ${failure.input.name}: ${failure.error}');
  }
  for (final failure in result.folders.failures) {
    print('Ordner ${failure.input.name}: ${failure.error}');
  }
}
```

Der Vorgang wird in drei Phasen ausgeführt (`DriveRecursiveDeletePhase`): `planning` lädt Baum und Dateien ohne Änderungen, `deletingFiles` löscht die geplanten Dateien und `deletingFolders` löscht Ordner von der tiefsten Ebene aus. Fortschrittszähler gelten pro Phase und schließen übersprungene Elemente ein.

- **Fehler bei der Planung lösen eine Ausnahme aus**, bevor etwas gelöscht wird. Einzelne Fehler nach Beginn des Löschvorgangs werden in `result.files` und `result.folders` zurückgegeben.
- **Ein Dry-Run fixiert die Ziele nicht.** Ein späterer Aufruf ohne `dryRun` erstellt einen neuen Plan, der zwischenzeitlich hinzugefügte Elemente enthalten kann. Geplante Elemente werden auch dann gelöscht, wenn sie nach der Planung an einen anderen Ort verschoben wurden.
- **Teilergebnisse:** Ordner, deren geplanter Inhalt nicht vollständig erfolgreich war, werden nicht gelöscht; dasselbe gilt für ihre übergeordneten Ordner. Bereits entfernte Dateien und Ordner gelten als erfolgreich gelöscht.
- **Bei Ratenbegrenzung** werden keine neuen Vorgänge gestartet.
- **Der Abbruch** erfolgt kooperativ. Ein Abbruch während der Planung stoppt noch nicht gestartete Datei-Auflistungen und gibt alle geplanten Elemente als mit `cancelled` übersprungen zurück; Löschanfragen werden nicht gesendet.
- **Wiederholungen bei `HAS_CHILD_FILES_OR_FOLDERS`:** Misskey entfernt den Datenbankeintrag einer Datei erst nach der Antwort auf die Löschanfrage. Wird der Ordner sofort danach gelöscht, kann `HAS_CHILD_FILES_OR_FOLDERS` auftreten. Bei Ordnern, deren geplante untergeordnete Elemente gelöscht wurden, wird bei diesem Fehler mit exponentiellem Backoff ab 200 ms erneut versucht, wobei insgesamt höchstens fünf Versuche erfolgen. Andere Schreibfehler werden nicht wiederholt.
- Wenn `onProgress` eine Ausnahme auslöst, werden noch nicht gestartete Vorgänge angehalten; der Fehler wird erneut ausgelöst, nachdem laufende Vorgänge beendet sind. Bereits erfolgte Löschungen können nicht rückgängig gemacht werden.

## Uploads {#uploading}

### Vorabprüfungen {#preflight-checks}

`getUploadPreflight()` ruft die Rollenrichtlinien der aktuellen Person und die Drive-Kapazität ab (zwei parallel gesendete Anfragen), damit Dateien vor dem Upload lokal geprüft werden können:

```dart
final meta = await client.meta.getMeta();
final preflight = await client.drive.getUploadPreflight(meta: meta);

final check = preflight.check(size: bytes.length, mimeType: 'image/png');
if (!check.canUpload) {
  for (final issue in check.issues) {
    print(issue);
  }
}
```

Jedes `DriveUploadIssue` hat eine `severity`:

| Problem | Schweregrad | Bedeutung |
|---|---|---|
| `DriveUploadFileTooLarge` | blockierend | Überschreitet `maxFileSizeMb` der Rolle oder – wenn `instanceLimit` `true` ist – das Multipart-Limit der Instanz |
| `DriveUploadInsufficientCapacity` | blockierend | Würde die verbleibende Drive-Kapazität überschreiten |
| `DriveUploadTypeNotAllowed` | Hinweis | Der MIME-Typ gehört nicht zu den für die Rolle zulässigen Upload-Typen. Nur ein Hinweis, da der Server den tatsächlichen Typ anhand des Dateiinhalts erkennt |
| `DriveUploadPoliciesUnavailable` | Hinweis | Einige Richtlinienwerte fehlten; die entsprechenden Prüfungen wurden übersprungen |

`canUpload` ist nur dann `false`, wenn ein blockierendes Problem vorliegt.

- Moderatoren und Administratoren unterliegen nicht den Rollenrichtlinien, daher gilt für sie nur die Dateigrößenprüfung der Instanz.
- Wenn `meta` fehlt, wird keine `/meta`-Anfrage gesendet und die instanzweite Dateigrößenprüfung übersprungen.
- Verwenden Sie `checkAll()`, um mehrere Dateien nacheinander zu prüfen; die Größe jeder Datei wird von der für die nächste Datei verfügbaren Kapazität abgezogen.
- Das Ergebnis dient nur als Hinweis. Grenzwerte und Nutzung können sich nach der Momentaufnahme ändern. Da der Server vorhandene Dateien mit demselben Inhalt möglicherweise vor der Auswertung der Rollenrichtlinien zurückgibt, können Richtlinienprobleme bei Dateien mit doppeltem Inhalt falsch-positive Ergebnisse sein.

### createDeduplicated

Wenn Sie Inhalte hochladen, die bereits in Ihrem Drive vorhanden sind, gibt der Server die vorhandene Datei zurück – allerdings erst nach dem vollständigen Empfang des Uploads. Die angegebenen Parameter `folderId`, `name` und `comment` werden ignoriert. `createDeduplicated()` sucht zuerst per MD5 und vermeidet bei einem Treffer die Übertragung:

```dart
final result = await client.drive.files.createDeduplicated(
  bytes: bytes,
  filename: 'photo.jpg',
  folderId: albumFolderId,
  onDuplicate: DriveDuplicatePolicy.moveExisting,
);

print('${result.file.id}: ${result.outcome.name}');
```

| `DriveDuplicatePolicy` | Verhalten, wenn eine Datei mit gleichem Inhalt existiert |
|---|---|
| `reuseExisting` (Standard) | Gibt die vorhandene Datei zurück, ohne sie zu verschieben |
| `moveExisting` | Verschiebt die vorhandene Datei nach `folderId`, falls sie sich an einem anderen Ort befindet |
| `uploadAnyway` | Überspringt die Suche und lädt eine weitere Kopie hoch |

- `result.outcome` ist `uploaded`, `reusedExisting` oder `movedExisting`. Das Ergebnis ist bestmöglich: Ein gleichzeitiger Upload kann nach der Suche zuerst abgeschlossen werden, und solche Konflikte lassen sich nicht immer erkennen.
- Name und Kommentar vorhandener Dateien bleiben erhalten. `isSensitive: true` stuft eine vorhandene nicht-sensible Datei als sensibel ein.
- Übergeben Sie `md5` (32 hexadezimale Zeichen), um das Hashing großer Eingaben zu vermeiden. Andernfalls wird der Hash synchron im aufrufenden Isolate berechnet (außer bei `uploadAnyway`).
- Wenn eine vorhandene Datei übereinstimmt, wird `folderId` nicht validiert; ein nicht existierender oder fremder Ordner verursacht daher bei `reuseExisting` keinen Fehler. Ein einfaches `create()` ohne `force` verhält sich genauso, da der Server den Treffer zurückgibt, bevor er den Ordner abfragt.

### createMany

`createMany()` lädt eine Liste von `DriveUploadInput`-Werten mit begrenzter Parallelität hoch und gibt ein `MisskeyBatchResult` in Eingabereihenfolge zurück:

```dart
final inputs = [
  for (final path in paths)
    DriveUploadInput(
      bytes: await File(path).readAsBytes(),
      filename: path.split('/').last,
      folderId: albumFolderId,
    ),
];

final result = await client.drive.files.createMany(
  inputs,
  concurrency: 2,
  deduplicate: DriveDuplicatePolicy.reuseExisting,
  onProgress: (p) => print('${p.completedItems}/${p.totalItems} done'),
);
```

- `concurrency` (Standardwert 2) begrenzt die Anzahl paralleler Uploads.
- Bei einer Ratenbegrenzung (HTTP 429) werden keine neuen Uploads gestartet und die übrigen Eingaben als `rateLimited` markiert; laufende Uploads werden beendet. Setzen Sie `stopOnError: true`, um nach einem beliebigen Fehler anzuhalten und die übrigen Eingaben als `stoppedAfterError` zu überspringen.
- Mit `deduplicate` wird jede Eingabe wie `createDeduplicated()` mit der angegebenen Richtlinie behandelt. Identische Eingaben im selben Batch bilden eine geordnete Kette: Jedes Folgeelement wartet auf seinen Vorgänger (und belegt dabei einen Worker) und verwendet gemäß der Richtlinie dessen aktuellstes Ergebnis. Bei `moveExisting` landet die Datei im Ordner des letzten Elements. Dateiname, Name und Kommentar späterer Eingaben werden ignoriert; `isSensitive` kann die Datei nur auf `true` setzen. Schlägt ein Vorgänger fehl oder wird übersprungen, wird ein bereits laufendes Folgeelement als `dependencyFailed` übersprungen. Bei `uploadAnyway` wird jede Eingabe unabhängig hochgeladen.
- Ohne `deduplicate` kann der Server dennoch eine vorhandene Datei mit identischem Inhalt zurückgeben; sie wird dann als `uploaded` gemeldet.
- `onProgress` erhält ein `DriveBatchUploadProgress` mit Elementzählern (`completedItems`, `succeededItems`, `failedItems`, `totalItems`) und dem Byte-Fortschritt (`sent`, `total`) des Elements bei `itemIndex`.
- Es gibt keine automatischen Wiederholungen. Ein Netzwerkfehler, nachdem der Server eine Datei gespeichert hat, wird als Fehler gemeldet. Bei einer erneuten Ausführung ohne `deduplicate` oder mit `reuseExisting` beziehungsweise `moveExisting` wird die gespeicherte Datei zurückgegeben, statt eine weitere anzulegen, da diese Uploads serverseitig dedupliziert werden (`force: false`). Bei `uploadAnyway` (`force: true`) kann eine erneute Ausführung zusätzliche Kopien erzeugen.
- Die Eingabebytes werden nicht kopiert; ändern Sie sie nicht, bis der Batch abgeschlossen ist.

## Auf URL-Uploads warten {#waiting-for-url-uploads}

`uploadFromUrl()` kehrt zurück, sobald der Server die Anfrage annimmt; die Datei wird später hinzugefügt. `uploadFromUrlAndWait()` wartet zusätzlich auf das Ereignis `urlUploadFinished` des main-Streaming-Kanals und gibt die erstellte Datei zurück. Abonnement und Verbindung werden nicht automatisch hergestellt; abonnieren Sie zuerst `MisskeyStreamingChannel.main()` und stellen Sie die Verbindung her.

```dart
final main = await client.streaming.subscribe(
  const MisskeyStreamingChannel.main(),
);
await client.streaming.connect();

try {
  final file = await client.drive.uploadFromUrlAndWait(
    url: 'https://example.com/image.jpg',
    folderId: myFolderId,
    timeout: const Duration(minutes: 5),
  );
  print(file.id);
} on MisskeyStreamingTimeoutException {
  print('Upload wurde nicht rechtzeitig abgeschlossen (oder ist auf dem Server fehlgeschlagen)');
}
```

- Das Token benötigt die Berechtigungen `write:drive` und `read:account`.
- Mit `mainSubscription` kann ein bestimmtes `main`-Abonnement ausgewählt werden; andernfalls wird das zuerst in `client.streaming.subscriptions` registrierte verwendet. Ein fehlendes oder inaktives Abonnement oder eine nicht verbundene Streaming-Verbindung löst `StateError` aus.
- Bei einem fehlgeschlagenen Upload sendet der Server kein Ereignis, daher ist ein Fehler nur als Timeout erkennbar. Ein Timeout bricht den serverseitigen Upload nicht ab. `timeout` (Standardwert 2 Minuten) beginnt nach Abschluss der Upload-Anfrage.
- Während einer Wiederverbindung eintreffende Ereignisse gehen verloren.
- Für jeden Aufruf wird ein eindeutiger `marker` generiert. Ein eigener Wert darf nicht leer sein und muss für jeden Upload eindeutig sein.
- Durch serverseitige Deduplizierung kann eine vorhandene Datei aus einem anderen Ordner zurückgegeben werden.

Details zu Verbindung und Abonnement finden Sie unter [Streaming API](../streaming.md).

## Ratenlimits {#rate-limits}

Misskeys standardmäßige Limits pro Benutzer für die von diesen Helfern verwendeten Endpunkte:

| Endpunkt | Limit | Verwendet von |
|---|---|---|
| `drive/folders/create` | 10 pro Stunde | `getOrCreate()` |
| `drive/files/create` | 120 pro Stunde | `createDeduplicated()`, `createMany()` |
| `drive/files/upload-from-url` | 60 pro Stunde | `uploadFromUrlAndWait()` |
| Auflistung, `show`, `find`, `update`, `delete`, `move-bulk` | Kein Limit pro Endpunkt | Alle übrigen Helfer |

Die vom Serveradministrator festgelegten Ratenlimit-Faktoren für Rollen skalieren diese Werte. Bei Erreichen eines Limits lösen Helfer mit einzelnen Anfragen `MisskeyRateLimitException` aus; Batch-Helfer starten keine neuen Vorgänge. Noch nicht gestartete unabhängige Vorgänge werden in `createMany()`, in der Unterordner-Verschiebephase von `dissolveFolder()` und in den Löschphasen von `deleteFolderRecursive()` als `rateLimited` gemeldet. Blöcke von `moveBulkAll()` verwenden `stoppedAfterError`, abhängige Vorgänge können `dependencyFailed` sein, und ein unterbrochener Wiederholungsversuch beim Löschen eines Ordners bleibt ein Fehlschlag.
