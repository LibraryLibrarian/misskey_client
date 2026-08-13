import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/admin/misskey_ad.dart';

/// Provides advertisement management admin APIs (`/api/admin/ad/*`).
///
/// All endpoints require administrator privileges.
class AdminAdApi {
  const AdminAdApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Creates an advertisement (`/api/admin/ad/create`).
  ///
  /// [place] is the placement (`square`, `horizontal`, `horizontal-big`)
  /// and [priority] is `high`, `middle`, or `low`. [ratio] weights how
  /// often the ad is chosen. [expiresAt] and [startsAt] are epoch
  /// timestamps in milliseconds. [dayOfWeek] is a bit flag selecting the
  /// days to display on (`0` means every day).
  Future<MisskeyAd> create({
    required String url,
    required String memo,
    required String place,
    required String priority,
    required int ratio,
    required int expiresAt,
    required int startsAt,
    required String imageUrl,
    required int dayOfWeek,
    bool? isSensitive,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/ad/create',
      body: <String, dynamic>{
        'url': url,
        'memo': memo,
        'place': place,
        'priority': priority,
        'ratio': ratio,
        'expiresAt': expiresAt,
        'startsAt': startsAt,
        'imageUrl': imageUrl,
        'dayOfWeek': dayOfWeek,
        'isSensitive': ?isSensitive,
      },
    );
    return MisskeyAd.fromJson(res);
  }

  /// Fetches advertisements (`/api/admin/ad/list`).
  ///
  /// Use [limit] (1-100, default 10) to cap the number of results and
  /// [sinceId] / [untilId] for cursor-based pagination. Set [publishing]
  /// to `true` to list only currently published ads, or `false` for ads
  /// that are not currently published.
  Future<List<MisskeyAd>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    bool? publishing,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/ad/list',
      body: <String, dynamic>{
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
        'publishing': ?publishing,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAd.fromJson)
        .toList();
  }

  /// Updates an advertisement (`/api/admin/ad/update`).
  ///
  /// Only the parameters that are provided are sent; omitted parameters
  /// remain unchanged.
  ///
  /// Common errors:
  /// - `NO_SUCH_AD`: The specified advertisement does not exist
  Future<void> update({
    required String id,
    String? memo,
    String? url,
    String? imageUrl,
    String? place,
    String? priority,
    int? ratio,
    int? expiresAt,
    int? startsAt,
    int? dayOfWeek,
    bool? isSensitive,
  }) => http.send<Object?>(
    '/admin/ad/update',
    body: <String, dynamic>{
      'id': id,
      'memo': ?memo,
      'url': ?url,
      'imageUrl': ?imageUrl,
      'place': ?place,
      'priority': ?priority,
      'ratio': ?ratio,
      'expiresAt': ?expiresAt,
      'startsAt': ?startsAt,
      'dayOfWeek': ?dayOfWeek,
      'isSensitive': ?isSensitive,
    },
  );

  /// Deletes an advertisement (`/api/admin/ad/delete`).
  ///
  /// Common errors:
  /// - `NO_SUCH_AD`: The specified advertisement does not exist
  Future<void> delete({required String id}) =>
      http.send<Object?>('/admin/ad/delete', body: <String, dynamic>{'id': id});
}
