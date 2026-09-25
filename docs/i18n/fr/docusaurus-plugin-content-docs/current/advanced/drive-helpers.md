---
sidebar_position: 3
title: Assistants Drive
---

# Assistants Drive

Les assistants Drive sont des méthodes de niveau supérieur qui regroupent plusieurs appels à l’API Drive en une seule opération : parcourir toutes les pages, explorer l’arborescence des dossiers, déplacer ou téléverser plusieurs fichiers et supprimer un dossier avec tout son contenu. Ils sont disponibles sur les mêmes façades que les points de terminaison simples (`client.drive`, `client.drive.files` et `client.drive.folders`). Consultez [Téléversement Drive](./drive-upload.md) pour les points de terminaison en une seule requête.

Chaque assistant envoyant plusieurs requêtes, aucun n’est atomique. Les modifications effectuées sur le serveur pendant son exécution (par un autre client, par exemple) peuvent se refléter dans le résultat.

## Tout lister {#listing-everything}

Trois assistants parcourent les pages d’une liste et renvoient un `Stream` :

| Méthode | Éléments listés | Filtres |
|---|---|---|
| `client.drive.files.listAll()` | Fichiers d’un dossier (racine si `folderId` est omis) | `folderId`, `type` |
| `client.drive.folders.listAll()` | Dossiers d’un dossier parent (racine si `folderId` est omis) | `folderId` |
| `client.drive.streamAll()` | Fichiers de tous les dossiers | `type` |

```dart
// Toutes les images d’un dossier
await for (final file in client.drive.files.listAll(
  folderId: myFolderId,
  type: 'image/*',
)) {
  print('${file.name} (${file.size} bytes)');
}

// Au plus 500 fichiers de tout le Drive
final recent = await client.drive.streamAll(maxItems: 500).toList();
```

### Uniquement par ID, du plus récent au plus ancien {#newest-first-id-order-only}

Les résultats sont toujours renvoyés par ID, du plus récent au plus ancien. `listAll()` n’accepte pas `sort` : le serveur applique le curseur `untilId` comme filtre par ID même lors d’un tri par nom ou par taille, ce qui ferait sauter ou répéter des éléments entre les pages. Pour obtenir un autre ordre, récupérez les résultats et triez-les localement :

```dart
final files = await client.drive.files.listAll(folderId: myFolderId).toList();
files.sort((a, b) => b.size.compareTo(a.size)); // Du plus grand au plus petit
```

### Taille des pages et limites {#page-size-and-limits}

- `pageSize` est le nombre d’éléments demandés par appel (1–100, 100 par défaut).
- `maxItems` arrête le flux après ce nombre d’éléments. `0` n’envoie aucune requête.

Les valeurs invalides provoquent une exception `ArgumentError` synchrone, dès l’appel de la méthode.

### Comportement du flux {#stream-behavior}

Chaque appel renvoie un flux froid à abonnement unique. Aucune requête n’est envoyée avant l’écoute ; l’annulation de l’abonnement (ou la sortie anticipée d’une boucle `await for`) arrête les requêtes des pages suivantes. Les erreurs d’API sont transmises comme erreurs du flux après les éventuels éléments déjà émis.

La liste ne constitue pas un instantané ; les fichiers ajoutés, déplacés ou supprimés pendant la pagination peuvent être omis ou inclus.

### Filtre de type MIME {#mime-type-filter}

`type` n’accepte que les lettres, `/`, `-` et `*`. Le serveur rejette les valeurs contenant des chiffres : `video/mp4` échoue. Utilisez un caractère générique comme `video/*` et filtrez localement si vous avez besoin d’un type exact :

```dart
final mp4s = await client.drive
    .streamAll(type: 'video/*')
    .where((file) => file.type == 'video/mp4')
    .toList();
```

## Résultats des traitements par lots et annulation {#batch-results-and-cancellation}

