import '../../client/auth_mode.dart';
import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/users/misskey_user_list.dart';
import '../../models/users/misskey_user_list_membership.dart';

/// Provides user list API endpoints (`/api/users/lists/*`).
class UserListsApi {
  const UserListsApi({required this.http});

  final MisskeyHttp http;

  /// Fetches user lists.
  ///
  /// Returns public lists for the specified [userId].
  /// If omitted, returns the authenticated user's own lists.
  Future<List<MisskeyUserList>> list({String? userId}) async {
    final body = <String, dynamic>{
      if (userId != null) 'userId': userId,
    };
    final res = await http.send<List<dynamic>>(
      '/users/lists/list',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUserList.fromJson)
        .toList();
  }

  /// Retrieves detailed information for a list.
  ///
  /// Set [forPublic] to `true` to retrieve as a public list,
  /// which includes `likedCount` and `isLiked`.
  Future<MisskeyUserList> show({
    required String listId,
    bool? forPublic,
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (forPublic != null) 'forPublic': forPublic,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/show',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return MisskeyUserList.fromJson(res);
  }

  /// Creates a new list.
  Future<MisskeyUserList> create({required String name}) async {
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/create',
      body: <String, dynamic>{'name': name},
    );
    return MisskeyUserList.fromJson(res);
  }

  /// Creates a new list by copying a public list.
  Future<MisskeyUserList> createFromPublic({
    required String name,
    required String listId,
  }) async {
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/create-from-public',
      body: <String, dynamic>{'name': name, 'listId': listId},
    );
    return MisskeyUserList.fromJson(res);
  }

  /// Updates a list.
  ///
  /// Both [name] and [isPublic] are optional.
  /// Only specified fields are updated.
  Future<MisskeyUserList> update({
    required String listId,
    String? name,
    bool? isPublic,
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (name != null) 'name': name,
      if (isPublic != null) 'isPublic': isPublic,
    };
    final res = await http.send<Map<String, dynamic>>(
      '/users/lists/update',
      body: body,
    );
    return MisskeyUserList.fromJson(res);
  }

  /// Deletes a list.
  Future<void> delete({required String listId}) => http.send<Object?>(
        '/users/lists/delete',
        body: <String, dynamic>{'listId': listId},
      );

  /// Adds a user to a list.
  Future<void> push({
    required String listId,
    required String userId,
  }) =>
      http.send<Object?>(
        '/users/lists/push',
        body: <String, dynamic>{'listId': listId, 'userId': userId},
      );

  /// Removes a user from a list.
  Future<void> pull({
    required String listId,
    required String userId,
  }) =>
      http.send<Object?>(
        '/users/lists/pull',
        body: <String, dynamic>{'listId': listId, 'userId': userId},
      );

  /// Fetches list memberships.
  ///
  /// Set [forPublic] to `true` to retrieve members of a public list.
  /// [limit] is 1-100 (default: 30).
  Future<List<MisskeyUserListMembership>> getMemberships({
    required String listId,
    bool? forPublic,
    int? limit,
    String? sinceId,
    String? untilId,
    int? sinceDate,
    int? untilDate,
  }) async {
    final body = <String, dynamic>{
      'listId': listId,
      if (forPublic != null) 'forPublic': forPublic,
      if (limit != null) 'limit': limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      if (sinceDate != null) 'sinceDate': sinceDate,
      if (untilDate != null) 'untilDate': untilDate,
    };
    final res = await http.send<List<dynamic>>(
      '/users/lists/get-memberships',
      body: body,
      options: const RequestOptions(
        authMode: AuthMode.optional,
        idempotent: true,
      ),
    );
    return res
        .whereType<Map<String, dynamic>>()
        .map(MisskeyUserListMembership.fromJson)
        .toList();
  }

  /// Updates a membership (changes whether to include replies).
  Future<void> updateMembership({
    required String listId,
    required String userId,
    bool? withReplies,
  }) =>
      http.send<Object?>(
        '/users/lists/update-membership',
        body: <String, dynamic>{
          'listId': listId,
          'userId': userId,
          if (withReplies != null) 'withReplies': withReplies,
        },
      );

  /// Favorites a list.
  Future<void> favorite({required String listId}) => http.send<Object?>(
        '/users/lists/favorite',
        body: <String, dynamic>{'listId': listId},
      );

  /// Unfavorites a list.
  Future<void> unfavorite({required String listId}) => http.send<Object?>(
        '/users/lists/unfavorite',
        body: <String, dynamic>{'listId': listId},
      );
}
