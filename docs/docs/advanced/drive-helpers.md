---
sidebar_position: 3
title: Drive Helpers
---

# Drive Helpers

The Drive helpers are higher-level methods that combine several Drive API calls into one operation: listing every page, walking the folder tree, moving or uploading many files, and deleting a folder with everything inside it. They live on the same facades as the plain endpoints (`client.drive`, `client.drive.files`, and `client.drive.folders`). See [Drive Upload](./drive-upload.md) for the single-request endpoints.

Because each helper sends several requests, none of them is atomic. Changes made on the server while a helper is running (by another client, for example) can be reflected in the result.

## Listing everything

Three helpers page through a listing for you and return a `Stream`:

| Method | Lists | Filters |
|---|---|---|
| `client.drive.files.listAll()` | Files in one folder (root when `folderId` is omitted) | `folderId`, `type` |
| `client.drive.folders.listAll()` | Folders in one parent folder (root when `folderId` is omitted) | `folderId` |
| `client.drive.streamAll()` | Files in all folders | `type` |

```dart
// Every image in a folder
await for (final file in client.drive.files.listAll(
  folderId: myFolderId,
  type: 'image/*',
)) {
  print('${file.name} (${file.size} bytes)');
}

// At most 500 files from the whole Drive
final recent = await client.drive.streamAll(maxItems: 500).toList();
```

### Newest-first ID order only

Results are always returned newest-first by ID. `listAll()` does not accept `sort`: the server applies the `untilId` cursor as an ID filter even when sorting by name or size, so pages would skip or repeat items. To get another order, collect the results and sort locally:

```dart
final files = await client.drive.files.listAll(folderId: myFolderId).toList();
files.sort((a, b) => b.size.compareTo(a.size)); // Largest first
```

### Page size and limits

- `pageSize` is the number of items requested per call (1–100, default 100).
- `maxItems` stops the stream after that many items. `0` sends no request.

Invalid values throw `ArgumentError` synchronously, when the method is called.

### Stream behavior

Each call returns a cold, single-subscription stream. No request is sent until you listen, and cancelling the subscription (or leaving an `await for` loop early) stops further page requests. API errors are delivered as stream errors after any items already yielded.

The listing is not a snapshot; files added, moved, or deleted during pagination may be missed or included.

### MIME type filter

`type` accepts only letters, `/`, `-`, and `*`. The server rejects values containing digits, so `video/mp4` fails; use a wildcard such as `video/*` and filter locally if you need an exact type:

```dart
final mp4s = await client.drive
    .streamAll(type: 'video/*')
    .where((file) => file.type == 'video/mp4')
    .toList();
```

## Batch results and cancellation

Once helpers that change many items have started making changes, the failure of an individual operation does not throw; it is recorded in a `MisskeyBatchResult<I, T>`, which holds one outcome per input, in input order. An error thrown by your own `onProgress` callback while reporting a settled item is different: new work stops and the error is rethrown after in-flight requests finish. Changes that already completed are not rolled back.

| Type | Meaning | Fields |
|---|---|---|
| `MisskeyBatchSuccess<I, T>` | The operation succeeded | `input`, `index`, `value` |
| `MisskeyBatchFailure<I, T>` | The operation threw | `input`, `index`, `error`, `stackTrace` |
| `MisskeyBatchSkipped<I, T>` | The operation was not started | `input`, `index`, `reason`, `cause` |

`MisskeyBatchSkipReason` tells you why an item was skipped:

| Value | Meaning |
|---|---|
| `cancelled` | Cancellation was requested |
| `rateLimited` | The server rate-limited a request (HTTP 429) in `createMany()`, `dissolveFolder()`, or `deleteFolderRecursive()` |
| `stoppedAfterError` | An earlier error stopped the batch (`createMany()` with `stopOnError`, or any failed chunk in `moveBulkAll()`, including a 429) |
| `dependencyFailed` | A prerequisite operation did not succeed (for example, dissolving after failed file moves, or deleting a folder whose contents were not deleted) |

