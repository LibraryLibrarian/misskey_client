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
}
