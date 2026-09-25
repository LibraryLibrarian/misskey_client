---
sidebar_position: 3
title: ドライブヘルパー
---

# ドライブヘルパー

ドライブヘルパーは、複数のドライブ API 呼び出しを1つの操作にまとめた高レベルのメソッドです。全ページの取得、フォルダツリーの走査、多数のファイルの移動やアップロード、フォルダを中身ごと削除する操作を提供します。ヘルパーは通常のエンドポイントと同じファサード（`client.drive`、`client.drive.files`、`client.drive.folders`）に用意されています。1回のリクエストで完結するエンドポイントについては[ドライブアップロード](./drive-upload.md)を参照してください。

各ヘルパーは複数のリクエストを送信するため、いずれもアトミックではありません。ヘルパーの実行中にサーバー上で行われた変更（別のクライアントによる変更など）が結果に反映される場合があります。

## すべての項目を取得する {#listing-everything}

次の3つのヘルパーは一覧をページ送りしながら取得し、`Stream` として返します。

| メソッド | 取得対象 | フィルター |
|---|---|---|
| `client.drive.files.listAll()` | 1つのフォルダ内のファイル（`folderId` を省略した場合はルート） | `folderId`、`type` |
| `client.drive.folders.listAll()` | 1つの親フォルダ内のフォルダ（`folderId` を省略した場合はルート） | `folderId` |
| `client.drive.streamAll()` | すべてのフォルダ内のファイル | `type` |

```dart
// フォルダ内のすべての画像
await for (final file in client.drive.files.listAll(
  folderId: myFolderId,
  type: 'image/*',
)) {
  print('${file.name} (${file.size} bytes)');
}

// ドライブ全体から最大500件のファイル
final recent = await client.drive.streamAll(maxItems: 500).toList();
```

### ID の新しい順のみ {#newest-first-id-order-only}

結果は常に ID の新しい順で返されます。`listAll()` は `sort` を受け付けません。サーバーは名前やサイズでソートする場合でも `untilId` カーソルを ID によるフィルターとして適用するため、ページ間で項目が抜けたり重複したりするからです。別の順序が必要な場合は、結果を集めてからローカルでソートしてください。

```dart
final files = await client.drive.files.listAll(folderId: myFolderId).toList();
files.sort((a, b) => b.size.compareTo(a.size)); // 大きい順
```

### ページサイズと上限 {#page-size-and-limits}

- `pageSize` は1回の呼び出しで要求する件数です（1〜100、デフォルトは100）。
- `maxItems` を指定すると、その件数に達した時点でストリームを終了します。`0` の場合はリクエストを送信しません。

不正な値を指定すると、メソッドを呼び出した時点で同期的に `ArgumentError` がスローされます。

### ストリームの動作 {#stream-behavior}

各呼び出しは cold な単一購読ストリームを返します。listen するまでリクエストは送信されず、購読をキャンセルする（または `await for` ループを途中で抜ける）と以降のページのリクエストは停止します。API エラーは、それまでに出力された項目の後にストリームのエラーとして通知されます。

一覧はスナップショットではありません。ページ送りの途中で追加・移動・削除されたファイルは、取りこぼされたり含まれたりする場合があります。

### MIME タイプフィルター {#mime-type-filter}

`type` には英字、`/`、`-`、`*` のみを指定できます。サーバーは数字を含む値を拒否するため、`video/mp4` は失敗します。厳密なタイプで絞り込みたい場合は `video/*` のようなワイルドカードを指定し、ローカルでフィルタリングしてください。

```dart
final mp4s = await client.drive
    .streamAll(type: 'video/*')
    .where((file) => file.type == 'video/mp4')
    .toList();
```

## バッチ結果とキャンセル {#batch-results-and-cancellation}

多数の項目を変更するヘルパーでは、変更を開始した後に個々の操作が失敗しても例外はスローされず、その失敗は `MisskeyBatchResult<I, T>` に記録されます。`MisskeyBatchResult<I, T>` は入力ごとに1つの結果を入力順に保持します。ただし、完了した項目を通知している最中に独自の `onProgress` コールバックが例外をスローした場合は扱いが異なります。新しい処理を停止し、実行中のリクエストが終わった後でそのエラーが再スローされます。すでに完了した変更はロールバックされません。

