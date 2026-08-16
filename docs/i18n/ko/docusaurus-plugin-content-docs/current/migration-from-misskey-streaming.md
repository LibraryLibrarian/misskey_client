---
title: misskey_streaming에서 마이그레이션
---

# misskey_streaming에서 마이그레이션

Streaming이 이제 `misskey_client`에 통합되었습니다. 모든 호출 위치를 이전한 뒤 독립형 `misskey_streaming` 의존성을 제거하고 issue #30을 포함한 첫 번째 `misskey_client` 릴리스를 사용하세요.

## 클라이언트 및 구독

```dart
// 이전
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
);
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
);

// 이후
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => token,
  streamingConfig: MisskeyStreamingConfig(),
);
await client.streaming.connect();
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(),
);
```

`MisskeyStreaming.fromClient()`는 더 이상 필요하지 않습니다. 포크 전용 채널에는 `subscribeRaw()`를 사용하고 이제 비동기인 `unsubscribe()`를 `await`하세요.

기존 `void oldLogger(String level, String message)` 콜백을 `FunctionLogger(oldLogger)`로 감싸 클라이언트의 `logger`로 전달하고 `MisskeyClientConfig.enableLog`를 `true`로 설정하세요.

| 이전 API | 통합 API |
|---|---|
| `handle.stream` | `messages` / `events` / `notes` / `notifications` |
| `messagesFor(id)` | 해당 핸들의 `messages` |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| `status` / `isConnected` | `stateChanges` / `state == MisskeyStreamingConnectionState.connected` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `tokenProvider` / `logger` 콜백 | `tokenProvider` / `logger: FunctionLogger(oldLogger)` (`enableLog: true`) |
| 재연결 설정 | `MisskeyStreamingConfig` |
| `pingInterval` | 제거됨; 공개 애플리케이션 수준 ping 설정 없음 |
| `customHeaders` / `protocols` | 공개 통합 설정 없음 |
| `exceptionMapper` | 타입 지정 예외 및 `errors` |

캡처는 `home.captureNote(noteId)` / `home.uncaptureNote(noteId)`로 변경합니다. 재사용하려면 `disconnect()`, 완전히 종료하려면 `dispose()` 또는 `MisskeyClient.dispose()`를 사용하세요. `sendToChannel()`의 공개 대체 API는 없습니다.

자세한 내용은 [Streaming API 가이드](./streaming.md)와 [전체 마이그레이션 참고 자료](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md)를 참조하세요.
