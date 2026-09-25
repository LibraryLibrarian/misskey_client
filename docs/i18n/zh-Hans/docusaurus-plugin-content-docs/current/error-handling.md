---
sidebar_position: 4
title: 错误处理
---

# 错误处理

本库将 Misskey API 错误映射到以 `MisskeyClientException` 为根节点的 sealed class 层级结构。

## 异常层级

```
MisskeyClientException (sealed)
├── MisskeyApiException              // 通用 HTTP 响应错误
│   ├── MisskeyUnauthorizedException // 401 - 令牌无效或缺失
│   ├── MisskeyForbiddenException    // 403 - 操作不被允许
│   ├── MisskeyNotFoundException     // 404 - 资源不存在
│   ├── MisskeyRateLimitException    // 429 - 触发频率限制
│   │   └── retryAfter               //   服务器建议的等待时长
│   ├── MisskeyValidationException   // 422 - 请求体无效
│   └── MisskeyServerException       // 5xx - 服务端错误
└── MisskeyNetworkException          // 超时、连接被拒等网络错误
```

`MisskeyApiException` 还携带 Misskey 特有的字段：

- `code` — Misskey 错误码字符串（如 `AUTHENTICATION_FAILED`、`NO_SUCH_NOTE`）
- `errorId` — 标识 Misskey 错误类型的 UUID
- `endpoint` — 发生错误的 API 路径

## 层级之外的异常 {#exceptions-outside-the-hierarchy}

`MisskeyClientException` 涵盖 API 和传输错误。一些辅助 API（例如[网盘辅助方法](./advanced/drive-helpers.md)）还可能抛出：

- `ArgumentError` — 参数无效（例如 `concurrency` 非正数或 `pageSize` 超出范围）。它会在发送任何请求前抛出。
- `StateError` — 未满足前置条件，例如在没有已连接的 `main` 流式订阅时调用 `client.drive.uploadFromUrlAndWait()`。
- `DriveFolderAmbiguousException` — 当多个同级文件夹同名时，由 `resolvePath()` 和 `getOrCreate()` 抛出。它不属于 sealed class 层级，因此 `on MisskeyClientException` 不会捕获它。

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}"');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

更改多个项目的批量辅助方法（例如 `createMany()`、`moveBulkAll()`、`dissolveFolder()` 和 `deleteFolderRecursive()`）开始执行变更后，单项操作失败会记录在 `MisskeyBatchResult`（或包含它的结果）中，作为带有错误的失败或带有原因的跳过，而不是抛出异常。更改开始前发生的错误（例如目标检查失败）仍会抛出。在报告已完成项目时，如果 `onProgress` 回调抛出错误，则会在正在进行的工作完成后重新抛出，且已完成的变更不会回滚。

## 基本捕获模式

### 捕获所有错误

```dart
try {
  final note = await client.notes.show(noteId: '9xyz');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

### 按 HTTP 状态码处理

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

### 检查 Misskey 错误码

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

## 处理频率限制

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

// 用法
final timeline = await withRetry(
  () => client.notes.timelineHome(limit: 20),
);
```

## 网络错误处理

`MisskeyNetworkException` 封装了连接层面的故障，例如超时和 DNS 错误。`cause` 字段保存底层异常：

```dart
try {
  final notes = await client.notes.timelineLocal();
} on MisskeyNetworkException catch (e) {
  print('Network error at ${e.endpoint}: ${e.cause}');
}
```

对于幂等请求，客户端在抛出异常前会自动重试最多 `MisskeyClientConfig.maxRetries` 次（默认：3 次）。
