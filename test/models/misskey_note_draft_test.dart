import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

List<dynamic> _loadFixture() {
  final file = File('test/fixtures/note_drafts.json');
  return jsonDecode(file.readAsStringSync()) as List<dynamic>;
}

void main() {
  group('MisskeyNoteDraft.fromJson', () {
    late MisskeyNoteDraft draft;

    setUp(() {
      draft = MisskeyNoteDraft.fromJson(
        _loadFixture().first as Map<String, dynamic>,
      );
    });

    test('deserializes without error', () {
      expect(draft, isNotNull);
    });

    test('id is correct', () {
      expect(draft.id, 'ak6ouoahrt4w001s');
    });

    test('userId is correct', () {
      expect(draft.userId, 'ak3po4qort4w0001');
    });

    test('includes the owner user returned by the server', () {
      expect(draft.user, isNotNull);
      expect(draft.user!.id, draft.userId);
      expect(draft.user!.username, 'testadmin');
    });

    test('text is correct', () {
      expect(draft.text, 'This is a draft note');
    });

    test('visibility is public', () {
      expect(draft.visibility, 'public');
    });

    test('localOnly is false', () {
      expect(draft.localOnly, isFalse);
    });

    test('visibleUserIds is empty', () {
      expect(draft.visibleUserIds, isEmpty);
    });

    test('fileIds is empty', () {
      expect(draft.fileIds, isEmpty);
    });

    test('includes the attached files returned by the server', () {
      expect(draft.files, isEmpty);
    });

    test('cw is null', () {
      expect(draft.cw, isNull);
    });

    test('replyId is null', () {
      expect(draft.replyId, isNull);
    });

    test('renoteId is null', () {
      expect(draft.renoteId, isNull);
    });

    test('channelId is null', () {
      expect(draft.channelId, isNull);
    });

    test('poll is null', () {
      expect(draft.poll, isNull);
    });

    test('scheduledAt is null', () {
      expect(draft.scheduledAt, isNull);
    });

    test('isActuallyScheduled is false', () {
      expect(draft.isActuallyScheduled, isFalse);
    });
  });

  // ドラフトのpollは公開ノートのpollと構造が異なり、選択肢は投票数を持たない
  // 素の文字列配列で、期限は相対指定(expiredAfter)のこともある
  group('MisskeyNoteDraft.fromJson (with a poll)', () {
    late MisskeyNoteDraft draft;

    setUp(() {
      draft = MisskeyNoteDraft.fromJson(
        _loadFixture()[1] as Map<String, dynamic>,
      );
    });

    test('deserializes without error', () {
      expect(draft.poll, isNotNull);
    });

    test('choices are plain strings', () {
      expect(draft.poll!.choices, <String>['a', 'b']);
    });

    test('multiple is false', () {
      expect(draft.poll!.multiple, isFalse);
    });

    test('expiresAt is null when no absolute deadline was set', () {
      expect(draft.poll!.expiresAt, isNull);
    });

    test('expiredAfter is null when no relative deadline was set', () {
      expect(draft.poll!.expiredAfter, isNull);
    });
  });

  group('MisskeyNoteDraft.fromJson (with embedded relationships)', () {
    late MisskeyNoteDraft draft;

    setUp(() {
      final user = <String, dynamic>{'id': 'user-1', 'username': 'alice'};
      final note = <String, dynamic>{
        'id': 'note-1',
        'createdAt': '2026-08-25T00:00:00.000Z',
        'userId': 'user-1',
        'user': user,
        'text': 'Referenced note',
      };

      draft = MisskeyNoteDraft.fromJson({
        'id': 'draft-1',
        'createdAt': '2026-08-25T01:00:00.000Z',
        'userId': 'user-1',
        'user': user,
        'visibility': 'public',
        'visibleUserIds': <String>[],
        'cw': null,
        'hashtag': null,
        'localOnly': false,
        'reactionAcceptance': null,
        'replyId': 'note-1',
        'renoteId': 'note-1',
        'channelId': 'channel-1',
        'text': 'Draft body',
        'fileIds': <String>['file-1'],
        'files': <Map<String, dynamic>>[
          {
            'id': 'file-1',
            'createdAt': '2026-08-25T00:30:00.000Z',
            'name': 'image.png',
            'type': 'image/png',
            'size': 123,
            'md5': '0123456789abcdef0123456789abcdef',
            'url': 'https://example.test/files/image.png',
          },
        ],
        'channel': {
          'id': 'channel-1',
          'name': 'Draft channel',
          'color': '#86b300',
          'isSensitive': false,
          'allowRenoteToExternal': true,
          'userId': 'user-1',
        },
        'renote': note,
        'reply': note,
        'poll': null,
        'scheduledAt': null,
        'isActuallyScheduled': false,
      });
    });

    test('deserializes a partial channel without full channel fields', () {
      expect(draft.channel, isNotNull);
      expect(draft.channel!.id, 'channel-1');
      expect(draft.channel!.name, 'Draft channel');
      expect(draft.channel!.color, '#86b300');
      expect(draft.channel!.isSensitive, isFalse);
      expect(draft.channel!.allowRenoteToExternal, isTrue);
      expect(draft.channel!.userId, 'user-1');
    });

    test('deserializes files, renote, and reply', () {
      expect(draft.files, hasLength(1));
      expect(draft.files!.single.id, 'file-1');
      expect(draft.renote?.id, 'note-1');
      expect(draft.reply?.id, 'note-1');
    });

    test('round-trips embedded relationships', () {
      final roundTripped = MisskeyNoteDraft.fromJson(draft.toJson());

      expect(roundTripped, draft);
    });
  });
}
