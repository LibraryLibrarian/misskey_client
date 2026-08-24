import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:test/test.dart';

const _expectedAdminMethodCount = 99;

const _clientAccessors = <String, String>{
  'AdminApi': 'admin',
  'AdminAbuseReportsApi': 'adminAbuseReports',
  'AdminAccountsApi': 'adminAccounts',
  'AdminAdApi': 'adminAd',
  'AdminAnnouncementsApi': 'adminAnnouncements',
  'AdminAvatarDecorationsApi': 'adminAvatarDecorations',
  'AdminCaptchaApi': 'adminCaptcha',
  'AdminDriveApi': 'adminDrive',
  'AdminEmojiApi': 'adminEmoji',
  'AdminFederationApi': 'adminFederation',
  'AdminInviteApi': 'adminInvite',
  'AdminQueueApi': 'adminQueue',
  'AdminRelaysApi': 'adminRelays',
  'AdminRolesApi': 'adminRoles',
  'AdminSystemWebhookApi': 'adminSystemWebhook',
};

/// Admin methods intentionally excluded from E2E execution.
///
/// Each entry records the blast radius that prevents safe verification in the
/// shared closed-federation environment. A method not listed here must have an
/// invocation in an Admin E2E suite. Individual scenarios may still be
/// conditional on external services, such as the Mailpit SMTP configuration.
const excludedAdminE2eMethods = <String, String>{
  'AdminAbuseReportsApi.forward':
      'Forwards a report to another server and creates an external moderation '
      'side effect that cannot be recalled.',
  'AdminDriveApi.cleanRemoteFiles':
      'Purges cached remote files instance-wide and invalidates federation '
      'fixtures used by other suites.',
  'AdminDriveApi.cleanup':
      'Deletes unused drive files instance-wide without an isolated target.',
  'AdminEmojiApi.deleteBulk':
      'Bulk deletion has a wider partial-failure blast radius than the '
      'single-emoji lifecycle test.',
  'AdminEmojiApi.importZip':
      'Starts an asynchronous bulk import with no atomic rollback or reliable '
      'completion boundary.',
  'AdminFederationApi.deleteAllFiles':
      'Purges every cached file for a federated host and breaks shared remote '
      'media fixtures.',
  'AdminFederationApi.removeAllFollowing':
      'Destroys the shared cross-server following graph.',
  'AdminQueueApi.clear':
      'Deletes shared queue jobs by state and can invalidate unrelated E2E '
      'delivery work.',
  'AdminQueueApi.promoteJobs':
      'Promotes every delayed job in a shared queue and changes global '
      'scheduling.',
  'AdminQueueApi.removeJob':
      'Requires mutating a real shared queue job with no isolated fixture.',
  'AdminQueueApi.retryJob':
      'Retries a real shared failed job and can duplicate external delivery '
      'side effects.',
  'AdminRolesApi.updateDefaultPolicies':
      'Changes instance-wide defaults for all users and cannot be isolated '
      'from concurrently created accounts.',
};

