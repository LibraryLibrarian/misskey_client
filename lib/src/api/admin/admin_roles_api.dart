import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../internal/optional.dart';
import '../../internal/request_body.dart';
import '../../models/misskey_role.dart';
import '../../models/misskey_role_user.dart';

/// Provides role management admin APIs (`/api/admin/roles/*`).
///
/// All endpoints require administrator privileges unless noted otherwise.
class AdminRolesApi {
  const AdminRolesApi({required this.http});

  final MisskeyHttp http;

  /// Fetches all roles (`/api/admin/roles/list`).
  ///
  /// Requires moderator privileges. Unlike the public `/api/roles/list`,
  /// this includes non-public roles.
  Future<List<MisskeyRole>> list() async {
    final res = await http.send<List<dynamic>>(
      '/admin/roles/list',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRole.fromJson)
        .toList();
  }

  /// Fetches a role including non-public ones (`/api/admin/roles/show`).
  ///
  /// Requires moderator privileges.
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist
  Future<MisskeyRole> show({required String roleId}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/roles/show',
      body: <String, dynamic>{'roleId': roleId},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyRole.fromJson(res);
  }

  /// Creates a role (`/api/admin/roles/create`).
  ///
  /// Requires administrator privileges. Returns the created role.
  ///
  /// [target] is `manual` (assigned explicitly) or `conditional`
  /// (assigned by [condFormula]). [policies] maps policy names to
  /// `{useDefault, priority, value}` objects.
  Future<MisskeyRole> create({
    required String name,
    required String description,
    String? color,
    String? iconUrl,
    String target = 'manual',
    Map<String, dynamic> condFormula = const <String, dynamic>{},
    bool isPublic = false,
    bool isModerator = false,
    bool isAdministrator = false,
    bool? isExplorable,
    bool asBadge = false,
    bool? preserveAssignmentOnMoveAccount,
    bool canEditMembersByModerator = false,
    int displayOrder = 0,
    Map<String, dynamic> policies = const <String, dynamic>{},
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/roles/create',
      body: <String, dynamic>{
        'name': name,
        'description': description,
        // colorとiconUrlはnull込みで必須パラメータ
        'color': color,
        'iconUrl': iconUrl,
        'target': target,
        'condFormula': condFormula,
        'isPublic': isPublic,
        'isModerator': isModerator,
        'isAdministrator': isAdministrator,
        if (isExplorable != null) 'isExplorable': isExplorable,
        'asBadge': asBadge,
        if (preserveAssignmentOnMoveAccount != null)
          'preserveAssignmentOnMoveAccount': preserveAssignmentOnMoveAccount,
        'canEditMembersByModerator': canEditMembersByModerator,
        'displayOrder': displayOrder,
        'policies': policies,
      },
    );
    return MisskeyRole.fromJson(res);
  }

  /// Updates a role (`/api/admin/roles/update`).
  ///
  /// Requires administrator privileges. Only the parameters that are
  /// provided are sent; omitted parameters remain unchanged. [color] and
  /// [iconUrl] use the [Optional] type: pass `Optional('value')` to set
  /// and `Optional.null_()` to clear.
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist
  Future<void> update({
    required String roleId,
    String? name,
    String? description,
    Optional<String>? color,
    Optional<String>? iconUrl,
    String? target,
    Map<String, dynamic>? condFormula,
    bool? isPublic,
    bool? isModerator,
    bool? isAdministrator,
    bool? isExplorable,
    bool? asBadge,
    bool? preserveAssignmentOnMoveAccount,
    bool? canEditMembersByModerator,
    int? displayOrder,
    Map<String, dynamic>? policies,
  }) async {
    final body = <String, dynamic>{
      'roleId': roleId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (target != null) 'target': target,
      if (condFormula != null) 'condFormula': condFormula,
      if (isPublic != null) 'isPublic': isPublic,
      if (isModerator != null) 'isModerator': isModerator,
      if (isAdministrator != null) 'isAdministrator': isAdministrator,
      if (isExplorable != null) 'isExplorable': isExplorable,
      if (asBadge != null) 'asBadge': asBadge,
      if (preserveAssignmentOnMoveAccount != null)
        'preserveAssignmentOnMoveAccount': preserveAssignmentOnMoveAccount,
      if (canEditMembersByModerator != null)
        'canEditMembersByModerator': canEditMembersByModerator,
      if (displayOrder != null) 'displayOrder': displayOrder,
      if (policies != null) 'policies': policies,
    };
    putOptional(body, 'color', color);
    putOptional(body, 'iconUrl', iconUrl);
    await http.send<Object?>('/admin/roles/update', body: body);
  }

  /// Deletes a role (`/api/admin/roles/delete`).
  ///
  /// Requires administrator privileges.
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist
  Future<void> delete({required String roleId}) => http.send<Object?>(
        '/admin/roles/delete',
        body: <String, dynamic>{'roleId': roleId},
      );

  /// Assigns a role to a user (`/api/admin/roles/assign`).
  ///
  /// Requires moderator privileges (or administrator privileges when the
  /// target role is not editable by moderators). Pass [expiresAt] as an
  /// epoch timestamp in milliseconds to make the assignment temporary.
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist
  /// - `NO_SUCH_USER`: The specified user does not exist
  /// - `ACCESS_DENIED`: Not permitted to assign this role
  Future<void> assign({
    required String roleId,
    required String userId,
    int? expiresAt,
  }) =>
      http.send<Object?>(
        '/admin/roles/assign',
        body: <String, dynamic>{
          'roleId': roleId,
          'userId': userId,
          if (expiresAt != null) 'expiresAt': expiresAt,
        },
      );

  /// Removes a role from a user (`/api/admin/roles/unassign`).
  ///
  /// Requires moderator privileges (or administrator privileges when the
  /// target role is not editable by moderators).
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist
  /// - `NO_SUCH_USER`: The specified user does not exist
  /// - `NOT_ASSIGNED`: The role is not assigned to the user
  Future<void> unassign({
    required String roleId,
    required String userId,
  }) =>
      http.send<Object?>(
        '/admin/roles/unassign',
        body: <String, dynamic>{'roleId': roleId, 'userId': userId},
      );

  /// Updates the default role policies
  /// (`/api/admin/roles/update-default-policies`).
  ///
  /// Requires administrator privileges. [policies] maps policy names to
  /// their default values.
  Future<void> updateDefaultPolicies({
    required Map<String, dynamic> policies,
  }) =>
      http.send<Object?>(
        '/admin/roles/update-default-policies',
        body: <String, dynamic>{'policies': policies},
      );

  /// Fetches the users assigned to a role (`/api/admin/roles/users`).
  ///
  /// Requires moderator privileges. Use [limit] (1-100, default 10) to cap
  /// the number of results. Pass [sinceId] or [untilId] for cursor-based
  /// pagination, or [sinceDate] or [untilDate] (epoch ms) for date-based
  /// pagination.
  ///
  /// Common errors:
  /// - `NO_SUCH_ROLE`: The specified role does not exist
  Future<List<MisskeyRoleUser>> users({
    required String roleId,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
    int? limit,
  }) async {
    final res = await http.send<List<dynamic>>(
      '/admin/roles/users',
      body: <String, dynamic>{
        'roleId': roleId,
        if (sinceId != null) 'sinceId': sinceId,
        if (untilId != null) 'untilId': untilId,
        if (sinceDate != null) 'sinceDate': sinceDate,
        if (untilDate != null) 'untilDate': untilDate,
        if (limit != null) 'limit': limit,
      },
      options: const RequestOptions(idempotent: true),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyRoleUser.fromJson)
        .toList();
  }
}
