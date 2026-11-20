import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyTotpRegistration', () {
    const registration = {
      'url': 'otpauth://totp/Misskey:alice?secret=SECRET&issuer=Misskey',
      'secret': 'SECRET',
      'label': 'alice',
      'issuer': 'Misskey',
    };

    test('parses older responses containing a QR image', () {
      final value = MisskeyTotpRegistration.fromJson({
        ...registration,
        'qr': 'data:image/png;base64,cXJjb2Rl',
      });

      expect(value.qr, 'data:image/png;base64,cXJjb2Rl');
      expect(value.toJson()['qr'], value.qr);
    });

    test('parses Misskey 2026.11 responses without a QR image', () {
      final value = MisskeyTotpRegistration.fromJson(registration);

      expect(value.qr, isNull);
      expect(value.url, registration['url']);
      expect(value.secret, 'SECRET');
      expect(value.label, 'alice');
      expect(value.issuer, 'Misskey');
      expect(MisskeyTotpRegistration.fromJson(value.toJson()), value);
    });

    test('accepts an explicitly null QR image', () {
      final value = MisskeyTotpRegistration.fromJson({
        ...registration,
        'qr': null,
      });

      expect(value.qr, isNull);
    });
  });

  group('MisskeyAdminAnnouncement.autoArchiveAt', () {
    const announcement = {
      'id': 'announcement-id',
      'title': 'News',
      'text': 'Details',
    };

    test('parses and round-trips the scheduled date', () {
      final value = MisskeyAdminAnnouncement.fromJson({
        ...announcement,
        'autoArchiveAt': '2026-12-01T00:00:00.000Z',
      });

      expect(value.autoArchiveAt, DateTime.utc(2026, 12, 1));
      expect(value.toJson()['autoArchiveAt'], '2026-12-01T00:00:00.000Z');
      expect(MisskeyAdminAnnouncement.fromJson(value.toJson()), value);
    });

    test('accepts omitted and explicitly null dates', () {
      expect(
        MisskeyAdminAnnouncement.fromJson(announcement).autoArchiveAt,
        isNull,
      );
      expect(
        MisskeyAdminAnnouncement.fromJson({
          ...announcement,
          'autoArchiveAt': null,
        }).autoArchiveAt,
        isNull,
      );
    });
  });

  group('MisskeyUser follow approval settings', () {
    const user = {'id': 'user-id', 'username': 'alice'};

    test('parses numeric values and round-trips them', () {
      final value = MisskeyUser.fromJson({
        ...user,
        'followApprovalLocalSeconds': 0,
        'followApprovalRemoteSeconds': 2592000.0,
      });

      expect(value.followApprovalLocalSeconds, 0);
      expect(value.followApprovalRemoteSeconds, 2592000);
      expect(value.toJson()['followApprovalLocalSeconds'], 0);
      expect(value.toJson()['followApprovalRemoteSeconds'], 2592000);
      expect(MisskeyUser.fromJson(value.toJson()), value);
    });

    test('accepts omitted and explicitly null settings', () {
      for (final json in [
        user,
        {
          ...user,
          'followApprovalLocalSeconds': null,
          'followApprovalRemoteSeconds': null,
        },
      ]) {
        final value = MisskeyUser.fromJson(json);

        expect(value.followApprovalLocalSeconds, isNull);
        expect(value.followApprovalRemoteSeconds, isNull);
      }
    });
  });
}
