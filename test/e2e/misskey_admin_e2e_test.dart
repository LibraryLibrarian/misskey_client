@Tags(['e2e'])
library;

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import 'e2e_env.dart';

/// fediverse_e2e 環境(misskey.test)に対するAdmin APIのE2Eテスト。
///
/// 破壊的な操作(suspend・ロール割当・アカウント削除)は、テスト内で
/// 作成した使い捨てユーザーとロールに対してのみ行う。
void main() {
  final env = E2eEnv.tryLoad();
  if (env == null) {
    test('misskey admin e2e', () {}, skip: E2eEnv.skipReason);
    return;
  }

  late MisskeyClient admin;

  setUpAll(() {
    admin = env.createMisskeyClient(admin: true);
  });

  group('admin meta', () {
    test('meta returns instance settings with raw fields', () async {
      final meta = await admin.admin.meta();
      // seedがfederation: allに設定している
      expect(meta.federation, 'all');
      expect(meta.raw, isNotEmpty);
    });

    test('updateMeta updates and restores the description', () async {
      final marker = 'e2e admin ${DateTime.now().millisecondsSinceEpoch}';
      await admin.admin.updateMeta(description: Optional(marker));
      final updated = await admin.admin.meta();
      expect(updated.description, marker);

      // 元に戻す(元はnull)
      await admin.admin.updateMeta(description: const Optional.null_());
      final restored = await admin.admin.meta();
      expect(restored.description, isNull);
    });

    test('serverInfo returns software versions', () async {
      final info = await admin.admin.serverInfo();
      expect(info.node, startsWith('v'));
      expect(info.psql, isNotEmpty);
      expect(info.redis, isNotEmpty);
    });
  });

  group('admin accounts / users', () {
    test('create -> showUser -> suspend -> unsuspend -> delete', () async {
      final username = 'e2e_tmp${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminAccounts.create(
        username: username,
        password: 'e2e-temp-pass',
      );
      expect(created.user.username, username);
      expect(created.token, isNotEmpty);

      final userId = created.user.id;
      final detail = await admin.admin.showUser(userId: userId);
      expect(detail.isSuspended, isFalse);

      await admin.admin.suspendUser(userId: userId);
      final suspended = await admin.admin.showUser(userId: userId);
      expect(suspended.isSuspended, isTrue);

      await admin.admin.unsuspendUser(userId: userId);
      final unsuspended = await admin.admin.showUser(userId: userId);
      expect(unsuspended.isSuspended, isFalse);

      await admin.adminAccounts.delete(userId: userId);
    });

    test('findByEmail reports USER_NOT_FOUND for an unused address', () async {
      // 閉域環境のアカウントはメールアドレス未設定のため、正常系は作れない。
      // エンドポイントの疎通とエラーコードのマッピングを固定する
      await expectLater(
        admin.adminAccounts.findByEmail(email: 'nobody@example.test'),
        throwsA(
          isA<MisskeyApiException>().having(
            (e) => e.code,
            'code',
            'USER_NOT_FOUND',
          ),
        ),
      );
    });

    test('deleteAccount and deleteAllFilesOfAUser work on a throwaway user',
        () async {
      final username = 'e2e_del${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminAccounts.create(
        username: username,
        password: 'e2e-temp-pass',
      );

      // 使い捨てアカウントに対してのみ実行する。世界のデータには触れない。
      // 実削除はジョブキュー経由で非同期に進むため、ここでは呼び出しが
      // 成功すること自体が検証内容
      await admin.admin.deleteAllFilesOfAUser(userId: created.user.id);
      await admin.admin.deleteAccount(userId: created.user.id);
    });

    test('showUsers filters local users', () async {
      final users = await admin.admin.showUsers(origin: 'local', limit: 100);
      expect(
        users.map((u) => u.username),
        containsAll(['e2e_admin', 'e2e_alice']),
      );
    });

    test('resetPassword returns a new 8-character password', () async {
      final username = 'e2e_pw${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminAccounts.create(
        username: username,
        password: 'e2e-temp-pass',
      );
      addTearDown(() => admin.adminAccounts.delete(userId: created.user.id));

      final password = await admin.admin.resetPassword(
        userId: created.user.id,
      );
      expect(password, hasLength(8));
    });

    test('updateUserNote sets the moderation note', () async {
      // ローカルユーザー名は最大20文字(プレフィックス+epoch13桁に収める)
      final username = 'e2e_nt${DateTime.now().millisecondsSinceEpoch}';
      final created = await admin.adminAccounts.create(
        username: username,
        password: 'e2e-temp-pass',
      );
      addTearDown(() => admin.adminAccounts.delete(userId: created.user.id));

      await admin.admin.updateUserNote(
        userId: created.user.id,
        text: 'note from e2e',
      );
      final detail = await admin.admin.showUser(userId: created.user.id);
      expect(detail.moderationNote, 'note from e2e');
    });
  });

  group('admin roles', () {
    test('create -> show -> update -> assign -> unassign -> delete', () async {
      final name = 'e2e-role-${DateTime.now().millisecondsSinceEpoch}';
      final role = await admin.adminRoles.create(
        name: name,
        description: 'created by e2e',
      );
      expect(role.name, name);
      addTearDown(() => admin.adminRoles.delete(roleId: role.id));

      final shown = await admin.adminRoles.show(roleId: role.id);
      expect(shown.id, role.id);

      await admin.adminRoles.update(
        roleId: role.id,
        description: 'updated by e2e',
      );
      final updated = await admin.adminRoles.show(roleId: role.id);
      expect(updated.description, 'updated by e2e');

      final listed = await admin.adminRoles.list();
      expect(listed.map((r) => r.id), contains(role.id));

      // e2e_alice に割り当てて確認し、外す
      final users = await admin.admin.showUsers(
        origin: 'local',
        username: 'e2e_alice',
      );
      final alice = users.singleWhere((u) => u.username == 'e2e_alice');
      await admin.adminRoles.assign(roleId: role.id, userId: alice.id);
      final assigned = await admin.adminRoles.users(roleId: role.id);
      expect(assigned.map((e) => e.user.id), contains(alice.id));

      await admin.adminRoles.unassign(roleId: role.id, userId: alice.id);
      final unassigned = await admin.adminRoles.users(roleId: role.id);
      expect(unassigned.map((e) => e.user.id), isNot(contains(alice.id)));
    });
  });

  group('admin invite', () {
    test('create and list invite codes', () async {
      final created = await admin.adminInvite.create(count: 2);
      expect(created, hasLength(2));
      expect(created.first.code, isNotEmpty);

      final listed = await admin.adminInvite.list(type: 'unused', limit: 100);
      expect(
        listed.map((c) => c.code),
        containsAll(created.map((c) => c.code)),
      );
    });
  });
}