Une fois que les assistants qui modifient plusieurs éléments ont commencé à effectuer des modifications, l’échec d’une opération individuelle ne provoque pas d’exception ; il est consigné dans un `MisskeyBatchResult<I, T>`, qui contient un résultat par entrée, dans l’ordre des entrées. Une erreur levée par votre propre callback `onProgress` lors du signalement d’un élément traité est différente : les nouvelles opérations sont arrêtées et l’erreur est relancée une fois les requêtes en cours terminées. Les modifications déjà effectuées ne sont pas annulées.

| Type | Signification | Champs |
|---|---|---|
| `MisskeyBatchSuccess<I, T>` | L’opération a réussi | `input`, `index`, `value` |
| `MisskeyBatchFailure<I, T>` | L’opération a levé une exception | `input`, `index`, `error`, `stackTrace` |
| `MisskeyBatchSkipped<I, T>` | L’opération n’a pas été lancée | `input`, `index`, `reason`, `cause` |

`MisskeyBatchSkipReason` indique pourquoi un élément a été ignoré :

| Valeur | Signification |
|---|---|
| `cancelled` | Une annulation a été demandée |
| `rateLimited` | Le serveur a limité le débit d’une requête (HTTP 429) dans `createMany()`, `dissolveFolder()` ou `deleteFolderRecursive()` |
| `stoppedAfterError` | Une erreur précédente a interrompu le traitement par lots (`createMany()` avec `stopOnError`, ou tout groupe en échec dans `moveBulkAll()`, y compris une erreur 429) |
| `dependencyFailed` | Une opération préalable a échoué (par exemple, la dissolution après l’échec du déplacement de fichiers, ou la suppression d’un dossier dont le contenu n’a pas été supprimé) |

Le résultat fournit également `successes`, `failures`, `skipped` et `isComplete` (true lorsque chaque élément a réussi, y compris pour un lot vide). `MisskeyBatchItemResult` étant sealed, un `switch` sur ses éléments est exhaustif :

```dart
final result = await client.drive.files.createMany(inputs);

for (final item in result.items) {
  switch (item) {
    case MisskeyBatchSuccess(:final value):
      print('#${item.index} ${value.file.id} (${value.outcome.name})');
    case MisskeyBatchFailure(:final error):
      print('#${item.index} failed: $error');
    case MisskeyBatchSkipped(:final reason, :final cause):
      print('#${item.index} skipped: ${reason.name} ${cause ?? ''}');
  }
}
```

### Annulation {#cancellation}

`createMany()` et `deleteFolderRecursive()` acceptent un `MisskeyCancellationToken`. L’annulation est coopérative : elle empêche le démarrage de nouvelles opérations, mais les requêtes en cours ne sont pas interrompues et leur achèvement est attendu. Les éléments non commencés sont généralement signalés comme ignorés avec `cancelled`. Dans `deleteFolderRecursive()`, un dossier dont la nouvelle tentative après `HAS_CHILD_FILES_OR_FOLDERS` est interrompue est plutôt signalé comme un échec, car sa suppression a déjà été tentée.

```dart
final token = MisskeyCancellationToken();
final future = client.drive.files.createMany(inputs, cancellation: token);

// Plus tard, par exemple lorsque l’utilisateur appuie sur « Annuler »
token.cancel();

final result = await future;
print('Uploaded ${result.successes.length} of ${inputs.length}');
```

## Déplacer des fichiers en masse {#moving-files-in-bulk}

`moveBulkAll()` déplace un nombre quelconque de fichiers vers un dossier. Passez `null` à `folderId` (ou omettez-le) pour les déplacer vers la racine.

```dart
final result = await client.drive.files.moveBulkAll(
  fileIds: selectedFileIds,
  folderId: targetFolderId,
);

if (!result.isComplete) {
  print('Not confirmed: ${result.unconfirmedFileIds}');
}
```