void main() {
  test('all Admin methods have E2E invocations or explicit exclusions', () {
    final methods = _discoverAdminMethods();

    expect(
      methods,
      hasLength(_expectedAdminMethodCount),
      reason: 'Admin API追加時はE2E呼び出しまたは理由付き除外を棚卸ししてください',
    );
    expect(
      excludedAdminE2eMethods,
      hasLength(12),
      reason: '破壊的除外の追加・削除には理由の再監査が必要です',
    );
    expect(
      excludedAdminE2eMethods.values.every(
        (reason) => reason.trim().isNotEmpty,
      ),
      isTrue,
      reason: '除外には空でない理由が必要です',
    );
    expect(
      excludedAdminE2eMethods.keys.toSet().difference(methods),
      isEmpty,
      reason: '存在しないAdminメソッドが除外リストに残っています',
    );

    final invocations = _discoverAdminE2eInvocations();
    final uncovered = <String>[];
    final executedExclusions = <String>[];
    for (final qualifiedName in methods) {
      final separator = qualifiedName.indexOf('.');
      final className = qualifiedName.substring(0, separator);
      final methodName = qualifiedName.substring(separator + 1);
      final accessor = _clientAccessors[className];
      final isInvoked =
          accessor != null && invocations.contains('$accessor.$methodName');
      if (excludedAdminE2eMethods.containsKey(qualifiedName)) {
        if (isInvoked) executedExclusions.add(qualifiedName);
      } else if (!isInvoked) {
        uncovered.add(qualifiedName);
      }
    }

    expect(uncovered, isEmpty, reason: '除外されていないAdminメソッドにはE2E呼び出しが必要です');
    expect(
      executedExclusions,
      isEmpty,
      reason: '破壊的な明示除外メソッドをE2Eから呼び出してはいけません',
    );
    expect(
      methods.length - excludedAdminE2eMethods.length,
      87,
      reason: '99件の内訳はE2E呼び出し87件・理由付き除外12件です',
    );
  });

  test('AST audit ignores comments and string lookalikes', () {
    final methods = <String>{};
    _parseSource(r'''
class AdminFakeApi {
  // Future<void> commentedOut() async {}
  static const lookalike = 'Future<void> stringOnly()';
  Future<void> realMethod() async {}
}
''').accept(_AdminMethodDeclarationVisitor(methods));
    expect(methods, {'AdminFakeApi.realMethod'});

    final invocations = <String>{};
    _parseSource(r'''
void exercise(dynamic admin) {
  // admin.adminQueue.clear();
  const lookalike = 'admin.adminQueue.promoteJobs()';
  admin.adminQueue.stats();
}
''').accept(_AdminInvocationVisitor(invocations));
    expect(invocations, {'adminQueue.stats'});
  });
}

Set<String> _discoverAdminMethods() {
  final methods = <String>{};

  for (final file in Directory(
    'lib/src/api/admin',
  ).listSync().whereType<File>()) {
    if (!file.path.endsWith('.dart')) continue;
    final unit = _parse(file);
    unit.accept(_AdminMethodDeclarationVisitor(methods));
  }
  return methods;
}

Set<String> _discoverAdminE2eInvocations() {
  final invocations = <String>{};
  for (final file in Directory('test/e2e').listSync().whereType<File>()) {
    if (!file.path.endsWith('_e2e_test.dart')) continue;
    _parse(file).accept(_AdminInvocationVisitor(invocations));
  }
  return invocations;
}

CompilationUnit _parse(File file) => parseString(
  content: file.readAsStringSync(),
  path: file.path,
  throwIfDiagnostics: true,
).unit;

CompilationUnit _parseSource(String source) =>
    parseString(content: source, throwIfDiagnostics: true).unit;

final class _AdminMethodDeclarationVisitor extends RecursiveAstVisitor<void> {
  _AdminMethodDeclarationVisitor(this.methods);

  final Set<String> methods;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final className = node.namePart.typeName.lexeme;
    if (!RegExp(r'^Admin(?:\w+)?Api$').hasMatch(className)) return;
    final body = node.body;
    if (body is! BlockClassBody) return;
    for (final member in body.members.whereType<MethodDeclaration>()) {
      if (member.isStatic || member.name.lexeme.startsWith('_')) continue;
      if (member.returnType?.toSource().startsWith('Future') != true) continue;
      methods.add('$className.${member.name.lexeme}');
    }
  }
}

final class _AdminInvocationVisitor extends RecursiveAstVisitor<void> {
  _AdminInvocationVisitor(this.invocations);

  final Set<String> invocations;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.target?.toSource();
    if (target != null) {
      for (final accessor in _clientAccessors.values) {
        if (target == accessor || target.endsWith('.$accessor')) {
          invocations.add('$accessor.${node.methodName.name}');
        }
      }
    }
    super.visitMethodInvocation(node);
  }
}
