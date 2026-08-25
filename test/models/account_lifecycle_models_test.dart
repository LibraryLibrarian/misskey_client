import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  test('username availability fixture round-trips', () {
    final json =
        jsonDecode(
              File(
                'test/fixtures/username_availability.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;

    final availability = MisskeyUsernameAvailability.fromJson(json);

    expect(availability.available, isTrue);
    expect(availability.toJson(), json);
  });

  test('email address availability fixture round-trips', () {
    final json =
        jsonDecode(
              File(
                'test/fixtures/email_address_availability.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;

    final availability = MisskeyEmailAddressAvailability.fromJson(json);

    expect(availability.available, isFalse);
    expect(availability.reason, 'used');
    expect(availability.toJson(), json);
  });

  test('email address availability preserves a fork-specific reason', () {
    final availability = MisskeyEmailAddressAvailability.fromJson(const {
      'available': false,
      'reason': 'fork-policy',
    });

    expect(availability.reason, 'fork-policy');
    expect(availability.toJson()['reason'], 'fork-policy');
  });
}