- Les ID en double sont supprimés, puis les autres sont envoyés séquentiellement par groupes de 100 au maximum. Chaque groupe correspond à une entrée de `result.chunks`.
- Le traitement s’arrête après le premier groupe en échec ; les groupes suivants sont signalés comme ignorés. `unconfirmedFileIds` répertorie les ID des groupes en échec ou non démarrés.
- Si `folderId` n’est pas null, le dossier de destination est vérifié avant tout déplacement, car le serveur signalerait sinon un dossier manquant par une erreur 500 générique. L’échec de cette vérification est levé (par exemple une `MisskeyApiException` avec le code `NO_SUCH_FOLDER`) et aucun fichier n’est déplacé. Si le dossier est supprimé après la vérification, le groupe correspondant échoue.
- Un groupe réussi signifie que le serveur l’a accepté, pas que chaque ID a été déplacé : le serveur ignore silencieusement les ID inexistants ou appartenant à un autre utilisateur.
- Si `fileIds` est vide, aucune requête n’est envoyée, pas même la vérification de destination.

Cet assistant utilise le point de terminaison `drive/files/move-bulk`, qui nécessite Misskey 2025.5.1 ou ultérieur. Les serveurs plus anciens renvoient leur erreur de point de terminaison sous forme de groupe en échec.

## Arborescence des dossiers et récapitulatif de l’utilisation {#folder-tree-and-usage-summary}

### Arborescence des dossiers {#folder-tree}

`getTree()` renvoie une arborescence de dossiers `DriveFolderTree` immuable :

```dart
final tree = await client.drive.folders.getTree(maxDepth: 2);

for (final node in tree.nodes) {
  print('${'  ' * node.depth}${node.folder.name}');
}
print('${tree.folderCount} folders, truncated: ${tree.isTruncated}');
```

- Il envoie une ou plusieurs requêtes de liste pour chaque dossier parcouru ; les grandes arborescences sont donc coûteuses. `concurrency` (4 par défaut) limite le nombre de requêtes parallèles.
- Passez `rootFolderId` pour commencer à un dossier (accessible via `tree.rootNode`), ou omettez-le pour partir de la racine du Drive.
- Avec `maxDepth`, les dossiers à la profondeur limite sont inclus, mais leurs enfants ne sont pas listés : `DriveFolderNode.childrenLoaded` vaut `false` et `tree.isTruncated` vaut `true`. Une arborescence tronquée ne signifie pas nécessairement que des dossiers plus profonds existent.
- Cette opération est en lecture seule : toute erreur de requête interrompt le parcours et est levée.

### Récapitulatif de l’utilisation {#usage-summary}

`getUsageSummary()` parcourt tout le Drive et agrège le nombre de fichiers et leur taille en octets par dossier et par type MIME :

```dart
final summary = await client.drive.getUsageSummary(
  onProgress: (scanned) => print('Scanned $scanned files'),
);

print('Total: ${summary.total.totalBytes} bytes in ${summary.total.fileCount} files');
print('Root: ${summary.root.totalBytes} bytes');

for (final usage in summary.allFolders) {
  print('${usage.folder.name}: ${usage.recursive.totalBytes} bytes');
}

summary.byMimeType.forEach((type, stats) {
  print('$type: ${stats.fileCount} files');
});
```

Chaque `DriveFolderUsage` contient les statistiques `direct` (fichiers directement dans le dossier) et `recursive` (le dossier et tous ses descendants). `summary.folderUsage(folderId)` recherche un dossier.

- Coût : environ une requête `drive/stream` pour 100 fichiers, plus une liste de dossiers par dossier.
- Il ne s’agit pas d’un instantané atomique. Des modifications simultanées du Drive peuvent entraîner de légères incohérences ; les fichiers dans des dossiers absents de l’arborescence parcourue sont comptabilisés dans `unassigned`.
- Les fichiers liés (fichiers distants non mis en cache avec `isLink`) sont inclus ici, mais exclus de l’utilisation rapportée par le serveur ; `summary.total` peut donc différer de `client.drive.stats.getCapacity()`.

## Résoudre des chemins {#resolving-paths}

### resolvePath

`resolvePath()` recherche un dossier à partir d’une liste de noms, en envoyant une requête `folders/find` par segment. Elle renvoie `null` si un segment est introuvable, y compris lorsque `parentId` n’existe pas.

```dart
final folder = await client.drive.folders.resolvePath(['Photos', '2026', 'Trip']);
if (folder == null) {
  print('Not found');
}
```

