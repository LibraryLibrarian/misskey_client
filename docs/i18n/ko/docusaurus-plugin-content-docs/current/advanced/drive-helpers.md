---
sidebar_position: 3
title: 드라이브 헬퍼
---

# 드라이브 헬퍼

드라이브 헬퍼는 여러 드라이브 API 호출을 하나의 작업으로 묶는 고수준 메서드입니다. 모든 페이지 조회, 폴더 트리 탐색, 여러 파일 이동 및 업로드, 폴더와 내부 항목 전체 삭제 기능을 제공합니다. 일반 엔드포인트와 동일한 파사드(`client.drive`, `client.drive.files`, `client.drive.folders`)에서 사용할 수 있습니다. 단일 요청 엔드포인트는 [드라이브 업로드](./drive-upload.md)를 참조하세요.

각 헬퍼는 여러 요청을 보내므로 원자적이지 않습니다. 헬퍼 실행 중 서버에서 다른 클라이언트 등이 변경한 내용이 결과에 반영될 수 있습니다.

## 모든 항목 조회 {#listing-everything}

다음 세 헬퍼는 목록을 페이지 단위로 조회하여 `Stream`으로 반환합니다.

| 메서드 | 조회 항목 | 필터 |
|---|---|---|
| `client.drive.files.listAll()` | 한 폴더의 파일 (`folderId` 생략 시 루트) | `folderId`, `type` |
| `client.drive.folders.listAll()` | 한 상위 폴더의 폴더 (`folderId` 생략 시 루트) | `folderId` |
| `client.drive.streamAll()` | 모든 폴더의 파일 | `type` |

```dart
// 폴더의 모든 이미지
await for (final file in client.drive.files.listAll(
  folderId: myFolderId,
  type: 'image/*',
)) {
  print('${file.name} (${file.size} bytes)');
}

// 드라이브 전체에서 최대 500개 파일
final recent = await client.drive.streamAll(maxItems: 500).toList();
```

### ID 최신순만 지원 {#newest-first-id-order-only}

결과는 항상 ID 최신순으로 반환됩니다. `listAll()`은 `sort`를 받지 않습니다. 이름이나 크기순으로 정렬해도 서버가 `untilId` 커서를 ID 필터로 적용하므로 페이지 간 항목이 누락되거나 반복될 수 있습니다. 다른 순서가 필요하면 결과를 모은 뒤 로컬에서 정렬하세요.

```dart
final files = await client.drive.files.listAll(folderId: myFolderId).toList();
files.sort((a, b) => b.size.compareTo(a.size)); // 큰 파일부터
```

### 페이지 크기와 제한 {#page-size-and-limits}

- `pageSize`는 호출당 요청하는 항목 수입니다(1~100, 기본값 100).
- `maxItems`를 지정하면 해당 항목 수에 도달한 뒤 스트림을 종료합니다. `0`이면 요청을 보내지 않습니다.

잘못된 값은 메서드 호출 시 동기적으로 `ArgumentError`를 발생시킵니다.

### 스트림 동작 {#stream-behavior}

각 호출은 cold 단일 구독 스트림을 반환합니다. listen하기 전에는 요청을 보내지 않으며, 구독을 취소하거나 `await for` 루프를 일찍 빠져나가면 이후 페이지 요청이 중단됩니다. API 오류는 이미 전달된 항목 뒤에 스트림 오류로 전달됩니다.

목록은 스냅샷이 아닙니다. 페이지 조회 중 추가, 이동 또는 삭제된 파일이 누락되거나 포함될 수 있습니다.

### MIME 타입 필터 {#mime-type-filter}

`type`에는 영문자, `/`, `-`, `*`만 허용됩니다. 숫자가 포함된 값은 서버가 거부하므로 `video/mp4`는 실패합니다. 정확한 타입이 필요하면 `video/*`와 같은 와일드카드를 사용한 다음 로컬에서 필터링하세요.

```dart
final mp4s = await client.drive
    .streamAll(type: 'video/*')
    .where((file) => file.type == 'video/mp4')
    .toList();
```

## 배치 결과 및 취소 {#batch-results-and-cancellation}