| 型 | 意味 | フィールド |
|---|---|---|
| `MisskeyBatchSuccess<I, T>` | 操作が成功した | `input`、`index`、`value` |
| `MisskeyBatchFailure<I, T>` | 操作が例外をスローした | `input`、`index`、`error`、`stackTrace` |
| `MisskeyBatchSkipped<I, T>` | 操作が開始されなかった | `input`、`index`、`reason`、`cause` |

`MisskeyBatchSkipReason` は項目がスキップされた理由を示します。

| 値 | 意味 |
|---|---|
| `cancelled` | キャンセルが要求された |
| `rateLimited` | `createMany()`、`dissolveFolder()`、`deleteFolderRecursive()` でサーバーがリクエストをレート制限した（HTTP 429） |
| `stoppedAfterError` | 先行するエラーによってバッチが停止した（`stopOnError` を指定した `createMany()`、または 429 を含む `moveBulkAll()` のチャンクの失敗） |
| `dependencyFailed` | 前提となる操作が成功しなかった（たとえばファイルの移動に失敗した後の解体や、中身を削除できなかったフォルダの削除） |

結果には `successes`、`failures`、`skipped`、`isComplete`（すべての項目が成功した場合に true。空のバッチも含む）も用意されています。`MisskeyBatchItemResult` は sealed なので、その項目に対する `switch` は網羅的になります。

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

### キャンセル {#cancellation}

`createMany()` と `deleteFolderRecursive()` は `MisskeyCancellationToken` を受け付けます。キャンセルは協調的です。新しい処理の開始は止めますが、実行中のリクエストは中断されず、完了まで待機されます。開始されなかった項目は、原則として `cancelled` としてスキップ扱いで報告されます。`deleteFolderRecursive()` では、`HAS_CHILD_FILES_OR_FOLDERS` のリトライが中断されたフォルダは、すでに削除を試行しているため失敗として報告されます。

```dart
final token = MisskeyCancellationToken();
final future = client.drive.files.createMany(inputs, cancellation: token);

// 後で、たとえばユーザーが「キャンセル」をタップしたとき
token.cancel();

final result = await future;
print('Uploaded ${result.successes.length} of ${inputs.length}');
```

## ファイルの一括移動 {#moving-files-in-bulk}

`moveBulkAll()` は任意の数のファイルを1つのフォルダへ移動します。ルートへ移動する場合は `folderId` に `null` を渡してください（省略しても同じです）。

```dart
final result = await client.drive.files.moveBulkAll(
  fileIds: selectedFileIds,
  folderId: targetFolderId,
);

if (!result.isComplete) {
  print('Not confirmed: ${result.unconfirmedFileIds}');
}
```

- 重複した ID は取り除かれ、残りの ID は最大100件ずつのチャンクに分けて順番に送信されます。各チャンクは `result.chunks` の1要素になります。
- 最初に失敗したチャンクの後で処理は停止し、以降のチャンクはスキップとして報告されます。`unconfirmedFileIds` には、失敗したチャンクまたは開始されなかったチャンクに含まれる ID が列挙されます。
- `folderId` が null でない場合、移動を行う前に移動先フォルダを確認します。確認しないと、サーバーは存在しないフォルダを汎用的な500エラーとして報告するためです。確認に失敗した場合は例外がスローされ（たとえばコード `NO_SUCH_FOLDER` の `MisskeyApiException`）、ファイルは移動されません。確認後にフォルダが削除された場合は、失敗したチャンクとして現れます。
- チャンクの成功はサーバーがそのチャンクを受け付けたことを意味し、すべての ID が移動されたことを意味するわけではありません。サーバーは存在しない ID や他のユーザーに属する ID を通知なく無視します。
- `fileIds` が空の場合は、移動先の確認も含めてリクエストを一切送信しません。

このヘルパーは `drive/files/move-bulk` エンドポイントを使用するため、Misskey 2025.5.1 以降が必要です。それより古いサーバーでは、エンドポイントのエラーが失敗したチャンクとして返されます。

## フォルダツリーと使用量の集計 {#folder-tree-and-usage-summary}

### フォルダツリー {#folder-tree}

`getTree()` はフォルダの変更不可能な `DriveFolderTree` を返します。

