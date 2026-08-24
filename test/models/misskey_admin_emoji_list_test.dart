import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  test('v2 admin emoji list fixture parses and round-trips', () {
    final json =
        jsonDecode(
              File('test/fixtures/admin_emoji_list_v2.json').readAsStringSync(),
            )
            as Map<String, dynamic>;

    final result = MisskeyAdminEmojiListResult.fromJson(json);

    expect(result.count, 1);
    expect(result.allCount, 3);
    expect(result.allPages, 3);
    expect(result.emojis, hasLength(1));
    final emoji = result.emojis.single;
    expect(emoji.id, 'emoji-v2-1');
    expect(emoji.updatedAt, DateTime.utc(2026, 8, 25));
    expect(emoji.host, isNull);
    expect(emoji.publicUrl, endsWith('/party.webp'));
    expect(
      emoji.roleIdsThatCanBeUsedThisEmojiAsReaction.single.name,
      'Members',
    );
    expect(result.toJson(), json);
  });

  test('v2 admin emoji query omits null fields', () {
    const query = MisskeyAdminEmojiListQuery(
      name: 'party',
      isSensitive: false,
      hostType: 'local',
    );

    expect(query.toJson(), {
      'name': 'party',
      'isSensitive': false,
      'hostType': 'local',
    });
  });
}