여러 항목을 변경하는 헬퍼는 변경을 시작한 뒤 개별 작업 실패를 예외로 던지지 않고, 입력 순서대로 입력마다 하나의 결과를 담은 `MisskeyBatchResult<I, T>`에 기록합니다. 정착된 항목을 보고하는 `onProgress` 콜백에서 사용자가 던진 오류는 다릅니다. 새 작업을 중단하고 진행 중 요청이 끝난 뒤 그 오류를 다시 던지며, 이미 완료된 변경은 롤백하지 않습니다.

| 타입 | 의미 | 필드 |
|---|---|---|
| `MisskeyBatchSuccess<I, T>` | 작업 성공 | `input`, `index`, `value` |
| `MisskeyBatchFailure<I, T>` | 작업에서 예외 발생 | `input`, `index`, `error`, `stackTrace` |
| `MisskeyBatchSkipped<I, T>` | 작업이 시작되지 않음 | `input`, `index`, `reason`, `cause` |

`MisskeyBatchSkipReason`은 항목이 건너뛰어진 이유를 나타냅니다.

| 값 | 의미 |
|---|---|
| `cancelled` | 취소 요청됨 |
| `rateLimited` | `createMany()`, `dissolveFolder()`, `deleteFolderRecursive()`에서 서버가 요청을 제한함(HTTP 429) |
| `stoppedAfterError` | 앞선 오류로 배치 중단 (`stopOnError`를 사용한 `createMany()` 또는 429를 포함한 `moveBulkAll()`의 청크 실패) |
| `dependencyFailed` | 선행 작업 실패 (예: 파일 이동 실패 후 폴더 해체, 또는 내부 항목을 삭제하지 못한 폴더 삭제) |

결과에는 `successes`, `failures`, `skipped`, `isComplete`도 포함됩니다(`isComplete`는 빈 배치를 포함해 모든 항목이 성공했을 때 true). `MisskeyBatchItemResult`는 sealed 타입이므로 항목에 대한 `switch`는 망라적입니다.

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

### 취소 {#cancellation}

`createMany()`와 `deleteFolderRecursive()`는 `MisskeyCancellationToken`을 받습니다. 취소는 협력 방식으로 동작하여 새 작업의 시작을 막지만, 진행 중인 요청을 중단하지 않고 완료될 때까지 기다립니다. 시작되지 않은 항목은 일반적으로 `cancelled` 사유로 건너뛴 것으로 보고됩니다. `deleteFolderRecursive()`에서 `HAS_CHILD_FILES_OR_FOLDERS` 재시도가 취소로 중단된 폴더는 삭제를 이미 시도했으므로 실패로 보고됩니다.

```dart
final token = MisskeyCancellationToken();
final future = client.drive.files.createMany(inputs, cancellation: token);

// 나중에, 예를 들어 사용자가 "취소"를 누를 때
token.cancel();

final result = await future;
print('Uploaded ${result.successes.length} of ${inputs.length}');
```

## 파일 일괄 이동 {#moving-files-in-bulk}

`moveBulkAll()`은 여러 파일을 하나의 폴더로 이동합니다. 루트로 이동하려면 `folderId`에 `null`을 전달하거나 생략하세요.

```dart
final result = await client.drive.files.moveBulkAll(
  fileIds: selectedFileIds,
  folderId: targetFolderId,
);

if (!result.isComplete) {
  print('Not confirmed: ${result.unconfirmedFileIds}');
}
```

- 중복 ID를 제거한 뒤 나머지 ID를 최대 100개씩 순차 청크로 전송합니다. 각 청크는 `result.chunks`의 항목이 됩니다.
- 첫 청크 실패 후 처리를 중단하고 이후 청크는 건너뛴 것으로 보고합니다. `unconfirmedFileIds`에는 실패했거나 시작되지 않은 청크의 ID가 포함됩니다.
- `folderId`가 null이 아니면 이동 전에 대상 폴더를 확인합니다. 확인하지 않으면 서버가 없는 폴더를 일반 500 오류로 보고하기 때문입니다. 확인 실패 시(예: 코드가 `NO_SUCH_FOLDER`인 `MisskeyApiException`) 예외가 발생하고 파일은 이동되지 않습니다. 확인 후 폴더가 삭제되면 해당 청크가 실패한 것으로 처리됩니다.
- 청크 성공은 서버가 요청을 수락했다는 뜻이지 모든 ID가 이동되었다는 뜻은 아닙니다. 존재하지 않거나 다른 사용자에게 속한 ID는 서버가 조용히 무시합니다.
- `fileIds`가 비어 있으면 대상 확인을 포함해 어떤 요청도 보내지 않습니다.

