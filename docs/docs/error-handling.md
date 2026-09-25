---
sidebar_position: 4
title: Error Handling
---

# Error Handling

This library maps Misskey API errors to a sealed class hierarchy rooted at `MisskeyClientException`.

## Exception hierarchy

```
MisskeyClientException (sealed)
├── MisskeyApiException              // General HTTP response errors
│   ├── MisskeyUnauthorizedException // 401 - Invalid or missing token
│   ├── MisskeyForbiddenException    // 403 - Operation not permitted
│   ├── MisskeyNotFoundException     // 404 - Resource not found
│   ├── MisskeyRateLimitException    // 429 - Rate limited
│   │   └── retryAfter               //   Server-suggested wait duration
│   ├── MisskeyValidationException   // 422 - Invalid request body
│   └── MisskeyServerException       // 5xx - Server-side error
└── MisskeyNetworkException          // Timeout, connection refused, etc.
```

`MisskeyApiException` also carries Misskey-specific fields:

- `code` — Misskey error code string (e.g. `AUTHENTICATION_FAILED`, `NO_SUCH_NOTE`)
- `errorId` — UUID identifying the Misskey error type
- `endpoint` — The API path where the error occurred

## Exceptions outside the hierarchy

`MisskeyClientException` covers API and transport errors. Some helper APIs, such as the [Drive helpers](./advanced/drive-helpers.md), can also throw:

- `ArgumentError` — invalid arguments (for example a non-positive `concurrency` or an out-of-range `pageSize`). It is thrown before any request is sent.
- `StateError` — unmet preconditions, such as calling `client.drive.uploadFromUrlAndWait()` without a connected `main` streaming subscription.
- `DriveFolderAmbiguousException` — thrown by `resolvePath()` and `getOrCreate()` when several sibling folders share a name. It is not part of the sealed hierarchy, so `on MisskeyClientException` does not catch it.

```dart
try {
  final folder = await client.drive.folders.resolvePath(['Photos', 'Trip']);
} on DriveFolderAmbiguousException catch (e) {
  print('${e.candidates.length} folders named "${e.name}"');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

Batch helpers that change many items (for example `createMany()`, `moveBulkAll()`, `dissolveFolder()`, and `deleteFolderRecursive()`) do not throw once changes have started. They return a `MisskeyBatchResult` (or a result containing one) that reports each item as a success, a failure with its error, or a skip with a reason. Errors that occur before any change, such as a failed destination check, are still thrown.

## Basic catch patterns

### Catching all errors

```dart
try {
  final note = await client.notes.show(noteId: '9xyz');
} on MisskeyClientException catch (e) {
  print('Error: $e');
}
```

### Handling by HTTP status

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

### Inspecting the Misskey error code

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

## Handling rate limits

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

// Usage
final timeline = await withRetry(
  () => client.notes.timelineHome(limit: 20),
);
```

## Network error handling

`MisskeyNetworkException` wraps connection-level failures such as timeouts and DNS errors. The `cause` field holds the underlying exception:

```dart
try {
  final notes = await client.notes.timelineLocal();
} on MisskeyNetworkException catch (e) {
  print('Network error at ${e.endpoint}: ${e.cause}');
}
```

The client retries automatically up to `MisskeyClientConfig.maxRetries` times (default: 3) for idempotent requests before throwing.
