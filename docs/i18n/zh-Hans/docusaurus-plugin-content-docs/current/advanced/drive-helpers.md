---
sidebar_position: 3
title: 网盘辅助方法
---

# 网盘辅助方法

网盘辅助方法是将多个网盘 API 调用组合为一个操作的高级方法，提供遍历所有分页、遍历文件夹树、移动或上传多个文件，以及连同内容一起删除文件夹等功能。它们与普通端点位于相同的外观对象（`client.drive`、`client.drive.files` 和 `client.drive.folders`）上。单次请求即可完成的端点请参阅[网盘上传](./drive-upload.md)。

每个辅助方法都会发送多个请求，因此都不是原子操作。辅助方法运行期间服务器上发生的变更（例如由其他客户端进行的变更）可能会反映在结果中。

## 列出所有项目 {#listing-everything}

以下三个辅助方法会自动遍历列表的分页，并返回 `Stream`：

| 方法 | 列出内容 | 筛选条件 |
|---|---|---|
| `client.drive.files.listAll()` | 一个文件夹中的文件（省略 `folderId` 时为根目录） | `folderId`、`type` |
| `client.drive.folders.listAll()` | 一个父文件夹中的文件夹（省略 `folderId` 时为根目录） | `folderId` |
| `client.drive.streamAll()` | 所有文件夹中的文件 | `type` |

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

### 仅支持按 ID 从新到旧排序 {#newest-first-id-order-only}

结果始终按 ID 从新到旧返回。`listAll()` 不接受 `sort`：即使按名称或大小排序，服务器仍会将 `untilId` 游标作为 ID 筛选条件应用，因此分页可能漏掉或重复项目。如需其他顺序，请先收集结果，再在本地排序：

```dart
final files = await client.drive.files.listAll(folderId: myFolderId).toList();
files.sort((a, b) => b.size.compareTo(a.size)); // Largest first
```

### 页面大小和限制 {#page-size-and-limits}

- `pageSize` 是每次请求的项目数（1–100，默认值为 100）。
- `maxItems` 会在流达到指定项目数后停止。`0` 表示不发送请求。

传入无效值时，调用方法会同步抛出 `ArgumentError`。

### 流行为 {#stream-behavior}

每次调用都会返回一个冷的单订阅流。开始监听前不会发送请求；取消订阅（或提前退出 `await for` 循环）会停止后续分页请求。已输出项目之后发生的 API 错误会作为流错误传递。

列表不是快照；分页期间新增、移动或删除的文件可能会被遗漏，也可能会被包含在结果中。

### MIME 类型筛选 {#mime-type-filter}

`type` 仅接受字母、`/`、`-` 和 `*`。服务器会拒绝包含数字的值，因此 `video/mp4` 会失败；如果需要精确类型，请使用 `video/*` 之类的通配符，然后在本地筛选：

```dart
final mp4s = await client.drive
    .streamAll(type: 'video/*')
    .where((file) => file.type == 'video/mp4')
    .toList();
```

## 批量结果和取消 {#batch-results-and-cancellation}

更改多个项目的辅助方法在开始更改后不会抛出异常，而是返回 `MisskeyBatchResult<I, T>`，其中每个输入都有一个结果，顺序与输入一致：

| 类型 | 含义 | 字段 |
|---|---|---|
| `MisskeyBatchSuccess<I, T>` | 操作成功 | `input`、`index`、`value` |
| `MisskeyBatchFailure<I, T>` | 操作抛出异常 | `input`、`index`、`error`、`stackTrace` |
| `MisskeyBatchSkipped<I, T>` | 操作未启动 | `input`、`index`、`reason`、`cause` |

`MisskeyBatchSkipReason` 用于说明项目被跳过的原因：

| 值 | 含义 |
|---|---|
| `cancelled` | 已请求取消 |
| `rateLimited` | 服务器对请求实施了频率限制 |
| `stoppedAfterError` | 批处理因先前的错误而停止 |
| `dependencyFailed` | 前置操作未成功 |

结果还提供 `successes`、`failures`、`skipped` 和 `isComplete`（所有项目均成功时为 true，包括空批次）。由于 `MisskeyBatchItemResult` 是 sealed 类型，对其项目使用 `switch` 时可以穷举所有情况：

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