이 헬퍼는 Misskey 2025.5.1 이상이 필요한 `drive/files/move-bulk` 엔드포인트를 사용합니다. 이전 서버에서는 엔드포인트 오류가 실패한 청크로 반환됩니다.

## 폴더 트리 및 사용량 요약 {#folder-tree-and-usage-summary}

### 폴더 트리 {#folder-tree}

`getTree()`는 변경할 수 없는 폴더 `DriveFolderTree`를 반환합니다.

```dart
final tree = await client.drive.folders.getTree(maxDepth: 2);

for (final node in tree.nodes) {
  print('${'  ' * node.depth}${node.folder.name}');
}
print('${tree.folderCount} folders, truncated: ${tree.isTruncated}');
```

- 방문한 폴더마다 하나 이상의 목록 요청을 보내므로 트리가 크면 비용이 큽니다. `concurrency`(기본값 4)는 병렬 요청 수를 제한합니다.
- 특정 폴더에서 시작하려면 `rootFolderId`를 전달하세요(`tree.rootNode`로 접근 가능). 생략하면 드라이브 루트에서 시작합니다.
- `maxDepth`를 사용하면 제한 깊이의 폴더는 포함하지만 하위 폴더는 조회하지 않습니다. `DriveFolderNode.childrenLoaded`는 `false`, `tree.isTruncated`는 `true`가 됩니다. 트리가 잘렸다고 해서 더 깊은 폴더가 존재한다는 뜻은 아닙니다.
- 읽기 전용 작업이므로 요청이 하나라도 실패하면 탐색을 중단하고 예외를 던집니다.

### 사용량 요약 {#usage-summary}

`getUsageSummary()`는 드라이브 전체를 검사하고 폴더별 및 MIME 타입별 파일 수와 바이트 수를 집계합니다.

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

각 `DriveFolderUsage`에는 `direct`(폴더 바로 아래 파일) 및 `recursive`(폴더와 모든 하위 항목) 통계가 있습니다. `summary.folderUsage(folderId)`로 폴더 하나의 사용량을 조회할 수 있습니다.

- 비용: 파일 100개당 `drive/stream` 요청 약 1회와 폴더당 폴더 목록 요청 1회입니다.
- 원자적 스냅샷이 아닙니다. 드라이브 동시 변경으로 약간의 불일치가 생길 수 있으며, 검사한 트리에 없는 폴더의 파일은 `unassigned`에 집계됩니다.
- 연결 파일(`isLink`가 설정된 캐시되지 않은 원격 파일)은 여기에 포함되지만 서버 사용량에는 제외되므로 `summary.total`이 `client.drive.stats.getCapacity()`와 다를 수 있습니다.

## 경로 확인 {#resolving-paths}

### resolvePath

`resolvePath()`는 폴더 이름 목록으로 폴더를 찾으며 각 경로 구성 요소마다 `folders/find` 요청을 하나 보냅니다. `parentId`가 존재하지 않는 경우를 포함해 구성 요소를 찾지 못하면 `null`을 반환합니다.

```dart
final folder = await client.drive.folders.resolvePath(['Photos', '2026', 'Trip']);
if (folder == null) {
  print('Not found');
}
```

목록의 각 항목은 완전한 폴더 이름 하나이므로 이름 자체에 `/`가 포함될 수 있습니다. 빈 목록, 빈 구성 요소 또는 200자(유니코드 코드 포인트)를 초과하는 구성 요소는 요청 전에 `ArgumentError`를 발생시킵니다.

### 이름이 같은 폴더 {#same-named-folders}

