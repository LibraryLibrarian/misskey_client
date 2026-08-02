import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyUser.fromJson', () {
    test('deserializes full user detail (users/show)', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.id, isNotEmpty);
      expect(user.username, 'mk_ann');
      expect(user.host, isNull);
    });

    test('deserializes authenticated user (i)', () {
      final file = File('test/fixtures/i.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.id, isNotEmpty);
      expect(user.username, isNotEmpty);
    });

    test('parses DateTime fields correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.createdAt, isA<DateTime>());
      expect(user.updatedAt, isA<DateTime>());
      expect(user.lastFetchedAt, isNull);
    });

    test('parses profile fields correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.name, 'Mk Ann');
      expect(user.description, isNotEmpty);
      expect(user.location, isNull);
      expect(user.birthday, isNull);
    });

    test('parses counts correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.followersCount, isNonNegative);
      expect(user.followingCount, isNonNegative);
      expect(user.notesCount, isPositive);
    });

    test('parses boolean flags correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.isBot, false);
      expect(user.isCat, false);
      expect(user.isLocked, false);
      expect(user.isSilenced, false);
      expect(user.isSuspended, false);
    });

    test('parses collections correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.fields, hasLength(2));
      expect(user.pinnedNotes, isEmpty);
      expect(user.avatarDecorations, isEmpty);
    });

    test('fields has correct values', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      final names = user.fields!.map((f) => f.name);
      expect(names, containsAll(['Website', 'GitHub']));
      final github = user.fields!.firstWhere((f) => f.name == 'GitHub');
      expect(github.value, contains('github.com'));
    });

    test('parses avatarUrl correctly', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.avatarUrl, contains('identicon'));
    });

    test('deserializes inline UserLite from note', () {
      final file = File('test/fixtures/notes_show.json');
      final noteJson =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final userJson = noteJson['user'] as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(userJson);

      expect(user.id, isNotEmpty);
      expect(user.username, isNotEmpty);
      // UserLite にはカウントフィールドがないが @JsonKey(defaultValue: 0) により 0 になる
      expect(user.followersCount, 0);
      expect(user.notesCount, 0);
    });

    // 一般ユーザーの users/show では isAdmin/isModerator は false になる。
    // true になるケースの検証は MisskeyAdminUserDetail 側で担保している
    test('parses admin and moderator flags from users/show', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.isAdmin, false);
      expect(user.isModerator, false);
    });

    test('parses privacy settings from users/show', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.noCrawle, false);
      expect(user.preventAiLearning, true);
      expect(user.isExplorable, true);
      expect(user.isDeleted, false);
      expect(user.hideOnlineStatus, false);
    });

    test('parses nullable account id fields from users/show', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.pinnedPageId, isNull);
      expect(user.avatarId, isNull);
      expect(user.bannerId, isNull);
    });

    test('parses notification settings from users/show', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.autoAcceptFollowed, true);
      expect(user.carefulBot, false);
      expect(user.alwaysMarkNsfw, false);
    });

    test('parses chat fields from users/show', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.chatScope, isNotEmpty);
      expect(user.canChat, true);
    });

    test('parses policies map from users/show', () {
      final file = File('test/fixtures/users_show.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.policies, isNotNull);
      expect(user.policies, isA<Map<String, dynamic>>());
      // canCreateChannel はモデルに専用フィールドを持たないが、
      // policies が動的Mapのため個別実装なしでアクセスできる
      expect(user.policies!.containsKey('canCreateChannel'), isTrue);
    });

    test('parses email fields from i', () {
      final file = File('test/fixtures/i.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.email, isNull);
      expect(user.emailVerified, false);
      expect(user.loggedInDays, greaterThanOrEqualTo(0));
    });

    test('parses unread states from i', () {
      final file = File('test/fixtures/i.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.hasUnreadAnnouncement, false);
      expect(user.hasUnreadNotification, false);
      expect(user.hasUnreadMentions, false);
      expect(user.hasUnreadSpecifiedNotes, false);
      expect(user.hasUnreadAntenna, false);
      expect(user.hasUnreadChannel, false);
      expect(user.hasPendingReceivedFollowRequest, false);
    });

    test('parses muting config from i', () {
      final file = File('test/fixtures/i.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(json);

      expect(user.mutedWords, isEmpty);
      expect(user.mutedInstances, isEmpty);
    });

    test('UserLite fields absent in notes/show default correctly', () {
      final file = File('test/fixtures/notes_show.json');
      final noteJson =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final userJson = noteJson['user'] as Map<String, dynamic>;
      final user = MisskeyUser.fromJson(userJson);

      // UserLite には admin/mod フラグや policies が含まれないのでデフォルト値になる
      expect(user.isAdmin, false);
      expect(user.isModerator, false);
      expect(user.policies, isNull);
    });
  });

  group('MisskeyUser remote user (users_show_remote)', () {
    late MisskeyUser user;

    setUp(() {
      final file = File('test/fixtures/users_show_remote.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      user = MisskeyUser.fromJson(json);
    });

    test('deserializes without error', () {
      expect(user, isNotNull);
    });

    test('host is not null for remote user', () {
      expect(user.host, isNotNull);
      expect(user.host, 'mastodon.test');
    });

    test('instance is not null', () {
      expect(user.instance, isNotNull);
    });

    test('instance has expected softwareName', () {
      expect(user.instance!.softwareName, 'mastodon');
    });

    test('instance has expected name', () {
      expect(user.instance!.name, 'Mastodon');
    });

    test('instance has iconUrl', () {
      expect(user.instance!.iconUrl, isNotNull);
      expect(user.instance!.iconUrl, startsWith('https://'));
    });

    test('instance has themeColor', () {
      expect(user.instance!.themeColor, isNotEmpty);
    });

    // isLimited/mutualLinkSections は閉域環境のリモートユーザーでは
    // null で返る(未確定/未設定の意味。nullable型として安全に扱える)
    test('isLimited is nullable and does not throw', () {
      expect(() => user.isLimited, returnsNormally);
    });

    test('mutualLinkSections is nullable and does not throw', () {
      expect(() => user.mutualLinkSections, returnsNormally);
    });
  });

  group('MisskeyBadgeRole and MisskeyRoleLite (users_show_with_role)', () {
    late MisskeyUser user;

    setUp(() {
      final file = File('test/fixtures/users_show_with_role.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      user = MisskeyUser.fromJson(json);
    });

    test('deserializes without error', () {
      expect(user, isNotNull);
      expect(user.username, 'testuser2');
    });

    test('badgeRoles is not empty', () {
      expect(user.badgeRoles, isNotEmpty);
    });

    test('first badgeRole has name "Test Role"', () {
      expect(user.badgeRoles![0].name, 'Test Role');
    });

    test('roles is not empty', () {
      expect(user.roles, isNotEmpty);
    });

    test('first role has name "Test Role" and a non-empty id', () {
      expect(user.roles![0].name, 'Test Role');
      expect(user.roles![0].id, isNotEmpty);
    });
  });
}