```dart
final tree = await client.drive.folders.getTree(maxDepth: 2);

for (final node in tree.nodes) {
  print('${'  ' * node.depth}${node.folder.name}');
}
print('${tree.folderCount} folders, truncated: ${tree.isTruncated}');
```

- 訪れたフォルダごとに1回以上の一覧リクエストを送信するため、大きなツリーではコストがかかります。`concurrency`（デフォルトは4）で並列リクエスト数を制限します。
- `rootFolderId` を渡すとそのフォルダから開始し（`tree.rootNode` で参照できます）、省略するとドライブのルートから開始します。
- `maxDepth` を指定すると、上限の深さにあるフォルダは含まれますが、その子は取得されません。この場合 `DriveFolderNode.childrenLoaded` は `false`、`tree.isTruncated` は `true` になります。ツリーが切り詰められていても、より深いフォルダが存在するとは限りません。
- 読み取り専用の操作であるため、リクエストが1つでも失敗すると走査を中止して例外をスローします。

### 使用量の集計 {#usage-summary}

`getUsageSummary()` はドライブ全体を走査し、フォルダごと・MIME タイプごとにファイル数とバイト数を集計します。

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

各 `DriveFolderUsage` には、`direct`（フォルダの直下にあるファイル）と `recursive`（フォルダとそのすべての子孫）の統計があります。`summary.folderUsage(folderId)` で1つのフォルダを参照できます。

- コスト: ファイル100件あたり約1回の `drive/stream` リクエストに加え、フォルダごとに1回のフォルダ一覧リクエストが必要です。
- アトミックなスナップショットではありません。同時に行われたドライブの変更によって小さな不整合が生じる場合があります。走査したツリーに存在しないフォルダ内のファイルは `unassigned` に計上されます。
- リンクファイル（`isLink` を持つ、キャッシュされていないリモートファイル）はここでは集計に含まれますが、サーバーが報告する使用量からは除外されます。そのため `summary.total` は `client.drive.stats.getCapacity()` と一致しない場合があります。

## パスの解決 {#resolving-paths}

### resolvePath

`resolvePath()` はフォルダ名のリストからフォルダを探します。セグメントごとに1回の `folders/find` リクエストを送信します。いずれかのセグメントが見つからない場合は `null` を返します。`parentId` が存在しない場合も同様です。

```dart
final folder = await client.drive.folders.resolvePath(['Photos', '2026', 'Trip']);
if (folder == null) {
  print('Not found');
}
```

リストの各要素は1つの完全なフォルダ名であるため、名前自体に `/` を含めることができます。空のリスト、空のセグメント、または200文字（Unicode コードポイント）を超えるセグメントを指定すると、リクエストを送信する前に `ArgumentError` がスローされます。

### 同名のフォルダ {#same-named-folders}

Misskey では同じ階層に同名のフォルダを作成でき、`folders/find` はそれらを順序の保証なしに返します。`onAmbiguous` でポリシーを選択します。

| `DriveFolderAmbiguityPolicy` | 動作 |
|---|---|
| `error`（デフォルト） | `DriveFolderAmbiguousException` をスローする |
| `oldest` | `createdAt` が最も早いもの、次に ID が最も小さいものを選ぶ |
| `newest` | `createdAt` が最も遅いもの、次に ID が最も大きいものを選ぶ |

`DriveFolderAmbiguousException` は、曖昧な `name`、その `parentId`、一致した `candidates`、`segmentIndex` を保持します。`MisskeyClientException` のサブタイプではないため、明示的に catch してください。

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}" at segment ${e.segmentIndex}');
}
```

### getOrCreate

`getOrCreate()` は `parentId`（省略した場合はルート）の下で名前によってフォルダを探し、一致するものがなければ作成します。

```dart
final result = await client.drive.folders.getOrCreate(
  name: 'Screenshots',
  parentId: photosFolderId,
  onAmbiguous: DriveFolderAmbiguityPolicy.oldest,
);
print('${result.folder.id} created: ${result.created}');
```

- `resolvePath()` と同じ `onAmbiguous` ポリシーを受け付けます。
- アトミックではありません。同時に呼び出すと、それぞれが同名のフォルダを作成する場合があります。
- `folders/create` は1時間あたり10リクエストに制限されています。`MisskeyRateLimitException` はそのまま伝播します。
- 空の名前または200文字を超える名前を指定すると `ArgumentError` がスローされます。存在しない `parentId` を指定した場合は何も見つからず、その後の作成リクエストが `NO_SUCH_FOLDER` の `MisskeyApiException` で失敗します。

## フォルダの解体と削除 {#dissolving-and-deleting-folders}

### dissolveFolder

`dissolveFolder()` はフォルダの直下にあるファイルとサブフォルダを親フォルダ（またはルート）へ移動し、空になったフォルダを削除します。名前の変更は行いません。Misskey では重複した名前が許可されています。

```dart
final result = await client.drive.dissolveFolder(folderId: folderId);