Misskey에서는 형제 폴더의 이름이 같을 수 있으며 `folders/find`는 순서를 보장하지 않습니다. `onAmbiguous`로 정책을 선택합니다.

| `DriveFolderAmbiguityPolicy` | 동작 |
|---|---|
| `error`(기본값) | `DriveFolderAmbiguousException` 발생 |
| `oldest` | `createdAt`이 가장 이른 항목, 이어서 ID가 가장 낮은 항목 선택 |
| `newest` | `createdAt`이 가장 늦은 항목, 이어서 ID가 가장 높은 항목 선택 |

`DriveFolderAmbiguousException`은 모호한 `name`, `parentId`, 일치하는 `candidates`, `segmentIndex`를 제공합니다. `MisskeyClientException`의 하위 타입이 아니므로 명시적으로 잡아야 합니다.

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}" at segment ${e.segmentIndex}');
}
```

### getOrCreate

`getOrCreate()`는 `parentId` 아래(생략 시 루트)에서 이름으로 폴더를 찾고 일치하는 폴더가 없으면 생성합니다.

```dart
final result = await client.drive.folders.getOrCreate(
  name: 'Screenshots',
  parentId: photosFolderId,
  onAmbiguous: DriveFolderAmbiguityPolicy.oldest,
);
print('${result.folder.id} created: ${result.created}');
```

- `resolvePath()`와 동일한 `onAmbiguous` 정책을 받습니다.
- 원자적이지 않습니다. 동시에 호출하면 각각 동일한 이름의 폴더를 만들 수 있습니다.
- `folders/create`는 시간당 10회로 제한됩니다. `MisskeyRateLimitException`은 그대로 전달됩니다.
- 이름이 비어 있거나 200자를 초과하면 `ArgumentError`가 발생합니다. 존재하지 않는 `parentId`에서는 일치 항목이 없어 생성 요청이 전송되고, `NO_SUCH_FOLDER` 코드의 `MisskeyApiException`으로 실패합니다.

## 폴더 해체 및 삭제 {#dissolving-and-deleting-folders}

### dissolveFolder

`dissolveFolder()`는 폴더 바로 아래의 파일과 하위 폴더를 상위 폴더(또는 루트)로 이동한 뒤 비어 있는 폴더를 삭제합니다. 이름을 바꾸지 않으며 Misskey는 중복 이름을 허용합니다.

```dart
final result = await client.drive.dissolveFolder(folderId: folderId);

if (!result.isComplete) {
  print('File moves complete: ${result.files.isComplete}');
  print('Subfolder moves complete: ${result.subfolders.isComplete}');
  print('Deletion: ${result.deletion}');
}
```

- 폴더, 내부 항목 또는 대상 상위 폴더(이동할 파일이 있을 때 확인)를 읽을 수 없으면 변경 전에 예외가 발생합니다.
- 파일은 `moveBulkAll()`로 이동합니다(100개씩 순차 청크, Misskey 2025.5.1 이상). 하위 폴더는 `concurrency`(기본값 4)로 제한하여 병렬 이동합니다. 파일 이동이 완료되지 않으면 하위 폴더 이동과 삭제를 건너뜁니다.
- 모든 이동이 성공한 경우에만 원본 폴더를 삭제합니다. HTTP 429가 발생하면 새로운 하위 폴더 이동을 중단하고 나머지는 `rateLimited`로 보고하며 삭제를 건너뜁니다.
- 동시에 폴더에 추가된 항목으로 인해 `HAS_CHILD_FILES_OR_FOLDERS` 오류로 삭제가 실패할 수 있으며 `result.deletion`에 보고됩니다.
- 부분 결과가 나온 뒤 다시 실행해도 안전합니다.

### deleteFolderRecursive

:::danger 되돌릴 수 없음
`deleteFolderRecursive()`는 폴더와 모든 하위 폴더, 그 안의 파일을 영구 삭제합니다. 삭제한 파일은 복구할 수 없습니다. 삭제된 파일을 사용하는 노트와 갤러리 게시물에는 유효하지 않은 참조가 남고, 채팅 메시지에서는 첨부 파일이 사라집니다. 먼저 `dryRun: true`로 실행하여 계획을 확인하세요.
:::

```dart
// 1. 아무것도 삭제하지 않고 계획 확인
final preview = await client.drive.deleteFolderRecursive(
  folderId: folderId,
  dryRun: true,
);
final plan = preview.plan;
print('${plan.fileCount} files, ${plan.folderCount} folders, ${plan.totalBytes} bytes');

