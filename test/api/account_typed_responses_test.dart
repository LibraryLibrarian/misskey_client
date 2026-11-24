import 'dart:convert';
import 'dart:io';

import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

import '../support/scripted_http_adapter.dart';

void main() {
  late ScriptedHttpClientAdapter adapter;
  late MisskeyClient client;

  setUp(() {
    adapter = ScriptedHttpClientAdapter();
    client = MisskeyClient(
      config: MisskeyClientConfig(
        baseUrl: Uri.parse('https://misskey.example.com'),
      ),
      httpClientAdapter: adapter,
    );
    addTearDown(client.dispose);
  });

  group('AccountApi.pages', () {
    test('parses Pages and preserves pagination parameters', () async {
      adapter.enqueue(
        '/i/pages',
        // i/pages は me なしで pack するため isLiked を返さない
        ScriptedResponse.json([_pageJson()]),
      );

      final List<MisskeyPage> pages = await client.account.pages(
        limit: 20,
        sinceId: 'since-id',
        untilId: 'until-id',
        sinceDate: 1000,
        untilDate: 2000,
      );

      expect(pages.single.id, 'ak6oumrprt4w001r');
      expect(pages.single.title, 'Test Page');
      expect(pages.single.user?.username, 'testadmin');
      expect(
        pages.single.createdAt,
        DateTime.utc(2026, 3, 23, 11, 50, 24, 709),
      );
      expect(pages.single.isLiked, isNull);
      expect(adapter.requests.single.jsonBody, {
        'limit': 20,
        'sinceId': 'since-id',
        'untilId': 'until-id',
        'sinceDate': 1000,
        'untilDate': 2000,
      });
    });

    test('omits absent arguments', () async {
      adapter.enqueue('/i/pages', ScriptedResponse.json([_pageJson()]));

      await client.account.pages();

      expect(adapter.requests.single.jsonBody, isEmpty);
    });
  });

  group('AccountApi.pageLikes', () {
    test('parses like IDs and nested Pages', () async {
      adapter.enqueue(
        '/i/page-likes',
        ScriptedResponse.json([
          {
            'id': 'like-id',
            'page': {..._pageJson(), 'isLiked': true},
          },
        ]),
      );

      final List<MisskeyPageLike> likes = await client.account.pageLikes(
        limit: 30,
        sinceId: 'since-id',
        untilId: 'until-id',
        sinceDate: 3000,
        untilDate: 4000,
      );

      expect(likes.single.id, 'like-id');
      expect(likes.single.page.id, 'ak6oumrprt4w001r');
      expect(likes.single.page.user?.username, 'testadmin');
      expect(likes.single.page.isLiked, isTrue);
      expect(adapter.requests.single.jsonBody, {
        'limit': 30,
        'sinceId': 'since-id',
        'untilId': 'until-id',
        'sinceDate': 3000,
        'untilDate': 4000,
      });
    });

    test('accepts an omitted optional field in the nested Page', () async {
      adapter.enqueue(
        '/i/page-likes',
        ScriptedResponse.json([
          {'id': 'like-id', 'page': _pageJson()},
        ]),
      );

      final likes = await client.account.pageLikes();

      expect(likes.single.page.isLiked, isNull);
      expect(adapter.requests.single.jsonBody, isEmpty);
    });
  });

  group('AccountApi.apps', () {
    test('parses access token metadata and timestamps', () async {
      adapter.enqueue(
        '/i/apps',
        ScriptedResponse.json([
          {
            'id': 'token-id',
            'name': 'My client',
            'createdAt': '2026-05-01T12:00:00.000Z',
            'lastUsedAt': '2026-11-01T13:00:00.000Z',
            'permission': ['read:account', 'write:notes'],
            'iconUrl': 'https://example.com/icon.png',
            'description': 'My access token',
          },
        ]),
      );

      final List<MisskeyAccessToken> tokens = await client.account.apps(
        sort: '+lastUsedAt',
      );

      final token = tokens.single;
      expect(token.id, 'token-id');
      expect(token.name, 'My client');
      expect(token.createdAt, DateTime.utc(2026, 5, 1, 12));
      expect(token.lastUsedAt, DateTime.utc(2026, 11, 1, 13));
      expect(token.permission, ['read:account', 'write:notes']);
      expect(token.iconUrl, 'https://example.com/icon.png');
      expect(token.description, 'My access token');
      expect(adapter.requests.single.jsonBody, {'sort': '+lastUsedAt'});
    });

    test('accepts all optional metadata being omitted', () async {
      adapter.enqueue(
        '/i/apps',
        ScriptedResponse.json([
          {
            'id': 'unused-token-id',
            'createdAt': '2026-05-01T12:00:00.000Z',
            'permission': <String>[],
          },
        ]),
      );

      final token = (await client.account.apps()).single;

      expect(token.name, isNull);
      expect(token.lastUsedAt, isNull);
      expect(token.iconUrl, isNull);
      expect(token.description, isNull);
      expect(token.permission, isEmpty);
      expect(adapter.requests.single.jsonBody, isEmpty);
    });

    test('accepts explicitly nullable metadata', () async {
      adapter.enqueue(
        '/i/apps',
        ScriptedResponse.json([
          {
            'id': 'token-id',
            'createdAt': '2026-05-01T12:00:00.000Z',
            'permission': ['read:account'],
            'iconUrl': null,
            'description': null,
          },
        ]),
      );

      final token = (await client.account.apps()).single;

      expect(token.iconUrl, isNull);
      expect(token.description, isNull);
    });
  });

  group('AccountApi.authorizedApps', () {
    test('parses authorized applications and pagination parameters', () async {
      adapter.enqueue(
        '/i/authorized-apps',
        ScriptedResponse.json([
          {
            'id': 'app-id',
            'name': 'My application',
            'callbackUrl': 'https://example.com/callback',
            'permission': ['read:account'],
            'isAuthorized': true,
          },
        ]),
      );

      final List<MisskeyAuthorizedApp> apps = await client.account
          .authorizedApps(limit: 20, offset: 10, sort: 'asc');

      final app = apps.single;
      expect(app.id, 'app-id');
      expect(app.name, 'My application');
      expect(app.callbackUrl, 'https://example.com/callback');
      expect(app.permission, ['read:account']);
      expect(app.isAuthorized, isTrue);
      expect(adapter.requests.single.jsonBody, {
        'limit': 20,
        'offset': 10,
        'sort': 'asc',
      });
    });

    test('accepts omitted isAuthorized and a null callbackUrl', () async {
      adapter.enqueue(
        '/i/authorized-apps',
        ScriptedResponse.json([
          {
            'id': 'app-id',
            'name': 'My application',
            'callbackUrl': null,
            'permission': <String>[],
          },
        ]),
      );

      final app = (await client.account.authorizedApps()).single;

      expect(app.callbackUrl, isNull);
      expect(app.isAuthorized, isNull);
      expect(app.permission, isEmpty);
      expect(adapter.requests.single.jsonBody, isEmpty);
    });
  });
}

Map<String, dynamic> _pageJson() {
  final pages =
      jsonDecode(File('test/fixtures/pages_list.json').readAsStringSync())
          as List<dynamic>;
  return pages.single as Map<String, dynamic>;
}
