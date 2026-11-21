---
sidebar_position: 4
title: "계정 및 프로필"
---

# 계정 및 프로필

`client.account` API는 현재 인증된 사용자를 위한 기능을 제공합니다. 프로필 정보 조회 및 업데이트, 인증 정보 관리, 데이터 내보내기/가져오기, 레지스트리, 2단계 인증, 웹훅을 위한 하위 API에 접근할 수 있습니다.

## 프로필 조회

```dart
final me = await client.account.i();
print(me.name);        // 표시 이름
print(me.username);    // 사용자명 (@ 없이)
print(me.description); // 소개글
```

## 프로필 업데이트

`update`는 임의의 필드 조합을 받습니다. 전달한 필드만 서버에 전송되며, 생략된 필드는 변경되지 않고 업데이트된 `MisskeyUser`가 반환됩니다.

```dart
final updated = await client.account.update(
  name: Optional('Alice'),
  description: Optional('Hello from Misskey!'),
  lang: Optional('en'),
  isLocked: false,
);
```

### Optional 타입

서버가 `null`로 받아들여 값을 지울 수 있는 필드에는 `Optional<T>` 래퍼를 사용합니다. 이를 통해 라이브러리가 세 가지 상태를 구분할 수 있습니다:

- 파라미터 생략 — 요청에 필드가 포함되지 않으며 서버 값이 변경되지 않습니다.
- `Optional('value')` — 필드가 지정된 값으로 설정됩니다.
- `Optional.null_()` — 필드가 명시적으로 지워집니다.

```dart
// 아바타를 드라이브 파일로 설정하고 생일을 지우기
await client.account.update(
  avatarId: Optional('driveFileId123'),
  birthday: Optional.null_(),
);
```

### 개인정보 및 공개 범위

```dart
await client.account.update(
  followingVisibility: 'followers', // 'public', 'followers', 또는 'private'
  followersVisibility: 'public',
  publicReactions: true,
  isLocked: true,                   // 팔로우 승인 필요
  hideOnlineStatus: true,
  noCrawle: true,
  preventAiLearning: true,
);
```

## 노트 고정 및 해제

```dart
// 프로필에 노트 고정
final updated = await client.account.pin(noteId: noteId);

// 고정 해제
final updated = await client.account.unpin(noteId: noteId);
```

두 메서드 모두 업데이트된 `MisskeyUser`를 반환합니다.

## 즐겨찾기

```dart
final favs = await client.account.favorites(limit: 20);
for (final fav in favs) {
  print(fav.note?.text);
}
```

`sinceId` / `untilId` 또는 `sinceDate` / `untilDate` (밀리초 단위 Unix 타임스탬프)로 페이지네이션할 수 있습니다.

```dart
final older = await client.account.favorites(
  limit: 20,
  untilId: favs.last.id,
);
```

## 비밀번호, 이메일 및 토큰 관리

### 비밀번호 변경

```dart
await client.account.changePassword(
  currentPassword: 'hunter2',
  newPassword: 'correct-horse-battery-staple',
);
```

2단계 인증이 활성화된 경우 현재 TOTP 코드를 `token`으로 전달합니다.

### 이메일 주소 업데이트

```dart
final updated = await client.account.updateEmail(
  password: 'mypassword',
  email: Optional('newemail@example.com'),
);

// 이메일 주소 제거
await client.account.updateEmail(
  password: 'mypassword',
  email: Optional.null_(),
);
```

### API 토큰 재생성

호출이 완료되면 현재 토큰은 즉시 무효화됩니다.

```dart
await client.account.regenerateToken(password: 'mypassword');
```

### 토큰 폐기

```dart
await client.account.revokeTokenById(tokenId);
await client.account.revokeTokenByToken(tokenString);
```

`revokeTokenById`에는 토큰의 레코드 ID(`client.account.apps()` 등으로 조회)를, `revokeTokenByToken`에는 토큰 문자열을 전달합니다. 이 엔드포인트는 Misskey 12.27.0에서, 문자열 지정 방식은 2023.11.0에서 추가되었습니다. 두 방식 모두 2026.5.1, 2026.7.0, 2026.9.0, 2026.9.1에서 지원됩니다.

