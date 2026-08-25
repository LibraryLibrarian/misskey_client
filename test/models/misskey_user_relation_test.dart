import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('MisskeyUserRelation.fromJson', () {
    late MisskeyUserRelation relation;

    setUp(() {
      final file = File('test/fixtures/user_relation.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      relation = MisskeyUserRelation.fromJson(
        jsonList[0] as Map<String, dynamic>,
      );
    });

    test('deserializes id correctly', () {
      expect(relation.id, 'ak3qbtu5rt4w0009');
    });

    test('isFollowing is true', () {
      expect(relation.isFollowing, true);
    });

    test('exposes the schema-undeclared following entity as raw JSON', () {
      final following = relation.following;

      expect(following, isNotNull);
      expect(following!['id'], 'ak6ovudhrt4w001t');
      expect(following['withReplies'], isFalse);
      expect(following['notify'], isNull);
      expect(following.json.containsKey('createdAt'), isFalse);
    });

    test('round-trips the schema-undeclared following entity', () {
      final file = File('test/fixtures/user_relation.json');
      final jsonList = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final json = jsonList.single as Map<String, dynamic>;

      expect(relation.toJson()['following'], json['following']);
    });

    test('following is a deeply immutable snapshot of its input', () {
      final nested = <String, dynamic>{'host': 'example.com'};
      final inboxes = <Object?>['https://example.com/inbox'];
      final following = <String, dynamic>{
        'id': 'following-1',
        'remote': nested,
        'inboxes': inboxes,
      };
      final source = <String, dynamic>{'id': 'target', 'following': following};
      final relation = MisskeyUserRelation.fromJson(source);
      final equalRelation = MisskeyUserRelation.fromJson(
        jsonDecode(jsonEncode(source)) as Map<String, dynamic>,
      );
      final initialHashCode = relation.hashCode;

      expect(relation, equalRelation);

      following['id'] = 'mutated';
      nested['host'] = 'mutated.example';
      inboxes.add('https://mutated.example/inbox');

      expect(relation.following!['id'], 'following-1');
      expect(
        (relation.following!.json['remote'] as Map<String, dynamic>)['host'],
        'example.com',
      );
      expect(relation.following!.json['inboxes'], hasLength(1));
      expect(relation, equalRelation);
      expect(relation.hashCode, initialHashCode);
    });

    test('following getter exposes deeply unmodifiable collections', () {
      final raw = relation.following!.json;

      expect(() => raw['new'] = true, throwsUnsupportedError);
      final nested = <String, dynamic>{'host': 'example.com'};
      final list = <Object?>[
        <String, dynamic>{'inbox': 'https://example.com/inbox'},
      ];
      final relationWithNested = MisskeyUserRelation(
        id: 'target',
        following: RawUserRelationFollowing(<String, dynamic>{
          'nested': nested,
          'list': list,
        }),
      );
      final following = relationWithNested.following!.json;

      expect(
        () => (following['nested'] as Map<String, dynamic>)['host'] = 'changed',
        throwsUnsupportedError,
      );
      expect(
        () => (following['list'] as List<Object?>).add('changed'),
        throwsUnsupportedError,
      );
      expect(
        () =>
            ((following['list'] as List<Object?>).single
                    as Map<String, dynamic>)['inbox'] =
                'changed',
        throwsUnsupportedError,
      );
    });

    test('toJson returns a detached deep copy of following', () {
      final nested = <String, dynamic>{'host': 'example.com'};
      final list = <Object?>[
        <String, dynamic>{'inbox': 'https://example.com/inbox'},
      ];
      final relation = MisskeyUserRelation(
        id: 'target',
        following: RawUserRelationFollowing(<String, dynamic>{
          'nested': nested,
          'list': list,
        }),
      );
      final equalRelation = MisskeyUserRelation.fromJson(relation.toJson());
      final initialHashCode = relation.hashCode;
      final encoded = relation.toJson();
      final encodedFollowing = encoded['following'] as Map<String, dynamic>;

      encodedFollowing['new'] = true;
      (encodedFollowing['nested'] as Map<String, dynamic>)['host'] = 'changed';
      ((encodedFollowing['list'] as List<Object?>).single
              as Map<String, dynamic>)['inbox'] =
          'changed';

      expect(relation.following!.json.containsKey('new'), isFalse);
      expect(
        (relation.following!.json['nested'] as Map<String, dynamic>)['host'],
        'example.com',
      );
      expect(
        ((relation.following!.json['list'] as List<Object?>).single
            as Map<String, dynamic>)['inbox'],
        'https://example.com/inbox',
      );
      expect(relation, equalRelation);
      expect(relation.hashCode, initialHashCode);
    });

    test('keeps following null when the server omits it', () {
      final relation = MisskeyUserRelation.fromJson(<String, dynamic>{
        'id': 'target',
      });

      expect(relation.following, isNull);
    });

    test('isFollowed is false', () {
      expect(relation.isFollowed, false);
    });

    test('hasPendingFollowRequestFromYou is false', () {
      expect(relation.hasPendingFollowRequestFromYou, false);
    });

    test('hasPendingFollowRequestToYou is false', () {
      expect(relation.hasPendingFollowRequestToYou, false);
    });

    test('isBlocking is false', () {
      expect(relation.isBlocking, false);
    });

    test('isBlocked is false', () {
      expect(relation.isBlocked, false);
    });

    test('isMuted is false', () {
      expect(relation.isMuted, false);
    });

    test('isRenoteMuted is false', () {
      expect(relation.isRenoteMuted, false);
    });
  });
}
