import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyNoteDraft.fromJson', () {
    late MisskeyNoteDraft draft;

    setUp(() {
      final file = File('test/fixtures/note_drafts.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      draft = MisskeyNoteDraft.fromJson(jsonList.first as Map<String, dynamic>);
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
}
