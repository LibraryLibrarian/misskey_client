import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../../support/fake_drive_server.dart';

void main() {
  const megabyte = 1024 * 1024;

  DriveUploadPreflight preflight({
    MisskeyRolePolicies? policies,
    DriveCapacityInfo capacity = const DriveCapacityInfo(
      capacity: 10 * megabyte,
      usage: 0,
    ),
    bool bypassesPolicyLimits = false,
    int? instanceMaxFileSize,
  }) => DriveUploadPreflight(
    policies: policies,
    capacity: capacity,
    bypassesPolicyLimits: bypassesPolicyLimits,
    instanceMaxFileSize: instanceMaxFileSize,
  );

  MisskeyRolePolicies policies({
    int? maxFileSizeMb = 1,
    int? driveCapacityMb = 10,
    List<String>? uploadableFileTypes = const ['image/*'],
  }) => MisskeyRolePolicies(
    maxFileSizeMb: maxFileSizeMb,
    driveCapacityMb: driveCapacityMb,
    uploadableFileTypes: uploadableFileTypes,
  );

  group('DriveUploadPreflight', () {
    test(
      'allows a policy size limit boundary and blocks one byte above it',
      () {
        final snapshot = preflight(policies: policies());

        expect(snapshot.check(size: megabyte).issues, isEmpty);
        final issue = snapshot.check(size: megabyte + 1).issues.single;
        expect(issue, isA<DriveUploadFileTooLarge>());
        expect((issue as DriveUploadFileTooLarge).instanceLimit, isFalse);
        expect(issue.maxSize, megabyte);
      },
    );

    test('allows a capacity boundary and blocks one byte above it', () {
      final snapshot = preflight(
        policies: policies(),
        capacity: const DriveCapacityInfo(capacity: 100, usage: 60),
      );

      expect(snapshot.check(size: 40).issues, isEmpty);
      final issue = snapshot.check(size: 41).issues.single;
      expect(issue, isA<DriveUploadInsufficientCapacity>());
      expect((issue as DriveUploadInsufficientCapacity).availableBytes, 40);
    });

    test('moderators bypass policy limits but not instance limits', () {
      final snapshot = preflight(
        policies: policies(),
        capacity: const DriveCapacityInfo(capacity: 100, usage: 100),
        bypassesPolicyLimits: true,
        instanceMaxFileSize: 10,
      );

      final issues = snapshot.check(size: 11, mimeType: 'video/mp4').issues;
      expect(issues, hasLength(1));
      expect(issues.single, isA<DriveUploadFileTooLarge>());
      expect((issues.single as DriveUploadFileTooLarge).instanceLimit, isTrue);
    });

    test(
      'matches MIME type patterns and reports a disallowed type advisory',
      () {
        final any = preflight(
          policies: policies(uploadableFileTypes: const ['*']),
        );
        final anySubtype = preflight(
          policies: policies(uploadableFileTypes: const ['*/*']),
        );
        final image = preflight(
          policies: policies(uploadableFileTypes: const ['image/*']),
        );
        final exact = preflight(
          policies: policies(uploadableFileTypes: const ['video/mp4']),
        );

        expect(any.check(size: 1, mimeType: 'video/mp4').issues, isEmpty);
        expect(
          anySubtype.check(size: 1, mimeType: 'video/mp4').issues,
          isEmpty,
        );
        expect(image.check(size: 1, mimeType: 'image/png').issues, isEmpty);
        expect(exact.check(size: 1, mimeType: 'video/mp4').issues, isEmpty);
        expect(exact.check(size: 1).issues, isEmpty);

        final issue = image.check(size: 1, mimeType: 'video/mp4').issues.single;
        expect(issue, isA<DriveUploadTypeNotAllowed>());
        expect(issue.severity, DriveUploadIssueSeverity.advisory);
      },
    );

    test('reports unavailable policies and skips unavailable checks', () {
      final absent = preflight(policies: null);
      final absentIssue = absent.check(size: 100).issues.single;
      expect(absentIssue, isA<DriveUploadPoliciesUnavailable>());
      expect((absentIssue as DriveUploadPoliciesUnavailable).missing, [
        'policies',
      ]);

      final partial = preflight(
        policies: policies(
          maxFileSizeMb: null,
          driveCapacityMb: null,
          uploadableFileTypes: null,
        ),
        capacity: const DriveCapacityInfo(capacity: 1, usage: 1),
      );
      final partialIssue = partial.check(size: megabyte).issues.single;
      expect(partialIssue, isA<DriveUploadPoliciesUnavailable>());
      expect((partialIssue as DriveUploadPoliciesUnavailable).missing, [
        'maxFileSizeMb',
        'driveCapacityMb',
        'uploadableFileTypes',
      ]);
    });

    test('checks cumulative capacity and returns post-upload snapshots', () {
      final snapshot = preflight(
        policies: policies(),
        capacity: const DriveCapacityInfo(capacity: 100, usage: 0),
      );

      final checks = snapshot.checkAll([
        (size: 60, mimeType: null),
        (size: 41, mimeType: null),
      ]);
      expect(checks.first.canUpload, isTrue);
      expect(checks.last.issues.single, isA<DriveUploadInsufficientCapacity>());

      final afterUpload = snapshot.afterUpload(60);
      expect(afterUpload.capacity.usage, 60);
      expect(afterUpload.check(size: 40).canUpload, isTrue);
      expect(() => snapshot.check(size: -1), throwsArgumentError);
      expect(() => snapshot.afterUpload(-1), throwsArgumentError);
    });

    test('applies the instance multipart limit', () {
      final snapshot = preflight(
        policies: policies(maxFileSizeMb: 100),
        instanceMaxFileSize: 50,
      );

      expect(snapshot.check(size: 50).issues, isEmpty);
      final issue = snapshot.check(size: 51).issues.single;
      expect(issue, isA<DriveUploadFileTooLarge>());
      expect((issue as DriveUploadFileTooLarge).instanceLimit, isTrue);
    });
  });

  group('DriveApi.getUploadPreflight', () {
    test('requests the current user and Drive capacity', () async {
      final server = FakeDriveServer(
        policies: {
          'maxFileSizeMb': 1,
          'driveCapacityMb': 100,
          'uploadableFileTypes': ['image/*'],
        },
      );

      final snapshot = await server.client.drive.getUploadPreflight();

      expect(snapshot.policies?.maxFileSizeMb, 1);
      expect(snapshot.capacity.capacity, server.capacity);
      expect(server.adapter.paths, containsAll(['/i', '/drive']));
      await server.client.dispose();
    });

    test(
      'uses a supplied Meta instance limit without requesting meta',
      () async {
        final server = FakeDriveServer(
          policies: {
            'maxFileSizeMb': 100,
            'driveCapacityMb': 100,
            'uploadableFileTypes': ['*'],
          },
        );

        final snapshot = await server.client.drive.getUploadPreflight(
          meta: const Meta(maxFileSize: 50),
        );

        expect(snapshot.instanceMaxFileSize, 50);
        expect(server.adapter.paths, unorderedEquals(['/i', '/drive']));
        await server.client.dispose();
      },
    );
  });
}