Chaque élément de la liste est un nom de dossier complet ; un nom peut donc contenir lui-même `/`. Une liste vide, un segment vide ou un segment de plus de 200 caractères (points de code Unicode) provoque une exception `ArgumentError` avant toute requête.

### Dossiers de même nom {#same-named-folders}

Misskey autorise des dossiers frères de même nom et `folders/find` ne garantit pas leur ordre de renvoi. `onAmbiguous` permet de choisir la politique :

| `DriveFolderAmbiguityPolicy` | Comportement |
|---|---|
| `error` (par défaut) | Lève une `DriveFolderAmbiguousException` |
| `oldest` | Choisit le `createdAt` le plus ancien, puis l’ID le plus petit |
| `newest` | Choisit le `createdAt` le plus récent, puis l’ID le plus grand |

`DriveFolderAmbiguousException` fournit le `name` ambigu, son `parentId`, les `candidates` correspondants et le `segmentIndex`. Elle n’est pas un sous-type de `MisskeyClientException` ; interceptez-la donc explicitement :

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}" at segment ${e.segmentIndex}');
}
```

### getOrCreate

`getOrCreate()` recherche un dossier par nom sous `parentId` (la racine si celui-ci est omis), ou le crée en l’absence de correspondance :

```dart
final result = await client.drive.folders.getOrCreate(
  name: 'Screenshots',
  parentId: photosFolderId,
  onAmbiguous: DriveFolderAmbiguityPolicy.oldest,
);
print('${result.folder.id} created: ${result.created}');
```

- Elle utilise la même politique `onAmbiguous` que `resolvePath()`.
- Elle n’est pas atomique : plusieurs appels simultanés peuvent chacun créer un dossier de même nom.
- `folders/create` est limité à 10 requêtes par heure. Une `MisskeyRateLimitException` est propagée.
- Un nom vide ou de plus de 200 caractères provoque une exception `ArgumentError`. Un `parentId` inexistant ne renvoie aucun résultat, puis la requête de création échoue avec une `MisskeyApiException` et le code `NO_SUCH_FOLDER`.

## Vider et supprimer des dossiers {#dissolving-and-deleting-folders}

### dissolveFolder

`dissolveFolder()` déplace les fichiers directs et les sous-dossiers vers le dossier parent (ou la racine), puis supprime le dossier devenu vide. Aucun élément n’est renommé ; Misskey autorise les noms en double.

```dart
final result = await client.drive.dissolveFolder(folderId: folderId);

if (!result.isComplete) {
  print('File moves complete: ${result.files.isComplete}');
  print('Subfolder moves complete: ${result.subfolders.isComplete}');
  print('Deletion: ${result.deletion}');
}
```

- Si le dossier, son contenu ou le dossier parent de destination (vérifié lorsqu’il y a des fichiers à déplacer) ne peut pas être lu, une exception est levée avant toute modification.
- Les fichiers sont déplacés avec `moveBulkAll()` (groupes séquentiels de 100, Misskey 2025.5.1 ou ultérieur). Les sous-dossiers sont déplacés en parallèle, dans la limite de `concurrency` (4 par défaut). Si tous les déplacements de fichiers n’ont pas abouti, les déplacements des sous-dossiers et la suppression sont ignorés.
- Le dossier source n’est supprimé que si tous les déplacements réussissent. Une réponse HTTP 429 arrête le lancement de nouveaux déplacements de sous-dossiers ; les sous-dossiers restants sont signalés comme `rateLimited` et la suppression est ignorée.
- Des éléments ajoutés simultanément au dossier peuvent faire échouer sa suppression avec `HAS_CHILD_FILES_OR_FOLDERS` ; l’échec est indiqué dans `result.deletion`.
- Vous pouvez relancer l’opération sans risque après un résultat partiel.

### deleteFolderRecursive

:::danger Irréversible
`deleteFolderRecursive()` supprime définitivement un dossier, tous ses sous-dossiers et tous les fichiers qu’ils contiennent. Les fichiers supprimés ne peuvent pas être restaurés. Les Notes et publications de galerie utilisant un fichier supprimé conservent une référence invalide vers celui-ci, et les messages de Chat perdent leur pièce jointe. Exécutez d’abord l’opération avec `dryRun: true` et vérifiez le plan.
:::

```dart
// 1. Examiner le plan sans rien supprimer
final preview = await client.drive.deleteFolderRecursive(
  folderId: folderId,
  dryRun: true,
);
final plan = preview.plan;
print('${plan.fileCount} files, ${plan.folderCount} folders, ${plan.totalBytes} bytes');

