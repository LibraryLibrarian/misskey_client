import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('freezed trial', () {
    test('keeps public named construction and field access compatible', () {
      const user = MisskeyUser(id: 'user-id', username: 'alice');
      const meta = Meta(version: '2026.8.0');
      const adminMeta = MisskeyAdminMeta(name: 'example');

      expect(user.id, 'user-id');
      expect(user.username, 'alice');
      expect(meta.version, '2026.8.0');
      expect(adminMeta.name, 'example');
      expect(user.copyWith(username: 'bob').username, 'bob');
    });

    test('keeps JsonKey defaults for missing and null values', () {
      final missing = MisskeyUser.fromJson(const {
        'id': 'user-id',
        'username': 'alice',
      });
      final explicitNull = MisskeyUser.fromJson(const {
        'id': 'user-id',
        'username': 'alice',
        'name': null,
        'isBot': null,
        'emojis': null,
        'fields': null,
        'followersCount': null,
      });

      for (final user in [missing, explicitNull]) {
        expect(user.name, '');
        expect(user.emojis, isEmpty);
        expect(user.fields, isEmpty);
        expect(user.followersCount, 0);
        expect(user.followingCount, 0);
        expect(user.notesCount, 0);
        expect(user.unreadNotificationsCount, 0);
        expect(user.loggedInDays, 0);
        expect([
          user.isBot,
          user.isCat,
          user.isLocked,
          user.isSuspended,
          user.isSilenced,
          user.requireSigninToViewContents,
          user.publicReactions,
          user.withReplies,
          user.twoFactorEnabled,
          user.usePasswordLessLogin,
          user.securityKeys,
          user.isAdmin,
          user.isModerator,
          user.noCrawle,
          user.preventAiLearning,
          user.hideOnlineStatus,
          user.isExplorable,
          user.isDeleted,
          user.injectFeaturedNote,
          user.receiveAnnouncementEmail,
          user.alwaysMarkNsfw,
          user.autoSensitive,
          user.carefulBot,
          user.autoAcceptFollowed,
          user.canChat,
          user.hasUnreadSpecifiedNotes,
          user.hasUnreadMentions,
          user.hasUnreadChatMessages,
          user.hasUnreadAnnouncement,
          user.hasUnreadAntenna,
          user.hasUnreadChannel,
          user.hasUnreadNotification,
          user.hasPendingReceivedFollowRequest,
          user.emailVerified,
          user.isLimited,
        ], everyElement(isFalse));
      }

      expect(Meta.fromJson(const {}).maxNoteTextLength, 3000);
      expect(Meta.fromJson(const {}).notesPerOneAd, 0);
      expect(
        Meta.fromJson(const {'maxNoteTextLength': null}).maxNoteTextLength,
        3000,
      );
      expect(Meta.fromJson(const {'notesPerOneAd': null}).notesPerOneAd, 0);
    });

    test('keeps SafeDateTimeConverter behavior in both directions', () {
      final json = _loadFixture('users_show.json');
      final user = MisskeyUser.fromJson(json);

      expect(user.createdAt, isA<DateTime>());
      expect(user.toJson()['createdAt'], json['createdAt']);
      expect(user.toJson()['updatedAt'], json['updatedAt']);
      expect(user.toJson()['lastFetchedAt'], isNull);
    });

    test('keeps MutedWordListConverter behavior in both directions', () {
      final json = _loadFixture('i.json');
      final user = MisskeyUser.fromJson(json);

      expect(user.mutedWords, hasLength(2));
      expect(user.hardMutedWords, hasLength(2));
      expect(user.toJson()['mutedWords'], json['mutedWords']);
      expect(user.toJson()['hardMutedWords'], json['hardMutedWords']);
    });

    for (final fixture in ['meta.json', 'users_show.json', 'admin_meta.json']) {
      test('$fixture has a byte-stable JSON round trip', () {
        final json = _loadFixture(fixture);
        final first = switch (fixture) {
          'meta.json' => jsonEncode(Meta.fromJson(json).toJson()),
          'users_show.json' => jsonEncode(MisskeyUser.fromJson(json).toJson()),
          'admin_meta.json' => jsonEncode(
            MisskeyAdminMeta.fromJson(json).toJson(),
          ),
          _ => throw StateError('Unexpected fixture: $fixture'),
        };
        final serialized = jsonDecode(first) as Map<String, dynamic>;
        final second = switch (fixture) {
          'meta.json' => jsonEncode(Meta.fromJson(serialized).toJson()),
          'users_show.json' => jsonEncode(
            MisskeyUser.fromJson(serialized).toJson(),
          ),
          'admin_meta.json' => jsonEncode(
            MisskeyAdminMeta.fromJson(serialized).toJson(),
          ),
          _ => throw StateError('Unexpected fixture: $fixture'),
        };

        expect(utf8.encode(second), utf8.encode(first));
      });
    }

    test('equal Meta values with identical raw payloads compare equal', () {
      final json = _loadFixture('meta.json');

      expect(
        Meta.fromJson(json),
        Meta.fromJson(jsonDecode(jsonEncode(json)) as Map<String, dynamic>),
      );
    });

    test('a fork-only raw field makes otherwise equal Meta values unequal', () {
      final json = _loadFixture('meta.json');
      final first = Meta.fromJson({...json, 'forkCapability': true});
      final second = Meta.fromJson({...json, 'forkCapability': false});

      expect(
        first.copyWith(raw: const RawMetaPayload.empty()),
        second.copyWith(raw: const RawMetaPayload.empty()),
      );
      expect(first, isNot(second));
    });

    test('raw operator reads values using the previous syntax', () {
      final meta = Meta.fromJson({..._loadFixture('meta.json'), 'forkKey': 42});

      expect(meta.raw['forkKey'], 42);
    });

    test('MisskeyAdminMeta uses the same raw fingerprint behavior', () {
      final json = _loadFixture('admin_meta.json');
      final first = MisskeyAdminMeta.fromJson({...json, 'forkSetting': 'a'});
      final second = MisskeyAdminMeta.fromJson({...json, 'forkSetting': 'b'});

      expect(first, isNot(second));
      expect(first.raw['forkSetting'], 'a');
    });

    test('DriveCapacityInfo supports value equality and copyWith', () {
      const first = DriveCapacityInfo(capacity: 1024, usage: 256);
      const second = DriveCapacityInfo(capacity: 1024, usage: 256);
      final copied = first.copyWith(usage: 512);

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(copied.capacity, first.capacity);
      expect(copied.usage, 512);
      expect(copied, isNot(first));
      expect(
        first.toString(),
        'DriveCapacityInfo(Usage: 256.00 B / 1024.00 B (25.0%))',
      );
    });

    test('MisskeyHashtagTrend supports value equality and copyWith', () {
      const first = MisskeyHashtagTrend(
        tag: 'dart',
        chart: [1, 2, 3],
        usersCount: 4,
      );
      const second = MisskeyHashtagTrend(
        tag: 'dart',
        chart: [1, 2, 3],
        usersCount: 4,
      );
      final copied = first.copyWith(usersCount: 5);

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(copied.tag, first.tag);
      expect(copied.chart, first.chart);
      expect(copied.usersCount, 5);
      expect(copied, isNot(first));
    });

    test('MisskeySwRegistration supports value equality and copyWith', () {
      const first = MisskeySwRegistration(
        state: 'subscribed',
        key: 'key',
        userId: 'user-id',
        endpoint: 'https://example.com/push',
        sendReadMessage: true,
      );
      const second = MisskeySwRegistration(
        state: 'subscribed',
        key: 'key',
        userId: 'user-id',
        endpoint: 'https://example.com/push',
        sendReadMessage: true,
      );
      final copied = first.copyWith(endpoint: 'https://example.com/new-push');

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(copied.state, first.state);
      expect(copied.userId, first.userId);
      expect(copied.sendReadMessage, first.sendReadMessage);
      expect(copied.endpoint, 'https://example.com/new-push');
      expect(copied, isNot(first));
      expect(first.isNewSubscription, isTrue);
      expect(first.isAlreadySubscribed, isFalse);
    });

    test('raw equality does not revisit payload values', () {
      final firstProbe = _HashProbe();
      final secondProbe = _HashProbe();
      final first = RawMetaPayload({'probe': firstProbe});
      final second = RawMetaPayload({'probe': secondProbe});
      firstProbe.hashReads = 0;
      secondProbe.hashReads = 0;

      expect(first, second);
      expect(firstProbe.hashReads, 0);
      expect(secondProbe.hashReads, 0);
    });
  });
}

Map<String, dynamic> _loadFixture(String name) {
  final file = File('test/fixtures/$name');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

final class _HashProbe {
  int hashReads = 0;

  @override
  bool operator ==(Object other) => other is _HashProbe;

  @override
  int get hashCode {
    hashReads++;
    return 42;
  }
}