// 2. 삭제
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

작업은 세 단계(`DriveRecursiveDeletePhase`)로 진행됩니다. `planning`은 변경 없이 트리와 파일을 불러오고, `deletingFiles`는 계획한 파일을 삭제하며, `deletingFolders`는 가장 깊은 폴더부터 삭제합니다. 진행 수는 단계별로 계산되며 건너뛴 항목도 포함합니다.

- **계획 단계의 실패는** 아무것도 삭제하기 전에 예외를 발생시킵니다. 삭제를 시작한 뒤 발생한 개별 실패는 `result.files` 및 `result.folders`에 반환됩니다.
- **드라이런은 대상을 고정하지 않습니다.** 이후 드라이런이 아닌 호출은 새 계획을 만들며, 그 사이에 추가된 항목도 포함될 수 있습니다. 계획 후 다른 위치로 이동된 항목도 삭제됩니다.
- **부분 결과:** 계획한 내부 항목이 모두 성공하지 못한 폴더는 삭제를 시도하지 않으며 해당 상위 폴더도 마찬가지입니다. 이미 사라진 파일과 폴더는 삭제 성공으로 간주됩니다.
- **요청 제한**에 도달하면 새 작업을 중단합니다.
- **취소**는 협력 방식입니다. 계획 중 취소하면 아직 시작되지 않은 파일 목록 조회를 중단하고 모든 계획 항목을 `cancelled`로 건너뛴 것으로 반환하며 삭제 요청은 보내지 않습니다.
- **`HAS_CHILD_FILES_OR_FOLDERS` 재시도:** Misskey는 삭제 요청에 응답한 뒤 파일 데이터베이스 행을 제거하므로 직후 폴더를 삭제하면 `HAS_CHILD_FILES_OR_FOLDERS` 오류가 발생할 수 있습니다. 계획된 하위 항목을 삭제한 폴더는 이 오류에 대해 200ms부터 시작하는 지수 백오프로 재시도하며, 최초 시도를 포함해 총 시도 횟수는 최대 5회입니다. 다른 쓰기 실패는 재시도하지 않습니다.
- `onProgress`에서 예외가 발생하면 아직 시작되지 않은 작업을 중지하고 진행 중 작업이 끝난 뒤 예외를 다시 던집니다. 앞서 수행한 삭제는 롤백할 수 없습니다.

## 업로드 {#uploading}

### 사전 검사 {#preflight-checks}

`getUploadPreflight()`은 업로드 전에 파일을 로컬에서 검사할 수 있도록 현재 사용자의 역할 정책과 드라이브 용량을 가져옵니다(두 요청을 병렬 전송).

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

각 `DriveUploadIssue`에는 `severity`가 있습니다.

| 문제 | 심각도 | 의미 |
|---|---|---|
| `DriveUploadFileTooLarge` | blocking | 역할의 `maxFileSizeMb`를 초과하거나 `instanceLimit`이 `true`일 때 인스턴스 멀티파트 제한 초과 |
| `DriveUploadInsufficientCapacity` | blocking | 드라이브의 남은 용량 초과 |
| `DriveUploadTypeNotAllowed` | advisory | MIME 타입이 역할의 업로드 허용 타입에 포함되지 않음. 서버는 파일 내용으로 실제 타입을 판정하므로 참고 정보 |
| `DriveUploadPoliciesUnavailable` | advisory | 일부 정책 값이 누락되어 해당 검사를 건너뜀 |

blocking 문제가 있을 때만 `canUpload`가 `false`가 됩니다.