// 2. Supprimer
final result = await client.drive.deleteFolderRecursive(
  folderId: folderId,
  onProgress: (p) => print('${p.phase.name}: ${p.completed}/${p.total}'),
);

if (!result.isComplete) {
  print('Root deleted: ${result.rootDeleted}');
  for (final failure in result.files.failures) {
    print('File ${failure.input.name}: ${failure.error}');
  }
  for (final failure in result.folders.failures) {
    print('Folder ${failure.input.name}: ${failure.error}');
  }
}
```

L’opération comporte trois phases (`DriveRecursiveDeletePhase`) : `planning` charge l’arborescence et ses fichiers sans rien modifier, `deletingFiles` supprime les fichiers prévus et `deletingFolders` supprime les dossiers en commençant par les plus profonds. Les compteurs de progression sont propres à chaque phase et incluent les éléments ignorés.

- **Les échecs de planification provoquent une exception** avant toute suppression. Une fois la suppression commencée, les échecs individuels sont renvoyés dans `result.files` et `result.folders`.
- **Une simulation ne fige pas les éléments ciblés.** Un appel ultérieur sans simulation établit un nouveau plan, qui peut inclure les éléments ajoutés entre-temps. Les éléments planifiés sont supprimés même s’ils sont déplacés ailleurs après la planification.
- **Résultats partiels :** la suppression d’un dossier n’est pas tentée si tous les éléments prévus qu’il contient n’ont pas été supprimés ; il en va de même pour ses dossiers parents. Les fichiers et dossiers déjà absents sont considérés comme supprimés avec succès.
- **La limitation de débit** arrête le lancement de nouvelles opérations.
- **L’annulation** est coopérative. Une annulation pendant la planification arrête les listes de fichiers non commencées et renvoie tous les éléments planifiés comme ignorés avec `cancelled` ; aucune suppression n’est envoyée.
- **Nouvelles tentatives pour `HAS_CHILD_FILES_OR_FOLDERS` :** Misskey ne supprime la ligne d’un fichier de la base de données qu’après avoir répondu à la requête de suppression ; supprimer immédiatement son dossier peut donc échouer avec `HAS_CHILD_FILES_OR_FOLDERS`. Les dossiers dont les enfants prévus ont été supprimés font l’objet de nouvelles tentatives en cas de cette erreur, avec un délai exponentiel à partir de 200 ms, cinq tentatives au maximum. Les autres échecs d’écriture ne sont pas réessayés.
- Si `onProgress` lève une exception, les opérations non commencées sont arrêtées et l’erreur est relancée après la fin des opérations en cours. Les suppressions déjà effectuées ne peuvent pas être annulées.

## Téléversement {#uploading}

### Vérifications préalables {#preflight-checks}

`getUploadPreflight()` récupère les politiques de rôle de l’utilisateur actuel et la capacité du Drive (deux requêtes envoyées en parallèle) afin de vérifier les fichiers localement avant leur téléversement :

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

Chaque `DriveUploadIssue` possède un niveau de gravité (`severity`) :

| Problème | Gravité | Signification |
|---|---|---|
| `DriveUploadFileTooLarge` | blocking | Dépasse `maxFileSizeMb` du rôle ou, si `instanceLimit` vaut `true`, la limite multipart de l’instance |
| `DriveUploadInsufficientCapacity` | blocking | Dépasserait la capacité restante du Drive |
| `DriveUploadTypeNotAllowed` | advisory | Le type MIME ne figure pas parmi les types autorisés pour le rôle. Il s’agit d’un avertissement, car le serveur détermine le type réel à partir du contenu du fichier |
| `DriveUploadPoliciesUnavailable` | advisory | Certaines valeurs de politique étaient absentes ; les vérifications correspondantes ont donc été ignorées |

`canUpload` vaut `false` uniquement lorsqu’un problème bloquant est présent.

- Les modérateurs et les administrateurs ne sont pas soumis aux limites des politiques de rôle ; seule la vérification de la taille limite de fichier de l’instance s’applique à eux.
- Si `meta` est omis, aucune requête `/meta` n’est envoyée et la vérification de la taille limite de fichier de l’instance est ignorée.
- Utilisez `checkAll()` pour vérifier plusieurs fichiers dans l’ordre ; la taille de chaque fichier est déduite de la capacité disponible pour le suivant.
- Le résultat est indicatif. Les limites et l’utilisation peuvent changer après l’instantané, et le serveur peut renvoyer un fichier existant de même contenu avant d’évaluer les politiques de rôle ; des problèmes de politique peuvent donc être signalés à tort pour un contenu déjà présent.

### createDeduplicated

Lorsque vous téléversez un contenu déjà présent dans votre Drive, le serveur renvoie le fichier existant, mais seulement après avoir reçu le téléversement complet, et ignore les paramètres `folderId`, `name` et `comment` demandés. `createDeduplicated()` recherche d’abord le MD5 et évite le transfert si une correspondance existe :

```dart
final result = await client.drive.files.createDeduplicated(
  bytes: bytes,
  filename: 'photo.jpg',
  folderId: albumFolderId,
  onDuplicate: DriveDuplicatePolicy.moveExisting,
);