The result also offers `successes`, `failures`, `skipped`, and `isComplete` (true when every item succeeded, including an empty batch). Because `MisskeyBatchItemResult` is sealed, a `switch` over its items is exhaustive:

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

### Cancellation

`createMany()` and `deleteFolderRecursive()` accept a `MisskeyCancellationToken`. Cancellation is cooperative: it prevents new work from starting, but in-flight requests are not aborted and are awaited to completion. Items that were not started are generally reported as skipped with `cancelled`. In `deleteFolderRecursive()`, a folder whose `HAS_CHILD_FILES_OR_FOLDERS` retry is interrupted is reported as a failure instead, because its deletion was already attempted.

```dart
final token = MisskeyCancellationToken();
final future = client.drive.files.createMany(inputs, cancellation: token);

// Later, for example when the user taps "Cancel"
token.cancel();

final result = await future;
print('Uploaded ${result.successes.length} of ${inputs.length}');
```

## Moving files in bulk

`moveBulkAll()` moves any number of files to one folder. Pass `null` for `folderId` (or omit it) to move them to the root.

```dart
final result = await client.drive.files.moveBulkAll(
  fileIds: selectedFileIds,
  folderId: targetFolderId,
);

if (!result.isComplete) {
  print('Not confirmed: ${result.unconfirmedFileIds}');
}
```

- Duplicate IDs are removed, and the remaining IDs are sent in sequential chunks of at most 100. Each chunk is one entry in `result.chunks`.
- Processing stops after the first failed chunk; later chunks are reported as skipped. `unconfirmedFileIds` lists the IDs in chunks that failed or were not started.
- When `folderId` is non-null, the destination folder is checked before anything is moved, because the server otherwise reports a missing folder as a generic 500 error. A failed check is thrown (for example a `MisskeyApiException` with code `NO_SUCH_FOLDER`) and no files are moved. A folder deleted after the check shows up as a failed chunk.
- A successful chunk means the server accepted it, not that every ID moved: the server silently ignores IDs that do not exist or belong to another user.
- An empty `fileIds` sends no request at all, not even the destination check.

This helper uses the `drive/files/move-bulk` endpoint, which requires Misskey 2025.5.1 or later. Older servers return their endpoint error as a failed chunk.

## Folder tree and usage summary

### Folder tree

`getTree()` returns an immutable `DriveFolderTree` of folders:

```dart
final tree = await client.drive.folders.getTree(maxDepth: 2);

for (final node in tree.nodes) {
  print('${'  ' * node.depth}${node.folder.name}');
}
print('${tree.folderCount} folders, truncated: ${tree.isTruncated}');
```

- It makes one or more list requests for every visited folder, so large trees are costly. `concurrency` (default 4) bounds parallel requests.
- Pass `rootFolderId` to start at a folder (available as `tree.rootNode`), or omit it to start at the Drive root.
- With `maxDepth`, folders at the limit are included but their children are not listed: `DriveFolderNode.childrenLoaded` is `false`, and `tree.isTruncated` is `true`. A truncated tree does not imply that deeper folders exist.
- It is read-only, so any request failure aborts the traversal and is thrown.

### Usage summary

`getUsageSummary()` scans the whole Drive and aggregates file counts and bytes per folder and per MIME type:

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

Each `DriveFolderUsage` has `direct` (files directly inside the folder) and `recursive` (the folder and all descendants) statistics. `summary.folderUsage(folderId)` looks up one folder.

- Cost: about one `drive/stream` request per 100 files, plus one folder listing per folder.
- It is not an atomic snapshot. Concurrent Drive changes can cause small inconsistencies; files in folders missing from the scanned tree are counted in `unassigned`.
- Linked files (uncached remote files with `isLink`) are included here but excluded from the server-reported usage, so `summary.total` can differ from `client.drive.stats.getCapacity()`.