if (!result.isComplete) {
  print('File moves complete: ${result.files.isComplete}');
  print('Subfolder moves complete: ${result.subfolders.isComplete}');
  print('Deletion: ${result.deletion}');
}
```

- フォルダ、その中身、または移動先の親フォルダ（移動するファイルがある場合に確認）を読み取れない場合は、変更を行う前に例外をスローします。
- ファイルは `moveBulkAll()` で移動されます（100件ずつの順次チャンク、Misskey 2025.5.1 以降）。サブフォルダは `concurrency`（デフォルトは4）を上限として並列に移動されます。ファイルの移動が完了しなかった場合、サブフォルダの移動と削除はスキップされます。
- 元のフォルダは、すべての移動が成功した場合にのみ削除されます。HTTP 429 を受けると新しいサブフォルダの移動を停止し、残りのサブフォルダは `rateLimited` として報告され、削除はスキップされます。
- 同時にフォルダへ項目が追加されると、削除が `HAS_CHILD_FILES_OR_FOLDERS` で失敗する場合があります。これは `result.deletion` で報告されます。
- 結果が部分的だった場合でも、再実行して問題ありません。

### deleteFolderRecursive

:::danger 元に戻せません

`deleteFolderRecursive()` はフォルダ、すべてのサブフォルダ、およびそれらに含まれるすべてのファイルを完全に削除します。削除したファイルは復元できません。削除されたファイルを使用しているノートやギャラリー投稿には、そのファイルへの無効な参照が残り、チャットメッセージからは添付ファイルが失われます。まず `dryRun: true` で実行し、計画を確認してください。

:::

```dart
// 1. 何も削除せずに計画を確認する
final preview = await client.drive.deleteFolderRecursive(
  folderId: folderId,
  dryRun: true,
);
final plan = preview.plan;
print('${plan.fileCount} files, ${plan.folderCount} folders, ${plan.totalBytes} bytes');

// 2. 削除する
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

この操作は3つのフェーズ（`DriveRecursiveDeletePhase`）で実行されます。`planning` は何も変更せずにツリーとそのファイルを読み込み、`deletingFiles` は計画したファイルを削除し、`deletingFolders` は深い階層のフォルダから順に削除します。進捗の件数はフェーズごとに数えられ、スキップした項目も含みます。

- **計画段階の失敗は例外としてスローされ**、何も削除されません。削除を開始した後の個々の失敗は `result.files` と `result.folders` で返されます。
- **ドライランは対象を固定しません。** 後から `dryRun` を指定せずに呼び出すと新しい計画が作成されるため、その間に追加された項目が含まれる場合があります。計画された項目は、計画後に別の場所へ移動された場合でも削除されます。
- **部分的な結果:** 計画した中身がすべて成功しなかったフォルダは削除を試行せず、その祖先フォルダも同様です。すでに存在しないファイルやフォルダは削除に成功したものとして扱われます。
- **レート制限**を受けると新しい処理を停止します。
- **キャンセル**は協調的です。計画段階でキャンセルすると、開始されていないファイル一覧の取得を停止し、計画したすべての項目を `cancelled` としてスキップ扱いで返します。削除リクエストは送信されません。
- **`HAS_CHILD_FILES_OR_FOLDERS` のリトライ:** Misskey は削除リクエストに応答した後でファイルのデータベース行を削除するため、直後にそのフォルダを削除すると `HAS_CHILD_FILES_OR_FOLDERS` で失敗する場合があります。計画した子の削除が完了したフォルダでは、このエラーを200ミリ秒から始まる指数バックオフで最大5回まで試行します。その他の書き込みの失敗はリトライしません。
- `onProgress` が例外をスローした場合、開始されていない処理は停止し、実行中の処理が終わった後でそのエラーが再スローされます。それまでに行われた削除はロールバックできません。

