import 'package:misskey_client/misskey_client.dart';
import 'package:test/test.dart';

void main() {
  group('ApShowResult.fromJson', () {
    test('keeps an unknown type as ApShowUnknown', () {
      final result = ApShowResult.fromJson({
        'type': 'Page',
        'object': {'id': 'page1', 'name': 'about'},
      });

      expect(result, isA<ApShowUnknown>());
      final unknown = result as ApShowUnknown;
      expect(unknown.type, 'Page');
      expect(unknown.object, {'id': 'page1', 'name': 'about'});
    });
  });
}