인증이 필요합니다. Misskey 2026.5.1과 2026.7.0에서는 사용자의 기본 API 토큰이 필요합니다. 2026.9.0부터는 서드파티 액세스 토큰도 자신의 ID 또는 문자열을 전달하여 자기 자신을 폐기할 수 있습니다. 같은 사용자가 소유한 다른 액세스 토큰은 폐기할 수 없습니다. 기본 API 토큰으로는 해당 사용자가 소유한 모든 액세스 토큰을 폐기할 수 있습니다.

두 메서드 모두 응답 본문을 반환하지 않습니다(HTTP 204). 대상이 없거나 본인 소유가 아닌 경우, 토큰 문자열이 비어 있는 경우에는 아무것도 변경하지 않습니다. Misskey 2026.9.0 이후의 주요 오류는 인증 정보가 없을 때의 `CREDENTIAL_REQUIRED`와 액세스 토큰으로 같은 사용자의 다른 토큰을 폐기하려 할 때의 `PERMISSION_DENIED`입니다.

## 내보내기 및 가져오기

모든 내보내기 작업은 비동기 작업으로 대기열에 추가됩니다. 완료 시 알림이 전송됩니다.

### 데이터 내보내기

```dart
await client.account.exportNotes();
await client.account.exportFollowing(excludeMuting: true, excludeInactive: true);
await client.account.exportBlocking();
await client.account.exportMute();
await client.account.exportFavorites();
await client.account.exportAntennas();
await client.account.exportClips();
await client.account.exportUserLists();
```

### 데이터 가져오기

이전에 내보낸 파일의 드라이브 파일 ID를 전달합니다.

```dart
// 먼저 파일을 드라이브에 업로드한 다음 ID를 전달합니다
await client.account.importFollowing(fileId: driveFileId, withReplies: true);
await client.account.importBlocking(fileId: driveFileId);
await client.account.importMuting(fileId: driveFileId);
await client.account.importAntennas(fileId: driveFileId);
await client.account.importUserLists(fileId: driveFileId);
```

## 로그인 기록

```dart
final history = await client.account.signinHistory(limit: 20);
for (final entry in history) {
  print('${entry.createdAt} — ${entry.ip}');
}
```

## 하위 API

`AccountApi`는 세 가지 하위 API를 속성으로 제공합니다.

### 레지스트리

레지스트리는 클라이언트 애플리케이션을 위한 임의의 키-값 데이터를 저장합니다 (브라우저의 localStorage와 동일하지만 기기 간에 동기화됩니다).

`registry.set`으로 `null`을 저장하면 `registry.get`은 `null`을 반환합니다. 저장한 문자열은 그대로의 문자열로 반환됩니다.

```dart
// 값 읽기
final value = await client.account.registry.get(
  key: 'theme',
  scope: ['my-app'],
);

// 값 쓰기
await client.account.registry.set(
  key: 'theme',
  value: 'dark',
  scope: ['my-app'],
);
```

### 2단계 인증

```dart
// TOTP 등록 시작
final reg = await client.account.twoFactor.register(password: 'mypassword');
final qr = reg.qr ?? generateQrDataUrl(reg.url);
print(qr); // UI에 표시할 QR 코드 데이터 URL

// 인증 앱의 첫 번째 코드로 TOTP 확인 및 활성화
await client.account.twoFactor.done(token: '123456');
```

Misskey 2026.11.0부터는 `qr`이 반환되지 않습니다. 이 예제의 `generateQrDataUrl`은 QR 코드 라이브러리를 사용하여 `reg.url`의 `otpauth` URL을 QR 이미지 데이터 URL로 변환하도록 앱에서 구현하는 함수입니다.

### 웹훅

```dart
// 웹훅 생성
final webhook = await client.account.webhooks.create(
  name: 'My webhook',
  url: 'https://example.com/hook',
  on: ['note', 'follow'],
  secret: 'supersecret',
);

// 웹훅 목록 조회
final webhooks = await client.account.webhooks.list();
```
