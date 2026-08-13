import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../internal/request_body.dart';
import '../../models/admin/misskey_admin_avatar_decoration.dart';

/// Provides avatar decoration management admin APIs
/// (`/api/admin/avatar-decorations/*`).
///
/// All endpoints require administrator privileges.
class AdminAvatarDecorationsApi {
  const AdminAvatarDecorationsApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Registers an avatar decoration
  /// (`/api/admin/avatar-decorations/create`).
  ///
  /// Pass [roleIdsThatCanBeUsedThisDecoration] to restrict the decoration
  /// to specific roles; an empty list allows everyone.
  Future<MisskeyAdminAvatarDecoration> create({
    required String name,
    required String description,
    required String url,
    List<String>? roleIdsThatCanBeUsedThisDecoration,
    String? category,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/avatar-decorations/create',
      body: <String, dynamic>{
        'name': name,
        'description': description,
        'url': url,
        'roleIdsThatCanBeUsedThisDecoration':
            ?roleIdsThatCanBeUsedThisDecoration,
        'category': ?category,
      },
    );
    return MisskeyAdminAvatarDecoration.fromJson(res);
  }

  /// Fetches avatar decorations (`/api/admin/avatar-decorations/list`).
  ///
  /// Use [limit] (1-100, default 10) to cap the number of results and
  /// [sinceId] / [untilId] for cursor-based pagination. Pass [userId] to
  /// list only decorations available to that user.
  Future<List<MisskeyAdminAvatarDecoration>> list({
    int? limit,
    String? sinceId,
    String? untilId,
    String? userId,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/avatar-decorations/list',
      body: <String, dynamic>{
        'limit': ?limit,
        'sinceId': ?sinceId,
        'untilId': ?untilId,
        'userId': ?userId,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyAdminAvatarDecoration.fromJson)
        .toList();
  }

  /// Updates an avatar decoration
  /// (`/api/admin/avatar-decorations/update`).
  ///
  /// Only the parameters that are provided are sent; omitted parameters
  /// remain unchanged.
  ///
  /// For [category], use the [Optional] type: pass `Optional('value')` to set
  /// and `Optional.null_()` to clear.
  ///
  /// Common errors:
  /// - `NO_SUCH_AVATAR_DECORATION`: The specified decoration does not exist
  Future<void> update({
    required String id,
    String? name,
    String? description,
    String? url,
    List<String>? roleIdsThatCanBeUsedThisDecoration,
    Optional<String>? category,
  }) {
    final body = <String, dynamic>{
      'id': id,
      'name': ?name,
      'description': ?description,
      'url': ?url,
      'roleIdsThatCanBeUsedThisDecoration': ?roleIdsThatCanBeUsedThisDecoration,
    };
    putOptional(body, 'category', category);
    return http.send<Object?>('/admin/avatar-decorations/update', body: body);
  }

  /// Deletes an avatar decoration
  /// (`/api/admin/avatar-decorations/delete`).
  ///
  /// Common errors:
  /// - `NO_SUCH_AVATAR_DECORATION`: The specified decoration does not exist
  Future<void> delete({required String id}) => http.send<Object?>(
    '/admin/avatar-decorations/delete',
    body: <String, dynamic>{'id': id},
  );
}