## アップロード {#uploading}

### 事前チェック {#preflight-checks}

`getUploadPreflight()` は現在のユーザーのロールポリシーとドライブの容量を取得し（2つのリクエストを並行して送信します）、アップロード前にファイルをローカルでチェックできるようにします。

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

各 `DriveUploadIssue` には `severity` があります。

| 問題 | 重大度 | 意味 |
|---|---|---|
| `DriveUploadFileTooLarge` | blocking | ロールの `maxFileSizeMb` を超えている。`instanceLimit` が `true` の場合はインスタンスのマルチパート上限を超えている |
| `DriveUploadInsufficientCapacity` | blocking | ドライブの残り容量を超える |
| `DriveUploadTypeNotAllowed` | advisory | MIME タイプがロールでアップロード可能なタイプに含まれていない。サーバーはファイルの内容から実際のタイプを判定するため、参考情報として扱う |
| `DriveUploadPoliciesUnavailable` | advisory | 一部のポリシー値が欠けていたため、それらのチェックをスキップした |

`canUpload` が `false` になるのは、blocking の問題がある場合のみです。

- モデレーターと管理者はロールポリシーの制限を受けないため、インスタンスのファイルサイズチェックのみが適用されます。
- `meta` を省略した場合は `/meta` リクエストを送信せず、インスタンス全体のファイルサイズチェックはスキップされます。
- 複数のファイルを順番にチェックするには `checkAll()` を使用します。各ファイルのサイズは、次のファイルが使用できる容量から差し引かれます。
- 結果は参考情報です。スナップショットの取得後に上限や使用量が変わる場合があります。また、サーバーはロールポリシーを評価する前に同じ内容の既存ファイルを返すことがあるため、内容が重複するファイルではポリシーの問題が誤検出になる場合があります。

### createDeduplicated

ドライブにすでに存在する内容をアップロードすると、サーバーは既存のファイルを返します。ただしそれはアップロードをすべて受信した後であり、指定した `folderId`、`name`、`comment` は無視されます。`createDeduplicated()` は先に MD5 を検索し、一致するファイルがあれば転送を省略します。

```dart
final result = await client.drive.files.createDeduplicated(
  bytes: bytes,
  filename: 'photo.jpg',
  folderId: albumFolderId,
  onDuplicate: DriveDuplicatePolicy.moveExisting,
);

print('${result.file.id}: ${result.outcome.name}');
```

| `DriveDuplicatePolicy` | 同じ内容のファイルが存在する場合の動作 |
|---|---|
| `reuseExisting`（デフォルト） | 既存のファイルを移動せずに返す |
| `moveExisting` | 既存のファイルが別の場所にあれば `folderId` へ移動する |
| `uploadAnyway` | 検索を行わず、別のコピーをアップロードする |

- `result.outcome` は `uploaded`、`reusedExisting`、`movedExisting` のいずれかです。これはベストエフォートです。検索の後に同時に行われたアップロードが先に完了する場合があり、そのような競合は常に検出できるとは限りません。
- 既存のファイルの名前とコメントは変更されません。`isSensitive: true` を指定すると、センシティブでない既存のファイルをセンシティブに変更します。
- 大きな入力のハッシュ計算を避けるには `md5`（16進数32文字）を渡します。渡さない場合、ハッシュは呼び出し元の isolate 上で同期的に計算されます（`uploadAnyway` の場合を除く）。
- 既存のファイルが一致した場合は `folderId` が検証されないため、`reuseExisting` では存在しないフォルダや他のユーザーのフォルダを指定してもエラーになりません。`force` を指定しない通常の `create()` も同じ動作です。サーバーがフォルダを検索する前に一致したファイルを返すためです。

### createMany

`createMany()` は `DriveUploadInput` のリストを並列数を制限してアップロードし、入力順の `MisskeyBatchResult` を返します。

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

