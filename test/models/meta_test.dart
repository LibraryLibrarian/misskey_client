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
      expect(meta.version, '2026.3.1');
    });

    test('parses uri correctly', () {
      final meta = Meta.fromJson(json);
      expect(meta.uri, 'http://localhost:3000');
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
      expect(meta.mediaProxy, 'http://localhost:3000/proxy');
    });
  });
}