### 取消 {#cancellation}

`createMany()` 和 `deleteFolderRecursive()` 接受 `MisskeyCancellationToken`。取消采用协作式机制：阻止启动新工作，但不会中止正在进行的请求，并会等待其完成。尚未启动的项目会以 `cancelled` 原因报告为已跳过。

```dart
final token = MisskeyCancellationToken();
final future = client.drive.files.createMany(inputs, cancellation: token);

// Later, for example when the user taps "Cancel"
token.cancel();

final result = await future;
print('Uploaded ${result.successes.length} of ${inputs.length}');
```

## 批量移动文件 {#moving-files-in-bulk}

`moveBulkAll()` 可将任意数量的文件移动到一个文件夹。将 `null` 传给 `folderId`（或省略该参数）即可移动到根目录。

```dart
final result = await client.drive.files.moveBulkAll(
  fileIds: selectedFileIds,
  folderId: targetFolderId,
);

if (!result.isComplete) {
  print('Not confirmed: ${result.unconfirmedFileIds}');
}
```

- 重复 ID 会被移除，其余 ID 按最多 100 个一组依次发送。每个分组对应 `result.chunks` 中的一个条目。
- 第一个分组失败后处理即停止；后续分组会报告为已跳过。`unconfirmedFileIds` 列出失败或尚未开始的分组中的 ID。
- `folderId` 非 null 时，会在移动任何内容前检查目标文件夹，因为否则服务器会将不存在的文件夹报告为通用 500 错误。检查失败时会抛出异常（例如代码为 `NO_SUCH_FOLDER` 的 `MisskeyApiException`），且不会移动任何文件。检查后被删除的文件夹会显示为失败的分组。
- 分组成功表示服务器已接受请求，并不意味着每个 ID 都已移动：服务器会静默忽略不存在或属于其他用户的 ID。
- `fileIds` 为空时完全不会发送请求，甚至不会检查目标文件夹。

此辅助方法使用 `drive/files/move-bulk` 端点，需要 Misskey 2025.5.1 或更高版本。较旧的服务器会将端点错误作为失败分组返回。

## 文件夹树和用量汇总 {#folder-tree-and-usage-summary}

### 文件夹树 {#folder-tree}

`getTree()` 返回一个不可变的文件夹 `DriveFolderTree`：

```dart
final tree = await client.drive.folders.getTree(maxDepth: 2);

for (final node in tree.nodes) {
  print('${'  ' * node.depth}${node.folder.name}');
}
print('${tree.folderCount} folders, truncated: ${tree.isTruncated}');
```

- 每个访问过的文件夹都会触发一个或多个列表请求，因此大型树的开销较高。`concurrency`（默认值为 4）限制并行请求数。
- 传入 `rootFolderId` 可从指定文件夹开始（可通过 `tree.rootNode` 获取），省略则从网盘根目录开始。
- 设置 `maxDepth` 后，会包含深度达到上限的文件夹，但不会列出其子项：`DriveFolderNode.childrenLoaded` 为 `false`，且 `tree.isTruncated` 为 `true`。树被截断并不代表更深处一定存在文件夹。
- 此操作只读，因此任何请求失败都会中止遍历并抛出异常。

### 用量汇总 {#usage-summary}

`getUsageSummary()` 会扫描整个网盘，并按文件夹和 MIME 类型汇总文件数与字节数：

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

每个 `DriveFolderUsage` 都包含 `direct`（文件夹直接包含的文件）和 `recursive`（该文件夹及其所有后代）的统计信息。`summary.folderUsage(folderId)` 可查询一个文件夹。

- 开销：每 100 个文件大约需要一个 `drive/stream` 请求，此外每个文件夹需要一次文件夹列表请求。
- 它不是原子快照。并发网盘变更可能造成轻微不一致；扫描到的树中不存在的文件夹里的文件会计入 `unassigned`。
- 链接文件（未缓存的远程文件，带有 `isLink`）会计入这里的用量，但不会计入服务器报告的用量，因此 `summary.total` 可能与 `client.drive.stats.getCapacity()` 不同。

## 解析路径 {#resolving-paths}