- 모더레이터와 관리자는 역할 정책 제한을 받지 않으므로 인스턴스 파일 크기 검사만 적용됩니다.
- `meta`를 생략하면 `/meta` 요청을 보내지 않고 인스턴스 전체 파일 크기 검사를 건너뜁니다.
- 여러 파일을 순서대로 검사하려면 `checkAll()`을 사용하세요. 각 파일 크기는 다음 파일에 사용할 수 있는 용량에서 차감됩니다.
- 결과는 참고 정보입니다. 스냅샷 후 제한과 사용량이 바뀔 수 있습니다. 또한 서버는 역할 정책 평가 전에 같은 내용의 기존 파일을 반환할 수 있으므로 중복 콘텐츠에서는 정책 문제가 오탐일 수 있습니다.

### createDeduplicated

드라이브에 이미 있는 콘텐츠를 업로드하면 서버는 업로드 전체를 받은 뒤 기존 파일을 반환하며 요청한 `folderId`, `name`, `comment`는 무시합니다. `createDeduplicated()`은 먼저 MD5를 조회하여 일치하는 항목이 있으면 전송을 방지합니다.

```dart
final result = await client.drive.files.createDeduplicated(
  bytes: bytes,
  filename: 'photo.jpg',
  folderId: albumFolderId,
  onDuplicate: DriveDuplicatePolicy.moveExisting,
);

print('${result.file.id}: ${result.outcome.name}');
```

| `DriveDuplicatePolicy` | 같은 콘텐츠의 파일이 있을 때 동작 |
|---|---|
| `reuseExisting`(기본값) | 기존 파일을 이동하지 않고 반환 |
| `moveExisting` | 다른 위치에 있으면 기존 파일을 `folderId`로 이동 |
| `uploadAnyway` | 조회를 건너뛰고 사본을 추가 업로드 |

- `result.outcome`은 `uploaded`, `reusedExisting`, `movedExisting` 중 하나입니다. 최선형 동작이며 조회 후 동시 업로드가 먼저 완료될 수 있고 이러한 경쟁 상태를 항상 감지할 수는 없습니다.
- 기존 파일의 이름과 설명은 유지됩니다. `isSensitive: true`는 기존의 민감하지 않은 파일을 민감한 파일로 변경합니다.
- 큰 입력의 해싱을 피하려면 `md5`(16진수 32자)를 전달하세요. 그렇지 않으면 호출 isolate에서 동기적으로 해시를 계산합니다(`uploadAnyway` 제외).
- 기존 파일이 일치하면 `folderId`를 검증하지 않으므로 `reuseExisting`에서는 존재하지 않거나 다른 사용자의 폴더여도 오류가 발생하지 않습니다. `force`가 없는 일반 `create()`도 서버가 폴더를 조회하기 전에 일치 파일을 반환하므로 동일하게 동작합니다.

### createMany

`createMany()`는 `DriveUploadInput` 목록을 제한된 동시성으로 업로드하고 입력 순서의 `MisskeyBatchResult`를 반환합니다.

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

- `concurrency`(기본값 2)는 병렬 업로드 수를 제한합니다.
- 요청 제한(HTTP 429)이 발생하면 새 업로드를 중단하고 남은 입력을 `rateLimited`로 표시하며 진행 중인 업로드는 완료됩니다. 오류 발생 후 중단하려면 `stopOnError: true`를 설정하세요. 남은 입력은 `stoppedAfterError`로 건너뜁니다.
- `deduplicate`를 지정하면 각 입력은 해당 정책을 적용해 `createDeduplicated()`와 같이 처리됩니다. 같은 배치의 동일한 입력은 순서가 있는 체인을 구성합니다. 각 후속 입력은 선행 입력을 기다리고(작업자 하나를 점유), 정책에 따라 선행 입력의 최신 결과를 사용합니다. `moveExisting`에서는 마지막 입력의 폴더에 파일이 위치합니다. 후속 입력의 파일명, 이름 및 설명은 무시되며 `isSensitive`는 파일을 `true`로만 승격할 수 있습니다. 선행 입력이 실패하거나 건너뛰면 이미 실행 중인 후속 입력은 `dependencyFailed`로 건너뜁니다. `uploadAnyway`에서는 각 입력이 독립적으로 업로드됩니다.
- `deduplicate`를 사용하지 않아도 서버는 같은 콘텐츠의 기존 파일을 반환할 수 있지만 결과는 `uploaded`로 보고됩니다.
- `onProgress`는 항목 수(`completedItems`, `succeededItems`, `failedItems`, `totalItems`)와 `itemIndex` 항목의 바이트 진행 상황(`sent`, `total`)을 담은 `DriveBatchUploadProgress`를 받습니다.
- 자동 재시도는 없습니다. 서버가 파일을 저장한 뒤 네트워크 오류가 나면 실패로 보고됩니다. `deduplicate` 없이 다시 실행하거나 `reuseExisting` 또는 `moveExisting` 정책으로 다시 실행하면 서버 측 중복 제거(`force: false`)에 의해 사본을 추가하는 대신 저장된 파일이 반환됩니다. `uploadAnyway`(`force: true`)로 다시 실행하면 사본이 추가로 생성될 수 있습니다.
- 입력 바이트는 복사되지 않으므로 배치가 완료될 때까지 수정하지 마세요.