print('${result.file.id}: ${result.outcome.name}');
```

| `DriveDuplicatePolicy` | Comportement si un fichier de même contenu existe |
|---|---|
| `reuseExisting` (par défaut) | Renvoie le fichier existant sans le déplacer |
| `moveExisting` | Déplace le fichier existant vers `folderId` s’il se trouve ailleurs |
| `uploadAnyway` | Ignore la recherche et téléverse une autre copie |

- `result.outcome` vaut `uploaded`, `reusedExisting` ou `movedExisting`. Le résultat est fourni au mieux : un téléversement concurrent peut aboutir après la recherche, et ces courses ne sont pas toujours détectables.
- Les fichiers existants conservent leur nom et leur commentaire. `isSensitive: true` rend sensible un fichier existant qui ne l’était pas.
- Passez `md5` (32 caractères hexadécimaux) pour éviter de calculer le hachage d’entrées volumineuses. Sinon, le hachage est calculé de manière synchrone sur l’isolate appelant (sauf avec `uploadAnyway`).
- Lorsqu’un fichier existant correspond, `folderId` n’est pas validé ; un dossier inexistant ou appartenant à un autre utilisateur ne provoque donc pas d’erreur avec `reuseExisting`. Un appel simple à `create()` sans `force` se comporte de la même manière, car le serveur renvoie le fichier correspondant avant de rechercher le dossier.

### createMany

`createMany()` téléverse une liste de valeurs `DriveUploadInput` avec un parallélisme limité et renvoie un `MisskeyBatchResult` dans l’ordre des entrées :

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

- `concurrency` (2 par défaut) limite le nombre de téléversements parallèles.
- Une limitation de débit (HTTP 429) arrête le lancement de nouveaux téléversements et marque les entrées restantes `rateLimited` ; les téléversements en cours vont jusqu’à leur terme. Définissez `stopOnError: true` pour arrêter après toute erreur ; les entrées restantes sont ignorées avec `stoppedAfterError`.
- Avec `deduplicate`, chaque entrée est traitée comme avec `createDeduplicated()` selon la politique indiquée. Les entrées identiques d’un même lot forment une chaîne ordonnée : chaque entrée suivante attend la précédente (en occupant un worker) et utilise son résultat le plus récent selon la politique. Avec `moveExisting`, le fichier se retrouve dans le dossier de la dernière entrée. Le nom de fichier, le nom et le commentaire d’une entrée suivante sont ignorés, tandis que `isSensitive` ne peut que faire passer le fichier à `true`. Si l’entrée précédente échoue ou est ignorée, une entrée suivante déjà en cours est ignorée avec `dependencyFailed`. Avec `uploadAnyway`, chaque entrée est téléversée indépendamment.
- Sans `deduplicate`, le serveur peut tout de même renvoyer un fichier existant de même contenu, mais le résultat est signalé comme `uploaded`.
- `onProgress` reçoit un `DriveBatchUploadProgress` contenant le nombre d’éléments (`completedItems`, `succeededItems`, `failedItems`, `totalItems`) et la progression en octets (`sent`, `total`) de l’élément situé à `itemIndex`.
- Aucune nouvelle tentative n’est effectuée automatiquement. Une erreur réseau survenant après l’enregistrement du fichier par le serveur est signalée comme un échec. Une nouvelle exécution sans `deduplicate`, ou avec `reuseExisting` ou `moveExisting`, renvoie le fichier enregistré au lieu d’en créer un autre, car ces téléversements utilisent la déduplication côté serveur (`force: false`). Avec `uploadAnyway` (`force: true`), une nouvelle exécution peut créer des copies supplémentaires.
- Les octets d’entrée ne sont pas copiés ; ne les modifiez pas avant la fin du traitement par lots.

## Attendre la fin des téléversements par URL {#waiting-for-url-uploads}

`uploadFromUrl()` renvoie dès que le serveur accepte la requête ; le fichier apparaît ultérieurement. `uploadFromUrlAndWait()` attend également l’événement `urlUploadFinished` sur le canal de streaming `main` et renvoie le fichier obtenu. La méthode ne s’abonne pas et ne se connecte pas à votre place : abonnez-vous à `MisskeyStreamingChannel.main()` et connectez-vous au préalable :

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
  print('Upload did not finish in time (or failed on the server)');
}
```