### resolvePath

`resolvePath()` 根据文件夹名称列表查找文件夹，每个路径段发送一次 `folders/find` 请求。任意路径段未找到时都会返回 `null`，包括 `parentId` 不存在的情况。

```dart
final folder = await client.drive.folders.resolvePath(['Photos', '2026', 'Trip']);
if (folder == null) {
  print('Not found');
}
```

列表中的每一项都是一个完整的文件夹名称，因此名称本身可以包含 `/`。空列表、空路径段或超过 200 个字符（Unicode 码点）的路径段都会在发送任何请求前抛出 `ArgumentError`。

### 同名文件夹 {#same-named-folders}

Misskey 允许同级文件夹使用相同名称，而 `folders/find` 返回它们时顺序不确定。`onAmbiguous` 用于选择处理策略：

| `DriveFolderAmbiguityPolicy` | 行为 |
|---|---|
| `error`（默认） | 抛出 `DriveFolderAmbiguousException` |
| `oldest` | 选择 `createdAt` 最早的文件夹，其次选择 ID 最小的文件夹 |
| `newest` | 选择 `createdAt` 最晚的文件夹，其次选择 ID 最大的文件夹 |

`DriveFolderAmbiguousException` 会报告有歧义的 `name`、其 `parentId`、匹配的 `candidates` 以及 `segmentIndex`。它不是 `MisskeyClientException` 的子类型，因此需要显式捕获：

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}" at segment ${e.segmentIndex}');
}
```

### getOrCreate

`getOrCreate()` 会在 `parentId` 下按名称查找文件夹（省略时为根目录），如果没有匹配项则创建文件夹：

```dart
final result = await client.drive.folders.getOrCreate(
  name: 'Screenshots',
  parentId: photosFolderId,
  onAmbiguous: DriveFolderAmbiguityPolicy.oldest,
);
print('${result.folder.id} created: ${result.created}');
```

- 它接受与 `resolvePath()` 相同的 `onAmbiguous` 策略。
- 此操作不是原子的：并发调用者可能分别创建同名文件夹。
- `folders/create` 每小时最多 10 次请求。`MisskeyRateLimitException` 会向上传播。
- 名称为空或超过 200 个字符时会抛出 `ArgumentError`。如果 `parentId` 不存在，则查找不到文件夹，随后创建请求会以 `NO_SUCH_FOLDER` 的 `MisskeyApiException` 失败。

## 解散和删除文件夹 {#dissolving-and-deleting-folders}

### dissolveFolder

`dissolveFolder()` 会将文件夹直接包含的文件和子文件夹移动到其父文件夹（或根目录），然后删除已清空的文件夹。不会重命名任何内容；Misskey 允许名称重复。

```dart
final result = await client.drive.dissolveFolder(folderId: folderId);

