import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  late Map<String, dynamic> json;

  setUp(() {
    final file = File('test/fixtures/meta.json');
    json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  });

  group('Meta.fromJson', () {
    test('deserializes real API response without error', () {
      final meta = Meta.fromJson(json);
      expect(meta, isNotNull);
    });

    test('parses version correctly', () {
      final meta = Meta.fromJson(json);
      expect(meta.version, '2026.5.1');
    });

    test('parses uri correctly', () {
      final meta = Meta.fromJson(json);
      expect(meta.uri, 'https://misskey.test');
    });

    test('parses maxNoteTextLength correctly', () {
      final meta = Meta.fromJson(json);
      expect(meta.maxNoteTextLength, 3000);
    });

    test('parses nullable fields as null', () {
      final meta = Meta.fromJson(json);
      expect(meta.name, isNull);
      expect(meta.description, isNull);
    });

    test('parses boolean fields correctly', () {
      final meta = Meta.fromJson(json);
      expect(meta.disableRegistration, true);
      expect(meta.enableHcaptcha, false);
      expect(meta.enableRecaptcha, false);
      expect(meta.enableTurnstile, false);
    });

    test('stores raw JSON for capability detection', () {
      final meta = Meta.fromJson(json);
      expect(meta.raw, isNotEmpty);
      expect(meta.raw['features'], isA<Map<String, dynamic>>());
    });

    test('parses mediaProxy correctly', () {
      final meta = Meta.fromJson(json);
      expect(meta.mediaProxy, 'https://misskey.test/proxy');
    });

    test('types the remaining official metadata fields', () {
      final meta = Meta.fromJson(json);

      expect(meta.providesTarball, isFalse);
      expect(meta.federation, MisskeyFederationMode.all);
      expect(meta.noteSearchableScope, MisskeyNoteSearchableScope.global);
      expect(meta.maxFileSize, 262144000);
      expect(meta.serverRules, isEmpty);
      expect(meta.ads, isEmpty);
      expect(meta.clientOptions, isNotNull);
      expect(meta.features?.registration, isFalse);
      expect(meta.features?.miauth, isTrue);
      expect(meta.policies?.canCreateChannel, isTrue);
      expect(meta.enableUrlPreview, isTrue);
      expect(meta.mascotImageUrl, isNotEmpty);
    });

    test('round-trips every key in the real fixture', () {
      final meta = Meta.fromJson(json);
      final encoded = meta.toJson();

      expect(encoded.keys, unorderedEquals(json.keys));
      expect(encoded, json);
    });

    test('uses unknown enum fallbacks in nested and top-level metadata', () {
      final source = <String, dynamic>{
        'federation': 'fork-mode',
        'noteSearchableScope': 'friends',
        'clientOptions': <String, dynamic>{
          'entrancePageStyle': 'immersive',
          'forkLayoutVersion': 2,
        },
        'forkMetaCapability': true,
      };
      final meta = Meta.fromJson(source);

      expect(meta.federation, MisskeyFederationMode.unknown);
      expect(meta.noteSearchableScope, MisskeyNoteSearchableScope.unknown);
      expect(
        meta.clientOptions?.entrancePageStyle,
        MisskeyEntrancePageStyle.unknown,
      );

      final encoded = meta.toJson();
      expect(encoded['federation'], 'fork-mode');
      expect(encoded['noteSearchableScope'], 'friends');
      expect(encoded['clientOptions'], source['clientOptions']);
      expect(encoded['forkMetaCapability'], isTrue);
    });

    test('parses nested advertisement and Sentry objects', () {
      final meta = Meta.fromJson(<String, dynamic>{
        'ads': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'ad-1',
            'url': 'https://example.com',
            'place': 'square',
            'ratio': 1,
            'imageUrl': 'https://example.com/ad.png',
            'dayOfWeek': 127,
            'isSensitive': false,
          },
        ],
        'sentryForFrontend': <String, dynamic>{
          'options': <String, dynamic>{'dsn': 'https://dsn.example'},
          'replayIntegration': <String, dynamic>{'maskAllText': true},
        },
      });

      expect(meta.ads?.single.id, 'ad-1');
      expect(meta.ads?.single.dayOfWeek, 127);
      expect(meta.sentryForFrontend?.options.dsn, 'https://dsn.example');
      expect(meta.sentryForFrontend?.replayIntegration, {'maskAllText': true});
    });
  });
}
