---
sidebar_position: 1
slug: /
title: 시작하기
---

# 시작하기

:::warning 베타

이 라이브러리는 현재 **베타** 단계입니다. API 구현은 완료되었으나 테스트 커버리지가 최소한입니다. 테스트 결과에 따라 응답 모델 및 메서드 시그니처가 변경될 수 있습니다.

잘못된 응답 모델이나 예상치 못한 동작을 발견하시면 [GitHub Issues](https://github.com/LibraryLibrarian/misskey_client/issues)로 보고하시거나 [Pull Request](https://github.com/LibraryLibrarian/misskey_client/pulls)를 제출해 주세요.

:::

misskey_client는 순수 Dart로 작성된 Misskey API 클라이언트 라이브러리입니다.
Flutter, 서버 사이드 Dart, CLI 도구 등 Dart가 실행되는 모든 환경에서 사용할 수 있습니다.

## 설치

`pubspec.yaml`에 의존성을 추가합니다:

```yaml
dependencies:
  misskey_client: ^1.0.0-beta.1
```

그 다음 패키지를 가져옵니다:

```bash
dart pub get
```

## 기본 사용법

### 클라이언트 초기화

```dart
import 'package:misskey_client/misskey_client.dart';

final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'your_access_token',
);
```

`baseUrl`은 스킴을 포함한 `Uri`여야 합니다 (예: `https://`).
`tokenProvider`는 `FutureOr<String?>`을 반환하는 콜백입니다. 인증이 필요하지 않은 엔드포인트만 사용할 경우 생략할 수 있습니다.

### 첫 번째 API 호출

서버 정보 가져오기 (인증 불필요):

```dart
final serverInfo = await client.meta.fetch();
print(serverInfo.name);        // 서버 이름
print(serverInfo.description); // 서버 설명
```

인증된 사용자 자신의 계정 가져오기:

```dart
final me = await client.account.i();
print(me.name);     // 표시 이름
print(me.username); // 사용자명 (@ 없이)
```

### API 구조

모든 API 도메인은 `MisskeyClient`의 속성으로 제공됩니다:

```dart
client.account       // 계정 및 프로필 관리 (/api/i/*)
client.announcements // 서버 공지사항
client.antennas      // 안테나 (키워드 모니터링) 관리
client.ap            // ActivityPub 엔드포인트
client.blocking      // 사용자 차단
client.channels      // 채널 관리
client.charts        // 통계 차트
client.chat          // 다이렉트 메시지
client.clips         // 노트 클립 관리
client.drive         // 파일 스토리지 (drive.files, drive.folders, drive.stats)
client.federation    // 연합 인스턴스 정보
client.flash         // Flash (Play) 관리
client.following     // 팔로우 / 언팔로우 작업
client.gallery       // 갤러리 게시물 관리
client.hashtags      // 해시태그 정보
client.invite        // 초대 코드 관리
client.meta          // 서버 메타데이터
client.mute          // 사용자 뮤트
client.notes         // 노트 작업 (타임라인, 작성, 반응 등)
client.notifications // 알림 조회 및 관리
client.pages         // 페이지 관리
client.renoteMute    // 리노트 뮤트 관리
client.roles         // 역할 관리
client.sw            // 서비스 워커 푸시 알림 등록
client.users         // 사용자 검색, 팔로우 목록, 사용자 목록
```

### 로그 출력 제어

HTTP 요청/응답 로그는 기본적으로 비활성화되어 있습니다. `MisskeyClientConfig`를 통해 활성화할 수 있습니다:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
    enableLog: true,
  ),
  tokenProvider: () => 'token',
);
```

로그를 직접 처리하려면 생성자에 `Logger` 구현체를 전달합니다:

```dart
final client = MisskeyClient(
  config: MisskeyClientConfig(
    baseUrl: Uri.parse('https://misskey.example.com'),
  ),
  tokenProvider: () => 'token',
  logger: FunctionLogger((level, message) {
    // level은 'debug', 'info', 'warn', 'error' 중 하나입니다
    myLogger.log(level, message);
  }),
);
```

자세한 내용은 [로깅](./advanced/logging.md)을 참고하세요.

## 다음 단계

- [인증](./authentication.md) — 토큰 기반 인증 및 MiAuth 흐름
- [오류 처리](./error-handling.md) — 예외 계층 구조 및 catch 패턴
- [노트](./api/notes.md) — 노트 작성 및 조회
- [드라이브 업로드](./advanced/drive-upload.md) — 드라이브에 파일 업로드
