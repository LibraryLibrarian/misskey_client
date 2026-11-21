---
title: misskey_streaming에서 마이그레이션
---

# misskey_streaming에서 마이그레이션

Streaming이 이제 `misskey_client`에 통합되었습니다. 모든 호출 위치를 이전한 뒤 독립형 `misskey_streaming` 의존성을 제거하고 Issue #30을 포함한 첫 번째 `misskey_client` 릴리스를 사용하세요.

## 통합 클라이언트 생성

```dart
// 이전
final streaming = MisskeyStreaming.create(
  origin: Uri.parse('https://misskey.example.com'),
  token: token,
  enableAutoReconnect: true,
  debugLog: true,
);

// 이후
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => token,
  streamingConfig: MisskeyStreamingConfig(enableAutoReconnect: true),
);
await client.streaming.connect();
```

`MisskeyStreaming.fromClient()`는 더 이상 필요하지 않습니다. 통합 연결은 `MisskeyClient`의 URL, 토큰 제공자, 로거 및 로그 설정을 공유합니다.

기존 `void oldLogger(String level, String message)` 콜백을 `FunctionLogger(oldLogger)`로 감싸 클라이언트의 `logger`로 전달하고 `MisskeyClientConfig.enableLog`를 `true`로 설정하세요.

## 구독 및 캡처 호출 교체

```dart
// 이전
final handle = await streaming.subscribeChannelStream(
  channel: 'homeTimeline',
  params: {'withRenotes': true},
);
handle.stream.listen((message) => print(message.body));
streaming.captureNote(handle.id, noteId);

// 이후
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(withRenotes: true),
);
home.messages.listen((message) => print(message.body));
home.captureNote(noteId);
```

포크 전용 채널에는 `subscribeRaw(channel: ..., params: ..., id: ...)`를 사용하세요. `unsubscribe()`는 이제 비동기이므로 `await`하세요.

| 이전 API | 통합 API |
|---|---|
| `MisskeySubscriptionHandle.stream` | 핸들의 `messages`, `events`, `notes` 또는 `notifications` |
| `MisskeyStreamingClient.messagesFor(id)` | 해당 핸들의 `messages` |
| `MisskeyStreamingClient.messages` | `client.streaming.messages` (바깥쪽 envelope) |
| `captureNote(handle.id, noteId)` | `handle.captureNote(noteId)` |
| `uncaptureNote(handle.id, noteId)` | `handle.uncaptureNote(noteId)` |
| `MisskeyMessage` | `MisskeyStreamingMessage` |
| 수동 타입 지정 디코딩 | `MisskeyStreamingEvent` 및 `MisskeyUnknownEvent` |

## 수명 주기 및 설정 대응

| 이전 API | 통합 API |
|---|---|
| `status` 스트림 | `stateChanges` 및 현재 `state` |
| `isConnected` | `state == MisskeyStreamingConnectionState.connected` |
| 재연결 필드 | `MisskeyStreamingConfig`의 동일한 필드 |
| — | `MisskeyStreamingConfig.subscriptionTimeout` |
| `origin` | `MisskeyClientConfig.baseUrl` |
| `token` / `tokenProvider` | `MisskeyClient`의 `tokenProvider` 인자 |
| `debugLog` / `logger` 콜백 | 클라이언트의 `enableLog: true` / `logger: FunctionLogger(oldLogger)` |
| `pingInterval` | 제거됨; 공개 애플리케이션 수준 ping 타이머 없음 |
| `customHeaders` / `protocols` | 공개 통합 설정 없음 |
| `connector` | 내부 테스트 주입 전용 |
| `exceptionMapper` | 타입 지정 Streaming 예외 및 `errors` 스트림 |

연결을 재사용하려면 `disconnect()`를 사용하세요. 사용을 마치면 완전히 종료하는 `dispose()`를 호출하거나 연결을 소유한 `MisskeyClient`를 해제하세요. `MisskeyClient.dispose()`는 멱등이며 초기화된 Streaming 리소스와 HTTP 전송 계층을 모두 닫습니다.

`sendToChannel()`에 대응하는 공개 통합 API는 없습니다. 업스트림 또는 포크 프로토콜에 채널 이벤트 송신이 필요하다면 이슈를 등록하세요.

전체 예제와 이벤트 세부 정보는 [Streaming API 가이드](./streaming.md)를 참조하세요. 저장소 루트에도 [전체 마이그레이션 참고 자료](https://github.com/LibraryLibrarian/misskey_client/blob/main/MIGRATION_FROM_MISSKEY_STREAMING.md)가 있습니다.