if (!result.isComplete) {
  print('File moves complete: ${result.files.isComplete}');
  print('Subfolder moves complete: ${result.subfolders.isComplete}');
  print('Deletion: ${result.deletion}');
}
```

- 如果无法读取文件夹、其内容或目标父文件夹（有文件需要移动时才会检查），会在任何变更发生前抛出异常。
- 文件通过 `moveBulkAll()` 移动（每 100 个一组顺序处理，需要 Misskey 2025.5.1 或更高版本）。子文件夹会并行移动，并受 `concurrency`（默认值为 4）限制。如果文件移动未全部完成，则会跳过子文件夹移动和删除。
- 只有所有移动都成功时才会删除源文件夹。HTTP 429 会停止启动新的子文件夹移动；其余子文件夹会报告为 `rateLimited`，并跳过删除。
- 并发添加到文件夹的项目可能导致删除因 `HAS_CHILD_FILES_OR_FOLDERS` 失败；此情况会记录在 `result.deletion` 中。
- 部分完成后可以安全地再次运行。

### deleteFolderRecursive

:::danger 不可逆操作
`deleteFolderRecursive()` 会永久删除文件夹、所有子文件夹以及其中的所有文件。已删除的文件无法恢复。使用已删除文件的帖子和图库帖子会保留指向该文件的失效引用，聊天消息则会失去附件。请先使用 `dryRun: true` 运行并检查计划。
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

该操作分三个阶段（`DriveRecursiveDeletePhase`）运行：`planning` 会加载文件夹树及其文件，不做任何更改；`deletingFiles` 会删除计划中的文件；`deletingFolders` 会从最深层开始删除文件夹。进度计数按阶段计算，并包含已跳过的项目。

- **规划失败会抛出异常**，且不会删除任何内容。开始删除后，各项失败会返回在 `result.files` 和 `result.folders` 中。
- **试运行不会冻结目标。** 随后不带 `dryRun` 再次调用时会生成新计划，可能包含期间新增的项目。即使计划中的项目在规划后被移动到其他位置，也会被删除。
- **部分结果：** 计划内容未全部成功处理的文件夹不会尝试删除，其祖先也不会尝试删除。已经不存在的文件和文件夹会视为删除成功。
- **频率限制**会停止启动新工作。
- **取消**采用协作式机制。规划期间取消会停止尚未开始的文件列表请求，并将每个计划项目作为 `cancelled` 跳过返回；不会发送删除请求。
- **`HAS_CHILD_FILES_OR_FOLDERS` 重试：** Misskey 会在响应删除请求后才移除文件的数据库行，因此紧接着删除其文件夹可能会因 `HAS_CHILD_FILES_OR_FOLDERS` 失败。计划中的子项已删除的文件夹会对此错误进行重试，采用从 200 毫秒开始的指数退避，最多尝试五次。其他写入失败不会重试。
- 如果 `onProgress` 抛出异常，则会停止尚未开始的工作，待正在进行的工作完成后重新抛出异常。此前的删除无法回滚。

## 上传 {#uploading}

### 上传前检查 {#preflight-checks}

`getUploadPreflight()` 会获取当前用户的角色策略和网盘容量（并发发送两个请求），以便在上传前于本地检查文件：

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

每个 `DriveUploadIssue` 都有一个 `severity`：

| 问题 | 严重程度 | 含义 |
|---|---|---|
| `DriveUploadFileTooLarge` | blocking | 超过角色的 `maxFileSizeMb`；如果 `instanceLimit` 为 `true`，则表示超过实例的 multipart 限制 |
| `DriveUploadInsufficientCapacity` | blocking | 会超出网盘剩余容量 |
| `DriveUploadTypeNotAllowed` | advisory | MIME 类型不在角色允许上传的类型中。此项仅供参考，因为服务器会从文件内容检测实际类型 |
| `DriveUploadPoliciesUnavailable` | advisory | 缺少部分策略值，因此跳过了相应检查 |

只有存在 blocking 问题时，`canUpload` 才会是 `false`。

- 版主和管理员不受角色策略限制，因此仅应用实例文件大小检查。
- 省略 `meta` 时不会发送 `/meta` 请求，也会跳过实例范围的文件大小检查。
- 使用 `checkAll()` 可按顺序检查多个文件；每个文件的大小都会从下一个文件可用的容量中扣除。
- 结果仅供参考。快照之后限制和用量可能变化；服务器也可能在评估角色策略前返回内容相同的已有文件，因此重复内容可能导致策略问题被误报。

### createDeduplicated

上传网盘中已有的内容时，服务器会返回已有文件，但要等到完整接收上传内容后才会返回，并且会忽略指定的 `folderId`、`name` 和 `comment`。`createDeduplicated()` 会先查找 MD5，有匹配项时即可避免传输：

```dart
final result = await client.drive.files.createDeduplicated(
  bytes: bytes,
  filename: 'photo.jpg',
  folderId: albumFolderId,
  onDuplicate: DriveDuplicatePolicy.moveExisting,
);

