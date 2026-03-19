import '../client/auth_mode.dart';
import '../client/misskey_http.dart';
import '../client/request_options.dart';
import '../models/misskey_note.dart';
import '../models/misskey_role.dart';
import '../models/misskey_role_user.dart';

/// Provides role-related API endpoints (`/api/roles/*`).
///
/// Supports listing, showing details, fetching notes, and retrieving users
/// for public roles.
class RolesApi {
  const RolesApi({required this.http});

  final MisskeyHttp http;

  /// Fetches the list of public roles (`/api/roles/list`).
  ///
  /// Only returns roles that are both `isPublic` and `isExplorable`.
  /// Authentication required. No parameters.
  Future<List<MisskeyRole>> list() async {
    final res = await http.send<List<dynamic>>(
      '/roles/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRole.fromJson)
        .toList();
  }

  /// Retrieves detailed information for a role (`/api/roles/show`).
  ///
  /// Only public roles can be retrieved. No authentication required.
  ///
  /// Pass the role ID in [roleId].
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist or is not public
  Future<MisskeyRole> show({required String roleId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/roles/show',
      body: <String, dynamic>{'roleId': roleId},
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return MisskeyRole.fromJson(res);
  }

  /// Fetches the timeline (notes) for a role (`/api/roles/notes`).
  ///
  /// Returns notes from users belonging to the specified role.
  /// Authentication required.
  ///
  /// Pass the role ID in [roleId].
  /// Use [limit] to cap the number of results (1–100, default 10).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist
  Future<List<MisskeyNote>> notes({
    required String roleId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'roleId': roleId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/roles/notes',
      body: body,
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyNote.fromJson)
        .toList();
  }

  /// Fetches users belonging to a role (`/api/roles/users`).
  ///
  /// Only returns users from public and explorable roles.
  /// No authentication required.
  ///
  /// Pass the role ID in [roleId].
  /// Use [limit] to cap the number of results (1–100, default 10).
  /// Pass [sinceId] or [untilId] for cursor-based pagination, or
  /// [sinceDate] / [untilDate] for timestamp-based pagination in Unix milliseconds.
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist or is not public
  Future<List<MisskeyRoleUser>> users({
    required String roleId,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'roleId': roleId,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/roles/users',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.none,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRoleUser.fromJson)
        .toList();
  }
}
