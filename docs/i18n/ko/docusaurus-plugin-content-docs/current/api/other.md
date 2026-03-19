---
sidebar_position: 9
title: "기타 API"
---

# 기타 API

이 페이지에서는 채팅, 공지사항, 해시태그, 초대 코드, 서비스 워커 푸시 알림을 다룹니다.

## ChatApi

`client.chat`은 다이렉트 메시지와 그룹 룸 메시지를 제공합니다. 모든 채팅 엔드포인트는 인증이 필요합니다.

### 기록 및 읽음 상태

```dart
// 최근 DM 대화 기록
final dmHistory = await client.chat.history(limit: 10);

// 최근 룸 메시지 기록
final roomHistory = await client.chat.history(limit: 10, room: true);

// 모든 메시지 읽음으로 표시
await client.chat.readAll();
```

### 다이렉트 메시지

```dart
// 사용자에게 메시지 보내기
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: 'Hello!',
);

// 드라이브 파일 첨부
final msg = await client.chat.messages.createToUser(
  toUserId: targetUserId,
  text: '파일을 보냅니다.',
  fileId: driveFileId,
);

// 메시지 삭제
await client.chat.messages.delete(messageId: msg.id);

// 메시지에 반응
await client.chat.messages.react(messageId: msg.id, reaction: ':heart:');

// 반응 제거
await client.chat.messages.unreact(messageId: msg.id, reaction: ':heart:');
```

### 메시지 타임라인

```dart
// 사용자와의 DM 기록 (커서 기반 페이지네이션)
final messages = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
);

// 이전 메시지 가져오기
final older = await client.chat.messages.userTimeline(
  userId: targetUserId,
  limit: 20,
  untilId: messages.last.id,
);

// 룸 메시지 타임라인
final roomMessages = await client.chat.messages.roomTimeline(
  roomId: roomId,
  limit: 20,
);
```

### 메시지 검색

```dart
final results = await client.chat.messages.search(
  query: 'meeting',
  limit: 20,
  userId: targetUserId, // 선택사항: 특정 대화로 제한
);
```

### 채팅 룸

```dart
// 룸 생성
final room = await client.chat.rooms.create(
  name: 'Project Alpha',
  description: 'Coordination channel',
);

// 룸 정보 업데이트
await client.chat.rooms.update(
  roomId: room.id,
  name: 'Project Alpha — Active',
);

// 룸 삭제
await client.chat.rooms.delete(roomId: room.id);

// 참여 및 나가기
await client.chat.rooms.join(roomId: room.id);
await client.chat.rooms.leave(roomId: room.id);

// 룸 뮤트/뮤트 해제
await client.chat.rooms.setMute(roomId: room.id, mute: true);

// 멤버 목록
final members = await client.chat.rooms.members(roomId: room.id, limit: 30);

// 내가 만든 룸
final owned = await client.chat.rooms.owned(limit: 20);

// 참여한 룸
final joined = await client.chat.rooms.joining(limit: 20);
```

### 룸 초대

```dart
// 룸에 사용자 초대
await client.chat.rooms.invitationsCreate(
  roomId: room.id,
  userId: targetUserId,
);

// 받은 초대 목록
final inbox = await client.chat.rooms.invitationsInbox(limit: 20);

// 룸에 보낸 초대 목록
final outbox = await client.chat.rooms.invitationsOutbox(
  roomId: room.id,
  limit: 20,
);

// 받은 초대 무시
await client.chat.rooms.invitationsIgnore(roomId: room.id);
```

## AnnouncementsApi

`client.announcements`는 서버 공지사항을 조회합니다. 인증은 선택사항이며, 인증 시 각 항목에 `isRead` 플래그가 포함됩니다.

```dart
// 활성 공지사항 (기본값)
final active = await client.announcements.list(limit: 10);

// 비활성 공지사항도 포함
final all = await client.announcements.list(isActive: false, limit: 20);

// 단일 공지사항 상세 정보
final ann = await client.announcements.show(announcementId: ann.id);
print(ann.title);
print(ann.text);
```

`sinceId`, `untilId`, `sinceDate`, `untilDate`로 페이지네이션할 수 있습니다.

### 읽음 처리

공지사항을 읽음으로 표시할 때는 `client.account`를 사용합니다:

```dart
await client.account.readAnnouncement(announcementId: ann.id);
```

## HashtagsApi

`client.hashtags`는 해시태그 조회 및 트렌드 데이터를 제공합니다. 인증이 필요하지 않습니다.

### 목록 조회 및 검색

```dart
// 게시한 사용자 수 기준으로 정렬된 해시태그
final tags = await client.hashtags.list(
  sort: '+mentionedUsers',
  limit: 20,
);

// 접두사 검색 — 태그 이름 문자열 목록 반환
final suggestions = await client.hashtags.search(
  query: 'miss',
  limit: 10,
);
```

사용 가능한 `sort` 값: `+mentionedUsers` / `-mentionedUsers`,
`+mentionedLocalUsers` / `-mentionedLocalUsers`,
`+mentionedRemoteUsers` / `-mentionedRemoteUsers`,
`+attachedUsers` / `-attachedUsers`,
`+attachedLocalUsers` / `-attachedLocalUsers`,
`+attachedRemoteUsers` / `-attachedRemoteUsers`.

### 태그 상세 정보 및 트렌드

```dart
// 단일 태그의 상세 통계
final tag = await client.hashtags.show(tag: 'misskey');
print(tag.mentionedUsersCount);

// 트렌드 태그 (최대 10개, 60초 캐시)
final trending = await client.hashtags.trend();
for (final t in trending) {
  print('${t.tag}: ${t.chart}');
}
```

### 태그 사용자

```dart
final users = await client.hashtags.users(
  tag: 'misskey',
  sort: '+follower',
  limit: 20,
  origin: 'local', // 'local', 'remote', 또는 'combined'
  state: 'alive',  // 'all' 또는 'alive'
);
```

## InviteApi

`client.invite`는 초대 전용 서버의 초대 코드를 관리합니다. 모든 엔드포인트는 인증과 `canInvite` 역할 정책이 필요합니다.

```dart
// 초대 코드 생성
final code = await client.invite.create();
print(code.code);

// 남은 할당량 확인 (null이면 무제한)
final remaining = await client.invite.limit();
if (remaining != null) {
  print('$remaining개의 초대 코드가 남아있습니다');
}

// 발급한 코드 목록
final codes = await client.invite.list(limit: 20);

// 코드 삭제
await client.invite.delete(inviteId: code.id);
```

## SwApi

`client.sw`는 서비스 워커 푸시 알림 구독을 관리합니다. 모든 엔드포인트는 인증이 필요합니다.

### 등록

```dart
final registration = await client.sw.register(
  endpoint: 'https://push.example.com/subscribe/abc123',
  auth: 'auth-secret',
  publickey: 'vapid-public-key',
);
print(registration.state); // 'subscribed' 또는 'already-subscribed'
```

`sendReadMessage: true`를 전달하면 읽음 메시지 알림도 받을 수 있습니다.

### 등록 확인

```dart
final sub = await client.sw.showRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
if (sub != null) {
  print(sub.sendReadMessage);
}
```

### 설정 업데이트

```dart
await client.sw.updateRegistration(
  endpoint: 'https://push.example.com/subscribe/abc123',
  sendReadMessage: false,
);
```

### 등록 해제

```dart
await client.sw.unregister(
  endpoint: 'https://push.example.com/subscribe/abc123',
);
```