print('${result.file.id}: ${result.outcome.name}');
```

| `DriveDuplicatePolicy` | 存在内容相同的文件时的行为 |
|---|---|
| `reuseExisting`（默认值） | 返回已有文件，不移动它 |
| `moveExisting` | 如果已有文件位于其他位置，则将它移动到 `folderId` |
| `uploadAnyway` | 跳过查找并上传另一个副本 |

- `result.outcome` 为 `uploaded`、`reusedExisting` 或 `movedExisting`。这是尽力而为的结果：查找后并发上传可能先完成，这类竞争不一定都能检测到。
- 已有文件会保留其名称和备注。`isSensitive: true` 会将已有的非敏感文件升级为敏感文件。
- 传入 `md5`（32 个十六进制字符）可避免对大型输入进行哈希计算。否则会在调用方 isolate 上同步计算哈希（`uploadAnyway` 除外）。
- 使用 `reuseExisting` 时，如果找到匹配文件，就不会验证 `folderId`；普通上传则会因文件夹不存在或属于其他用户而失败。

### createMany

`createMany()` 会以受限并发上传一组 `DriveUploadInput`，并按输入顺序返回 `MisskeyBatchResult`：

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

- `concurrency`（默认值为 2）限制并行上传数。
- 触发频率限制（HTTP 429）时会停止启动新上传，并将剩余输入标记为 `rateLimited`；正在进行的上传会继续完成。设置 `stopOnError: true` 可在发生任何错误后停止，剩余输入会以 `stoppedAfterError` 跳过。
- 设置 `deduplicate` 后，每个输入都会按照对应策略执行 `createDeduplicated()`。同一批次中内容相同的输入会形成有序链：每个后续项都会等待其前一项（等待期间会占用一个工作线程），并根据策略使用前一项的最新结果。采用 `moveExisting` 时，文件最终位于最后一个输入指定的文件夹。后续项的文件名、名称和备注会被忽略，而 `isSensitive` 只能将文件升级为 `true`。如果前一项失败或被跳过，已经运行的后续项会以 `dependencyFailed` 跳过。使用 `uploadAnyway` 时，每个输入都会独立上传。
- 不设置 `deduplicate` 时，服务器仍可能返回内容相同的已有文件，但它会报告为 `uploaded`。
- `onProgress` 会收到 `DriveBatchUploadProgress`，其中包含项目计数（`completedItems`、`succeededItems`、`failedItems`、`totalItems`），以及 `itemIndex` 对应项目的字节进度（`sent`、`total`）。
- 不会自动重试。服务器存储文件后发生的网络故障会报告为失败；由于服务器端去重，重新运行是安全的。
- 输入字节不会被复制；批次完成前请勿修改。

## 等待 URL 上传完成 {#waiting-for-url-uploads}

`uploadFromUrl()` 会在服务器接受请求后立即返回，文件稍后才会出现。`uploadFromUrlAndWait()` 还会等待 `main` 流式频道中的 `urlUploadFinished` 事件，并返回生成的文件。它不会替你订阅或连接，因此请先订阅 `MisskeyStreamingChannel.main()` 并连接：

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

- 令牌需要 `write:drive` 和 `read:account` 权限。
- `mainSubscription` 可指定某个 main 订阅；否则会使用 `client.streaming.subscriptions` 中最先注册的订阅。订阅不存在、未激活或流式客户端尚未连接时会抛出 `StateError`。
- 上传失败时服务器不会发送事件，因此只能通过超时发现失败。超时不会取消服务器端的上传。`timeout`（默认值为 2 分钟）从上传请求完成后开始计时。
- 连接重连期间到达的事件会丢失。
- 每次调用都会生成唯一的 `marker`。如果自行传入，该值必须非空且在每次上传中唯一。
- 服务器端去重可能会返回位于其他文件夹中的已有文件。

连接和订阅的详细信息请参阅 [Streaming API](../streaming.md)。

## 频率限制 {#rate-limits}

Misskey 对这些辅助方法使用的端点设置的默认单用户限制如下：

| 端点 | 限制 | 使用方 |
|---|---|---|
| `drive/folders/create` | 每小时 10 次 | `getOrCreate()` |
| `drive/files/create` | 每小时 120 次 | `createDeduplicated()`、`createMany()` |
| `drive/files/upload-from-url` | 每小时 60 次 | `uploadFromUrlAndWait()` |
| 列表、`show`、`find`、`update`、`delete`、`move-bulk` | 每个端点无单独限制 | 其他所有辅助方法 |

服务器管理员设置的角色频率限制系数会按比例调整这些值。达到限制时，单请求辅助方法会抛出 `MisskeyRateLimitException`，批量辅助方法会停止启动新工作，并将剩余项目报告为 `rateLimited`。
