import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> loadObject(String path) =>
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

  Map<String, dynamic> effectivePolicies(String path) =>
      loadObject(path)['policies'] as Map<String, dynamic>;

  group('MisskeyRolePolicies', () {
    test('types every policy key in the real meta fixture', () {
      final json = effectivePolicies('test/fixtures/meta.json');
      final policies = MisskeyRolePolicies.fromJson(json);

      expect(policies.gtlAvailable, isTrue);
      expect(policies.canPublicNote, isTrue);
      expect(policies.mentionLimit, 20);
      expect(policies.canCreateChannel, isTrue);
      expect(policies.maxFileSizeMb, 30);
      expect(policies.chatAvailability, MisskeyChatAvailability.available);
      expect(policies.uploadableFileTypes, contains('image/*'));
      expect(policies.noteDraftLimit, 10);
      expect(policies.scheduledNoteLimit, 1);
      expect(policies.watermarkAvailable, isTrue);
      expect(policies.raw.keys, unorderedEquals(json.keys));
      expect(policies.toJson(), json);
    });

    test('is shared only by effective-policy response shapes', () {
      final meta = Meta.fromJson(loadObject('test/fixtures/meta.json'));
      final adminMeta = MisskeyAdminMeta.fromJson(
        loadObject('test/fixtures/admin_meta.json'),
      );
      final user = MisskeyUser.fromJson(loadObject('test/fixtures/i.json'));
      final adminUser = MisskeyAdminUserDetail.fromJson(
        loadObject('test/fixtures/admin_show_user.json'),
      );

      for (final policies in [
        meta.policies,
        adminMeta.policies,
        user.policies,
        adminUser.policies,
      ]) {
        expect(policies, isA<MisskeyRolePolicies>());
        expect(policies!.canCreateChannel, isTrue);
        expect(policies.toJson(), effectivePolicies('test/fixtures/meta.json'));
      }
    });

    test('preserves unknown keys and falls back for an unknown enum value', () {
      final json = <String, dynamic>{
        'canInvite': true,
        'chatAvailability': 'fork-only-mode',
        'forkQuota': <String, dynamic>{'daily': 12},
      };
      final policies = MisskeyRolePolicies.fromJson(json);

      expect(policies.canInvite, isTrue);
      expect(policies.chatAvailability, MisskeyChatAvailability.unknown);
      expect(policies.raw['forkQuota'], {'daily': 12});
      expect(
        () => (policies.raw['forkQuota'] as Map<String, dynamic>)['daily'] = 0,
        throwsUnsupportedError,
      );
      expect(policies.toJson()['forkQuota'], {'daily': 12});
      expect(policies.toJson()['chatAvailability'], 'fork-only-mode');
    });

    test('keeps missing known keys distinguishable from explicit values', () {
      final policies = MisskeyRolePolicies.fromJson(<String, dynamic>{
        'canInvite': false,
      });

      expect(policies.canInvite, isFalse);
      expect(policies.canCreateChannel, isNull);
      expect(policies.raw.keys, ['canInvite']);
      expect(policies.toJson(), {'canInvite': false});
    });

    for (final factor in <num>[0.3, 1.5]) {
      test('round-trips a fractional rateLimitFactor of $factor', () {
        final policies = MisskeyRolePolicies.fromJson(<String, dynamic>{
          'rateLimitFactor': factor,
        });

        expect(policies.rateLimitFactor, factor);
        expect(policies.toJson(), {'rateLimitFactor': factor});
        expect(
          MisskeyRolePolicies.fromJson(policies.toJson()).rateLimitFactor,
          factor,
        );
      });
    }
  });

  group('MisskeyRolePolicyOverride', () {
    test('round-trips the structurally different role policy fixture', () {
      final roles =
          jsonDecode(File('test/fixtures/roles_list.json').readAsStringSync())
              as List<dynamic>;
      final roleJson = roles.first as Map<String, dynamic>;
      final role = MisskeyRole.fromJson(roleJson);

      expect(role.policies!['mentionLimit']!.value, 20);
      expect(role.policies!['mentionLimit']!.useDefault, isTrue);
      expect(role.policies!['mentionLimit']!.priority, 0);
      expect(role.toJson()['policies'], roleJson['policies']);
    });

    test('retains a previously unknown policy name', () {
      final roles =
          jsonDecode(File('test/fixtures/roles_list.json').readAsStringSync())
              as List<dynamic>;
      final json = Map<String, dynamic>.from(
        roles.first as Map<String, dynamic>,
      );
      final policies = Map<String, dynamic>.from(
        json['policies'] as Map<String, dynamic>,
      );
      policies['forkUploadPolicy'] = <String, dynamic>{
        'useDefault': false,
        'priority': 2,
        'value': <String>['fork/type'],
      };
      json['policies'] = policies;
      final role = MisskeyRole.fromJson(json);
      final override = role.policies!['forkUploadPolicy']!;

      expect(override.useDefault, isFalse);
      expect(override.priority, 2);
      expect(override.value, ['fork/type']);
      expect(
        (role.toJson()['policies'] as Map<String, dynamic>)['forkUploadPolicy'],
        policies['forkUploadPolicy'],
      );
    });
  });
}
