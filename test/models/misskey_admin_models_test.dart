import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyAdminMeta.fromJson', () {
    Map<String, dynamic> load() {
      final file = File('test/fixtures/admin_meta.json');
      return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    }

    test('deserializes typed fields', () {
      final meta = MisskeyAdminMeta.fromJson(load());

      expect(meta.disableRegistration, isTrue);
      expect(meta.federation, 'all');
      expect(meta.federationHosts, isEmpty);
      expect(meta.blockedHosts, isEmpty);
      expect(meta.cacheRemoteFiles, isFalse);
      expect(meta.enableEmail, isFalse);
      expect(meta.notesPerOneAd, isA<int>());
    });

    test('preserves all fields in raw', () {
      final json = load();
      final meta = MisskeyAdminMeta.fromJson(json);

      expect(meta.raw.length, json.length);
      // 型付けしていないフィールドもrawから参照できる
      expect(meta.raw['enableFanoutTimeline'], isA<bool>());
    });

    test('handles null optional fields', () {
      final meta = MisskeyAdminMeta.fromJson(load());

      expect(meta.name, isNull);
      expect(meta.description, isNull);
      expect(meta.maintainerName, isNull);
      // プロキシアカウント(instance.actor)は自動作成されるためIDが入る
      expect(meta.proxyAccountId, isNotEmpty);
    });
  });

  group('MisskeyAdminServerInfo.fromJson', () {
    test('deserializes server information', () {
      final file = File('test/fixtures/admin_server_info.json');
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final info = MisskeyAdminServerInfo.fromJson(json);

      expect(info.os, 'linux');
      expect(info.node, startsWith('v'));
      expect(info.psql, isNotEmpty);
      expect(info.redis, isNotEmpty);
      expect(info.cpu.cores, isPositive);
      expect(info.mem.total, isPositive);
      expect(info.fs.total, isPositive);
      expect(info.net?.interface, 'eth0');
    });
  });

  group('MisskeyAdminUserDetail.fromJson', () {
    Map<String, dynamic> load() {
      final file = File('test/fixtures/admin_show_user.json');
      return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    }

    test('deserializes moderation fields', () {
      final detail = MisskeyAdminUserDetail.fromJson(load());

      expect(detail.emailVerified, isFalse);
      expect(detail.isModerator, isFalse);
      expect(detail.isSilenced, isFalse);
      expect(detail.isSuspended, isFalse);
      expect(detail.moderationNote, isEmpty);
      expect(detail.policies, isNotEmpty);
      expect(detail.roles, isEmpty);
      expect(detail.roleAssigns, isEmpty);
    });

    test('deserializes signin history', () {
      final detail = MisskeyAdminUserDetail.fromJson(load());

      expect(detail.signins, isNotEmpty);
      final signin = detail.signins!.first;
      expect(signin.id, isNotEmpty);
      expect(signin.success, isTrue);
    });
  });

  group('MisskeyAdminCreatedAccount.fromJson', () {
    test('extracts user and token from the combined response', () {
      // admin/accounts/create のレスポンス = MeDetailed + token
      final json = <String, dynamic>{
        'id': 'abcdef1234567890',
        'username': 'created_user',
        'name': null,
        'host': null,
        'token': 'secret-token-value',
      };

      final created = MisskeyAdminCreatedAccount.fromJson(json);
      expect(created.user.id, 'abcdef1234567890');
      expect(created.user.username, 'created_user');
      expect(created.token, 'secret-token-value');
    });
  });

  group('admin invite fixtures', () {
    test('admin/invite/create response parses as MisskeyInviteCode list', () {
      final file = File('test/fixtures/admin_invite_create.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final codes = jsonList
          .whereType<Map<String, dynamic>>()
          .map(MisskeyInviteCode.fromJson)
          .toList();

      expect(codes, hasLength(2));
      expect(codes.first.code, isNotEmpty);
      expect(codes.first.used, isFalse);
    });
  });
}
