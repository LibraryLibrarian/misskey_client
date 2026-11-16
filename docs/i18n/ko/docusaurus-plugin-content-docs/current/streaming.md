---
title: Streaming API
---

# Streaming API

통합 Streaming API는 WebSocket으로 타임라인, 알림 및 캡처한 노트 업데이트를 제공합니다. 지연 생성되는 `MisskeyClient.streaming`은 클라이언트의 베이스 URL, 토큰 제공자, 로거 및 로그 설정을 공유합니다.

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

토큰 제공자는 재연결을 포함한 새 연결마다 평가됩니다. 따라서 클라이언트를 다시 생성하지 않고도 갱신된 토큰을 적용할 수 있습니다.

| 멤버 | 용도 |
|---|---|
| `state` | 현재 `MisskeyStreamingConnectionState` |
| `stateChanges` | 수신 대기를 시작한 후 발생하는 상태 변경 |
| `errors` | 비동기 전송·프로토콜·타임아웃·구독 오류 |
| `connect()` | 재사용 가능한 연결 열기 |
| `disconnect()` | 구독이나 Streaming 클라이언트를 해제하지 않고 연결 닫기 |
| `reconnect()` | 현재 연결 교체 |
| `dispose()` | Streaming 클라이언트를 완전히 해제 |

애플리케이션에서 자동 재연결이나 재구독 실패를 처리해야 한다면 연결하기 전에 `errors`를 수신 대기(listen)하세요.

## 공식 채널 구독

공식 채널에는 타입이 지정된 `MisskeyStreamingChannel` 팩토리를 사용합니다.

```dart
final home = await client.streaming.subscribe(
  const MisskeyStreamingChannel.homeTimeline(
    withRenotes: true,
    withFiles: false,
  ),
);
```

연결 중 `subscribe()`는 서버가 구독을 승인한 후 완료됩니다. 핸들은 자동 재연결 후에도 등록된 상태로 유지되며 자동으로 다시 구독됩니다.

`main`, 홈·로컬·하이브리드·글로벌 타임라인, 사용자 목록, 해시태그, 역할, 안테나, 채널, 드라이브, 서버 및 큐 통계, 관리, Reversi, 다이렉트 또는 룸 채팅 채널에 타입 지정 정의를 사용할 수 있습니다.

## 이벤트 뷰 선택

구독은 자신에게 라우팅된 메시지를 여러 뷰로 제공합니다.

| 스트림 | 내용 |
|---|---|
| `messages` | 디코딩된 원시 envelope을 보존한 정규화된 `MisskeyStreamingMessage` 값 |
| `events` | 타입 지정 `MisskeyStreamingEvent` 값 |
| `notes` | 노트 이벤트에서 추출한 `MisskeyNote` 값 |
| `notifications` | 알림 이벤트에서 추출한 `MisskeyNotification` 값 |

```dart
final noteListener = home.notes.listen((note) {
  print(note.text);
});

final eventListener = home.events.listen((event) {
  switch (event) {
    case MisskeyNoteReactedEvent(:final noteId, :final reaction):
      print('$noteId에 $reaction 반응이 추가되었습니다');
    case MisskeyUnknownEvent(:final type, :final decodeError):
      print('지원하지 않는 이벤트 $type: $decodeError');
    default:
      break;
  }
});
```

`MisskeyUnknownEvent`는 정규화된 `type`, `body`, 원본 `raw` 메시지 및 선택적 `decodeError`를 보존합니다. 서버에 추가된 이벤트도 확인할 수 있도록 폴백 분기를 유지하세요.

전역 `client.streaming.messages` 스트림은 바깥쪽 wire envelope을 보존합니다. 구독으로 라우팅된 메시지는 안쪽 이벤트로 정규화되며 해당 구독의 `subscriptionId`를 포함합니다.

## 노트 업데이트 캡처

업데이트를 받을 핸들을 통해 알려진 노트를 캡처합니다.

```dart
home.captureNote(noteId);
// home.events에서 reacted, unreacted, deleted, pollVoted 이벤트를 수신할 수 있습니다.

home.uncaptureNote(noteId);
```

캡처 호출은 구독 간 참조 횟수로 관리되고 재연결 후 복원됩니다. 같은 핸들의 반복적인 캡처 또는 캡처 해제 호출은 멱등입니다.

## 포크 전용 채널

Misskey 포크가 타입이 지정된 팩토리가 없는 채널을 제공하는 경우 `subscribeRaw()`를 사용합니다.

```dart
final forkChannel = await client.streaming.subscribeRaw(
  channel: 'forkSpecificChannel',
  params: const <String, Object?>{'option': true},
  id: 'optional-caller-id',
);

final listener = forkChannel.messages.listen((message) {
  print('${message.type}: ${message.body}');
});
```

동일한 승인, 재연결, 메시지 및 정리 동작이 적용됩니다. 명시적으로 지정한 ID는 등록된 구독 사이에서 고유해야 하며, 현재 연결 세대의 tombstone에 남아 있는 ID도 재사용할 수 없습니다.

## 정리

Dart 스트림 리스너는 별도로 취소한 뒤 채널 구독을 해제하세요.

```dart
await listener.cancel();
await forkChannel.unsubscribe();

await noteListener.cancel();
await eventListener.cancel();
await home.unsubscribe();

await client.dispose();
```

`unsubscribe()`와 `MisskeyClient.dispose()`는 반복 또는 동시 호출해도 안전합니다. 클라이언트 하나당 활성 Streaming 구독은 최대 32개입니다. 클라이언트를 해제한 뒤 `client.streaming`에 접근하면 `StateError`가 발생합니다.

이전 패키지에서 이전하려면 [misskey_streaming에서 마이그레이션](./migration-from-misskey-streaming.md)을 참조하세요.
