---
title: Streaming API
---

# Streaming API

통합 Streaming API는 WebSocket으로 타임라인, 알림 및 캡처한 노트 업데이트를 제공합니다. 지연 생성되는 `MisskeyClient.streaming`은 클라이언트의 URL, 토큰 제공자, 로거 및 로그 설정을 공유합니다.

## 구성 및 연결

연결 동작을 변경해야 할 때만 `MisskeyStreamingConfig`를 전달하세요.

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'YOUR_ACCESS_TOKEN',
  streamingConfig: MisskeyStreamingConfig(
    connectTimeout: const Duration(seconds: 15),
    subscriptionTimeout: const Duration(seconds: 10),
    enableAutoReconnect: true,
    maxReconnectAttempts: 5,
  ),
);
await client.streaming.connect();
```

토큰 제공자는 재연결을 포함한 새 연결마다 평가됩니다. 따라서 클라이언트를 다시 생성하지 않고도 갱신된 토큰을 적용할 수 있습니다. 현재 상태는 `state`, 이후 변경은 `stateChanges`, 비동기 전송·프로토콜·타임아웃·구독 오류는 `errors`로 확인합니다. 자동 재연결이나 재구독 실패를 처리해야 한다면 연결하기 전에 `errors`를 수신 대기(listen)하세요. 재사용 가능한 연결은 `connect()`, `disconnect()`, `reconnect()`로 제어하고 `dispose()`로 완전히 종료합니다. `disconnect()`는 구독이나 Streaming 클라이언트를 해제하지 않고 연결을 닫습니다.

## 공식 채널 구독

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

연결 중 `subscribe()`는 서버의 `connected` 승인 후 완료됩니다. 자동 재연결 후 구독이 다시 전송됩니다. 메인 채널, 타임라인, 사용자 목록, 해시태그, 역할, 안테나, 채널, 드라이브, 통계, 관리, Reversi 및 채팅에 타입 지정 정의를 사용할 수 있습니다.

## 이벤트 뷰 선택

| 스트림 | 내용 |
|---|---|
| `messages` | 원시 envelope을 보존한 정규화 `MisskeyStreamingMessage` |
| `events` | 타입 지정 `MisskeyStreamingEvent` |
| `notes` | 노트 이벤트에서 추출한 `MisskeyNote` |
| `notifications` | 알림 이벤트에서 추출한 `MisskeyNotification` |

```dart
final noteListener = home.notes.listen((note) => print(note.text));
final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId: $reaction');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('지원하지 않는 이벤트 $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent`는 `type`, `body`, 원본 `raw` 메시지 및 선택적 `decodeError`를 보존합니다. 서버에 추가된 이벤트도 확인할 수 있도록 폴백 분기를 유지하세요. 전역 `client.streaming.messages`는 바깥쪽 wire envelope을 보존하고 구독의 `messages`는 안쪽 이벤트로 정규화되며 해당 구독의 `subscriptionId`를 포함합니다.

## 노트 업데이트 캡처

업데이트를 받을 핸들을 통해 알려진 노트를 캡처합니다.

```dart
home.captureNote(noteId);
// events에서 reacted, unreacted, deleted, pollVoted를 수신합니다.
home.uncaptureNote(noteId);
```

캡처는 구독 간 참조 횟수로 관리되고 재연결 후 복원됩니다. 같은 핸들의 반복 호출은 멱등입니다.

## 포크 전용 채널 및 정리

Misskey 포크가 타입이 지정된 팩토리가 없는 채널을 제공하는 경우 `subscribeRaw()`를 사용합니다. `subscribeRaw()`에도 동일한 승인, 재연결, 메시지 및 정리 동작이 적용됩니다. Dart 스트림 리스너는 별도로 취소한 뒤 채널 구독을 해제하세요.

```dart
final forkChannel = await client.streaming.subscribeRaw(
  channel: 'forkSpecificChannel',
  params: const <String, Object?>{'option': true},
  id: 'optional-caller-id',
);
final listener = forkChannel.messages.listen(print);

await listener.cancel();
await forkChannel.unsubscribe();
await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();
await client.dispose();
```

명시적으로 지정한 `id`는 등록된 구독 사이에서 고유해야 하며, 현재 연결 세대의 tombstone에 남아 있는 ID도 재사용할 수 없습니다.

`unsubscribe()`와 `MisskeyClient.dispose()`는 반복 또는 동시 호출해도 안전합니다. 활성 구독은 최대 32개입니다. `MisskeyClient.dispose()`를 호출한 뒤 `client.streaming`에 접근하면 `StateError`가 발생합니다.

이전 패키지에서 이전하려면 [misskey_streaming에서 마이그레이션](./migration-from-misskey-streaming.md)을 참조하세요.