- `concurrency`（デフォルトは2）で並列アップロード数を制限します。
- レート制限（HTTP 429）を受けると新しいアップロードを停止し、残りの入力を `rateLimited` とします。実行中のアップロードは完了まで続きます。`stopOnError: true` を指定すると、エラーが発生した時点で停止し、残りの入力は `stoppedAfterError` としてスキップされます。
- `deduplicate` を指定すると、各入力はそのポリシーの `createDeduplicated()` と同様に処理されます。同じバッチ内の同一の入力は順序付きのチェーンを形成します。後続の入力は先行する入力を待機し（その間ワーカーを占有します）、ポリシーに従って先行する入力の最新の結果を使用します。`moveExisting` の場合、ファイルは最後の入力のフォルダに配置されます。後続の入力のファイル名、名前、コメントは無視されますが、`isSensitive` はファイルを `true` に変更する方向にのみ作用します。先行する入力が失敗またはスキップされた場合、すでに実行中の後続の入力は `dependencyFailed` としてスキップされます。`uploadAnyway` の場合、各入力は独立してアップロードされます。
- `deduplicate` を指定しない場合でもサーバーが同じ内容の既存ファイルを返すことがありますが、その場合も `uploaded` として報告されます。
- `onProgress` は、項目の件数（`completedItems`、`succeededItems`、`failedItems`、`totalItems`）と、`itemIndex` の項目のバイト単位の進捗（`sent`、`total`）を持つ `DriveBatchUploadProgress` を受け取ります。
- 自動的なリトライは行いません。サーバーがファイルを保存した後にネットワークが失敗した場合は失敗として報告されます。`deduplicate` を指定せずに、または `reuseExisting` か `moveExisting` を指定して再実行すると、これらのアップロードはサーバー側の重複排除（`force: false`）を利用するため、新たなファイルは作成されず保存済みのファイルが返されます。`uploadAnyway`（`force: true`）の場合は、再実行によって追加のコピーが作成される場合があります。
- 入力のバイト列はコピーされません。バッチが完了するまで変更しないでください。

## URL アップロードの完了を待つ {#waiting-for-url-uploads}

`uploadFromUrl()` はサーバーがリクエストを受け付けた時点で戻り、ファイルは後から追加されます。`uploadFromUrlAndWait()` はさらに `main` ストリーミングチャンネルの `urlUploadFinished` イベントを待ち、作成されたファイルを返します。購読や接続は自動では行わないため、先に `MisskeyStreamingChannel.main()` を購読して接続してください。

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

- トークンには `write:drive` と `read:account` の権限が必要です。
- `mainSubscription` で特定の main 購読を指定できます。指定しない場合は `client.streaming.subscriptions` で最初に登録されたものが使用されます。購読が存在しないか有効でない場合、またはストリーミングクライアントが接続されていない場合は `StateError` がスローされます。
- アップロードが失敗してもサーバーはイベントを送信しないため、失敗はタイムアウトとしてのみ検出できます。タイムアウトしてもサーバー側のアップロードはキャンセルされません。`timeout`（デフォルトは2分）はアップロードリクエストの完了後から計測されます。
- 再接続中に届いたイベントは失われます。
- 呼び出しごとに一意の `marker` が生成されます。独自に渡す場合は、空でなく、アップロードごとに一意である必要があります。
- サーバー側の重複排除により、別のフォルダにある既存のファイルが返される場合があります。

接続と購読の詳細は [Streaming API](../streaming.md) を参照してください。

## レート制限 {#rate-limits}

これらのヘルパーが使用するエンドポイントに対する、Misskey のデフォルトのユーザーごとの制限は次のとおりです。

| エンドポイント | 制限 | 使用するヘルパー |
|---|---|---|
| `drive/folders/create` | 1時間あたり10回 | `getOrCreate()` |
| `drive/files/create` | 1時間あたり120回 | `createDeduplicated()`、`createMany()` |
| `drive/files/upload-from-url` | 1時間あたり60回 | `uploadFromUrlAndWait()` |
| 一覧、`show`、`find`、`update`、`delete`、`move-bulk` | エンドポイントごとの制限なし | その他すべてのヘルパー |

サーバー管理者が設定したロールのレート制限係数によって、これらの値は増減します。制限に達すると、単一リクエストのヘルパーは `MisskeyRateLimitException` をスローし、バッチヘルパーは新しい処理の開始を停止します。`createMany()`、`dissolveFolder()`、`deleteFolderRecursive()` は残りの項目を `rateLimited` として報告します。