## Resolving paths

### resolvePath

`resolvePath()` finds a folder by a list of folder names, one `folders/find` request per segment. It returns `null` when any segment is not found, including when `parentId` does not exist.

```dart
final folder = await client.drive.folders.resolvePath(['Photos', '2026', 'Trip']);
if (folder == null) {
  print('Not found');
}
```

Each list item is one complete folder name, so a name may itself contain `/`. An empty list, an empty segment, or a segment longer than 200 characters (Unicode code points) throws `ArgumentError` before any request.

### Same-named folders

Misskey allows sibling folders with the same name, and `folders/find` returns them in no guaranteed order. `onAmbiguous` selects the policy:

| `DriveFolderAmbiguityPolicy` | Behavior |
|---|---|
| `error` (default) | Throws `DriveFolderAmbiguousException` |
| `oldest` | Picks the earliest `createdAt`, then the lowest ID |
| `newest` | Picks the latest `createdAt`, then the highest ID |

`DriveFolderAmbiguousException` reports the ambiguous `name`, its `parentId`, the matching `candidates`, and the `segmentIndex`. It is not a subtype of `MisskeyClientException`, so catch it explicitly:

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}" at segment ${e.segmentIndex}');
}
```

### getOrCreate

`getOrCreate()` finds a folder by name under `parentId` (the root when omitted), or creates it when there is no match:

```dart
final result = await client.drive.folders.getOrCreate(
  name: 'Screenshots',
  parentId: photosFolderId,
  onAmbiguous: DriveFolderAmbiguityPolicy.oldest,
);
print('${result.folder.id} created: ${result.created}');
```

- It takes the same `onAmbiguous` policy as `resolvePath()`.
- It is not atomic: concurrent callers can each create a folder with the same name.
- `folders/create` is limited to 10 requests per hour. A `MisskeyRateLimitException` propagates.
- An empty name or a name longer than 200 characters throws `ArgumentError`. A nonexistent `parentId` finds nothing, and then the create request fails with `NO_SUCH_FOLDER` as a `MisskeyApiException`.

## Dissolving and deleting folders

### dissolveFolder

`dissolveFolder()` moves a folder's direct files and subfolders to its parent (or the root), then deletes the now-empty folder. Nothing is renamed; Misskey permits duplicate names.

```dart
final result = await client.drive.dissolveFolder(folderId: folderId);

if (!result.isComplete) {
  print('File moves complete: ${result.files.isComplete}');
  print('Subfolder moves complete: ${result.subfolders.isComplete}');
  print('Deletion: ${result.deletion}');
}
```

- If the folder, its contents, or the destination parent (checked when there are files to move) cannot be read, it throws before any change.
- Files are moved with `moveBulkAll()` (sequential chunks of 100, Misskey 2025.5.1 or later). Subfolders are moved in parallel, bounded by `concurrency` (default 4). If the file moves are not complete, subfolder moves and deletion are skipped.
- The source folder is deleted only when every move succeeds. An HTTP 429 stops new subfolder moves; the remaining subfolders are reported as `rateLimited` and deletion is skipped.
- Items added to the folder concurrently can make deletion fail with `HAS_CHILD_FILES_OR_FOLDERS`; this is reported in `result.deletion`.
- It is safe to run again after a partial result.

### deleteFolderRecursive

:::danger Irreversible
`deleteFolderRecursive()` permanently deletes a folder, every subfolder, and every file inside them. Deleted files cannot be restored. Notes and gallery posts that use a deleted file keep a dangling reference to it, and chat messages lose their attachment. Run it with `dryRun: true` first and check the plan.
:::

```dart
// 1. Inspect the plan without deleting anything
final preview = await client.drive.deleteFolderRecursive(
  folderId: folderId,
  dryRun: true,
);
final plan = preview.plan;
print('${plan.fileCount} files, ${plan.folderCount} folders, ${plan.totalBytes} bytes');