## URL 업로드 완료 대기 {#waiting-for-url-uploads}

`uploadFromUrl()`은 서버가 요청을 수락하면 즉시 반환하고 파일은 나중에 나타납니다. `uploadFromUrlAndWait()`은 `main` 스트리밍 채널에서 `urlUploadFinished` 이벤트를 기다린 뒤 결과 파일을 반환합니다. 자동으로 구독하거나 연결하지 않으므로 먼저 `MisskeyStreamingChannel.main()`을 구독하고 연결하세요.

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

- 토큰에는 `write:drive` 및 `read:account` 권한이 필요합니다.
- `mainSubscription`은 특정 main 구독을 선택합니다. 생략하면 `client.streaming.subscriptions`의 첫 등록 항목을 사용합니다. 구독이 없거나 비활성 상태이거나 스트리밍 클라이언트가 연결되지 않은 경우 `StateError`가 발생합니다.
- 업로드 실패 시 서버는 이벤트를 보내지 않으므로 타임아웃으로만 실패를 확인할 수 있습니다. 타임아웃은 서버 측 업로드를 취소하지 않습니다. `timeout`(기본값 2분)은 업로드 요청 완료 후 시작됩니다.
- 연결 재설정 중 도착한 이벤트는 유실됩니다.
- 호출마다 고유한 `marker`가 생성됩니다. 직접 전달하는 경우 비어 있지 않아야 하며 업로드마다 고유해야 합니다.
- 서버 측 중복 제거로 다른 폴더에 있는 기존 파일이 반환될 수 있습니다.

연결 및 구독에 관한 내용은 [Streaming API](../streaming.md)를 참조하세요.

## 요청 제한 {#rate-limits}

이 헬퍼들이 사용하는 엔드포인트의 Misskey 기본 사용자별 제한은 다음과 같습니다.

| 엔드포인트 | 제한 | 사용처 |
|---|---|---|
| `drive/folders/create` | 시간당 10회 | `getOrCreate()` |
| `drive/files/create` | 시간당 120회 | `createDeduplicated()`, `createMany()` |
| `drive/files/upload-from-url` | 시간당 60회 | `uploadFromUrlAndWait()` |
| 목록 조회, `show`, `find`, `update`, `delete`, `move-bulk` | 엔드포인트별 제한 없음 | 기타 모든 헬퍼 |

서버 관리자가 설정한 역할별 요청 제한 계수가 이 값을 조정합니다. 제한에 도달하면 단일 요청 헬퍼는 `MisskeyRateLimitException`을 발생시키고, 배치 헬퍼는 새 작업을 시작하지 않습니다. 시작되지 않은 독립 작업은 `createMany()`, `dissolveFolder()`의 하위 폴더 이동 단계, `deleteFolderRecursive()`의 삭제 단계에서 `rateLimited`로 보고됩니다. `moveBulkAll()`의 청크는 `stoppedAfterError`를 사용하고, 의존 작업은 `dependencyFailed`가 될 수 있으며, 중단된 폴더 삭제 재시도는 실패로 남습니다.