- Le jeton doit disposer des autorisations `write:drive` et `read:account`.
- `mainSubscription` permet de sélectionner un abonnement `main` précis ; sinon, le premier abonnement enregistré dans `client.streaming.subscriptions` est utilisé. Un abonnement absent ou inactif, ou un client de streaming déconnecté, provoque une exception `StateError`.
- Le serveur n’envoie aucun événement en cas d’échec du téléversement ; celui-ci n’est donc détectable que par expiration du délai. L’expiration n’annule pas le téléversement côté serveur. Le délai `timeout` (2 minutes par défaut) commence après la fin de la requête de téléversement.
- Les événements reçus pendant la reconnexion sont perdus.
- Un `marker` unique est généré à chaque appel. Si vous en fournissez un, il doit être non vide et unique pour chaque téléversement.
- La déduplication côté serveur peut renvoyer un fichier existant situé dans un autre dossier.

Consultez [API Streaming](../streaming.md) pour les détails sur la connexion et les abonnements.

## Limites de débit {#rate-limits}

Limites par utilisateur définies par défaut par Misskey pour les points de terminaison utilisés par ces assistants :

| Point de terminaison | Limite | Utilisé par |
|---|---|---|
| `drive/folders/create` | 10 par heure | `getOrCreate()` |
| `drive/files/create` | 120 par heure | `createDeduplicated()`, `createMany()` |
| `drive/files/upload-from-url` | 60 par heure | `uploadFromUrlAndWait()` |
| Liste, `show`, `find`, `update`, `delete`, `move-bulk` | Aucune limite par point de terminaison | Tous les autres assistants |

Les facteurs de limitation de débit des rôles définis par l’administrateur du serveur modifient ces valeurs. Lorsqu’une limite est atteinte, les assistants à requête unique lèvent une `MisskeyRateLimitException` et les assistants par lots cessent de lancer de nouvelles opérations. Les opérations indépendantes non démarrées sont signalées comme `rateLimited` dans `createMany()`, dans la phase de déplacement des sous-dossiers de `dissolveFolder()` et dans les phases de suppression de `deleteFolderRecursive()`. Les groupes de `moveBulkAll()` utilisent `stoppedAfterError`, les opérations dépendantes peuvent être `dependencyFailed`, et une nouvelle tentative de suppression de dossier interrompue reste un échec.