// 2. Delete
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

The operation runs in three phases (`DriveRecursiveDeletePhase`): `planning` loads the tree and its files without changing anything, `deletingFiles` deletes the planned files, and `deletingFolders` deletes folders deepest-first. Progress counts are per phase and include skipped items.

- **Planning failures throw** before anything is deleted. Once deletion starts, individual failures are returned in `result.files` and `result.folders`.
- **A dry run does not freeze the targets.** A later non-dry-run call builds a new plan, which may include items added in the meantime. Planned items are deleted even if they are moved elsewhere after planning.
- **Partial results:** a folder whose planned contents did not all succeed is not attempted, and neither are its ancestors. Files and folders that are already gone count as successfully deleted.
- **Rate limiting** stops new work.
- **Cancellation** is cooperative. Cancelling during planning stops unstarted file listings and returns every planned item as skipped with `cancelled`; no deletes are sent.
- **`HAS_CHILD_FILES_OR_FOLDERS` retries:** Misskey removes a file's database row only after responding to the delete request, so deleting its folder right away can fail with `HAS_CHILD_FILES_OR_FOLDERS`. Folders whose planned children were deleted retry this error with exponential backoff starting at 200 ms, for at most five attempts. Other write failures are not retried.
- If `onProgress` throws, unstarted work stops and the error is rethrown after in-flight work finishes. Earlier deletions cannot be rolled back.

## Uploading

### Preflight checks

`getUploadPreflight()` fetches the current user's role policies and Drive capacity (two requests, sent concurrently) so you can check files locally before uploading them:

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

Each `DriveUploadIssue` has a `severity`:

| Issue | Severity | Meaning |
|---|---|---|
| `DriveUploadFileTooLarge` | blocking | Exceeds the role's `maxFileSizeMb`, or the instance multipart limit when `instanceLimit` is `true` |
| `DriveUploadInsufficientCapacity` | blocking | Would exceed the remaining Drive capacity |
| `DriveUploadTypeNotAllowed` | advisory | The MIME type is not in the role's uploadable types. Advisory because the server detects the real type from the file content |
| `DriveUploadPoliciesUnavailable` | advisory | Some policy values were missing, so their checks were skipped |

`canUpload` is `false` only when a blocking issue is present.

- Moderators and administrators bypass role policy limits, so only the instance file-size check applies to them.
- When `meta` is omitted, no `/meta` request is made and the instance-wide file-size check is skipped.
- Use `checkAll()` to check several files in order; each file's size counts toward the capacity available to the next one.
- The result is advisory. Limits and usage can change after the snapshot, and the server can return an existing file with the same content before evaluating role policies, so policy issues can be false positives for duplicate content.

### createDeduplicated

When you upload content that already exists in your Drive, the server returns the existing file, but only after receiving the complete upload, and it ignores the requested `folderId`, `name`, and `comment`. `createDeduplicated()` looks up the MD5 first and avoids the transfer when a match exists:

```dart
final result = await client.drive.files.createDeduplicated(
  bytes: bytes,
  filename: 'photo.jpg',
  folderId: albumFolderId,
  onDuplicate: DriveDuplicatePolicy.moveExisting,
);

print('${result.file.id}: ${result.outcome.name}');
```

| `DriveDuplicatePolicy` | Behavior when a file with the same content exists |
|---|---|
| `reuseExisting` (default) | Returns the existing file without moving it |
| `moveExisting` | Moves the existing file to `folderId` if it is elsewhere |
| `uploadAnyway` | Skips the lookup and uploads another copy |

- `result.outcome` is `uploaded`, `reusedExisting`, or `movedExisting`. It is best-effort: a concurrent upload can win after the lookup, and such races are not always detectable.
- Existing files keep their name and comment. `isSensitive: true` upgrades an existing non-sensitive file.
- Pass `md5` (32 hexadecimal characters) to avoid hashing large inputs. Otherwise the hash is computed synchronously on the calling isolate (except with `uploadAnyway`).
- When an existing file matches, `folderId` is not validated, so a nonexistent or foreign folder does not cause an error with `reuseExisting`. A plain `create()` without `force` behaves the same way, because the server returns the match before looking up the folder.

### createMany

`createMany()` uploads a list of `DriveUploadInput` values with bounded concurrency and returns a `MisskeyBatchResult` in input order:

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

- `concurrency` (default 2) bounds parallel uploads.
- A rate limit (HTTP 429) stops new uploads and marks the remaining inputs as `rateLimited`; in-flight uploads finish. Set `stopOnError: true` to stop after any error; remaining inputs are skipped as `stoppedAfterError`.
- With `deduplicate`, each input is handled like `createDeduplicated()` with that policy. Identical inputs in the same batch form an ordered chain: each follower waits for its predecessor (occupying a worker) and uses its latest result according to the policy. With `moveExisting`, the file ends up in the last member's folder. A follower's filename, name, and comment are ignored, while `isSensitive` can only upgrade the file to `true`. If the predecessor fails or is skipped, a follower that is already running is skipped as `dependencyFailed`. With `uploadAnyway`, every input uploads independently.
- Without `deduplicate`, the server can still return an existing file with the same content, but it is reported as `uploaded`.
- `onProgress` receives a `DriveBatchUploadProgress` with item counts (`completedItems`, `succeededItems`, `failedItems`, `totalItems`) and the byte progress (`sent`, `total`) of the item at `itemIndex`.
- Nothing is retried automatically. A network failure after the server stored a file is reported as a failure. Rerunning without `deduplicate`, or with `reuseExisting` or `moveExisting`, returns the stored file instead of creating another, because these uploads use server-side deduplication (`force: false`). With `uploadAnyway` (`force: true`), a rerun can create additional copies.
- The input bytes are not copied; do not modify them until the batch completes.

## Waiting for URL uploads

`uploadFromUrl()` returns as soon as the server accepts the request, and the file appears later. `uploadFromUrlAndWait()` also waits for the `urlUploadFinished` event on the `main` streaming channel and returns the resulting file. It never subscribes or connects for you, so subscribe to `MisskeyStreamingChannel.main()` and connect first:

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

- The token needs the `write:drive` and `read:account` permissions.
- `mainSubscription` selects a specific main subscription; otherwise the first registered one in `client.streaming.subscriptions` is used. A missing or inactive subscription, or a disconnected streaming client, throws `StateError`.
- The server sends no event when the upload fails, so a failure is only visible as a timeout. A timeout does not cancel the server-side upload. `timeout` (default 2 minutes) starts after the upload request completes.
- Events that arrive while the connection is reconnecting are lost.
- A unique `marker` is generated for each call. If you pass your own, it must be non-empty and unique per upload.
- Server-side deduplication may return an existing file located in another folder.

See [Streaming API](../streaming.md) for connection and subscription details.

## Rate limits

Misskey's default per-user limits for the endpoints used by these helpers:

| Endpoint | Limit | Used by |
|---|---|---|
| `drive/folders/create` | 10 per hour | `getOrCreate()` |
| `drive/files/create` | 120 per hour | `createDeduplicated()`, `createMany()` |
| `drive/files/upload-from-url` | 60 per hour | `uploadFromUrlAndWait()` |
| Listing, `show`, `find`, `update`, `delete`, `move-bulk` | No per-endpoint limit | All other helpers |

Role rate-limit factors set by the server administrator scale these values. When a limit is hit, single-request helpers throw `MisskeyRateLimitException`, and batch helpers stop starting new work. `createMany()`, `dissolveFolder()`, and `deleteFolderRecursive()` report the remaining items as `rateLimited`.
