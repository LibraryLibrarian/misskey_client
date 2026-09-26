import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_user_relation.freezed.dart';
part 'misskey_user_relation.g.dart';

/// The relationship between users, returned by `/api/users/relation`.
@freezed
@JsonSerializable()
class MisskeyUserRelation with _$MisskeyUserRelation {
  const MisskeyUserRelation({
    required this.id,
    this.following,
    this.isFollowing = false,
    this.hasPendingFollowRequestFromYou = false,
    this.hasPendingFollowRequestToYou = false,
    this.isFollowed = false,
    this.isBlocking = false,
    this.isBlocked = false,
    this.isMuted = false,
    this.isRenoteMuted = false,
  });

  factory MisskeyUserRelation.fromJson(Map<String, dynamic> json) =>
      _$MisskeyUserRelationFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyUserRelationToJson(this);

  /// The target user's ID.
  @override
  final String id;

  /// The raw follow entity returned by some Misskey servers.
  ///
  /// This field is not declared by the official `/api/users/relation`
  /// response schema and may disappear or change without notice. It is kept
  /// as an immutable raw payload because the current response is a database
  /// entity, not the packed shape represented by `MisskeyFollowing` (for
  /// example, it omits `createdAt` and exposes denormalized inbox fields).
  @override
  final RawUserRelationFollowing? following;

  /// Whether you are following this user.
  @JsonKey(defaultValue: false)
  @override
  final bool isFollowing;

  /// Whether you have a pending follow request to this user.
  @JsonKey(defaultValue: false)
  @override
  final bool hasPendingFollowRequestFromYou;

  /// Whether this user has a pending follow request to you.
  @JsonKey(defaultValue: false)
  @override
  final bool hasPendingFollowRequestToYou;

  /// Whether this user is following you.
  @JsonKey(defaultValue: false)
  @override
  final bool isFollowed;

  /// Whether you are blocking this user.
  @JsonKey(defaultValue: false)
  @override
  final bool isBlocking;

  /// Whether this user is blocking you.
  @JsonKey(defaultValue: false)
  @override
  final bool isBlocked;

  /// Whether you are muting this user.
  @JsonKey(defaultValue: false)
  @override
  final bool isMuted;

  /// Whether you are muting renotes from this user.
  @JsonKey(defaultValue: false)
  @override
  final bool isRenoteMuted;
}

/// An immutable snapshot of the schema-undeclared `following` response field.
///
/// The payload deliberately makes no typed-field compatibility promise. Use
/// [json] or [operator []] to inspect the current server-provided wire shape.
final class RawUserRelationFollowing {
  /// Creates a deeply immutable snapshot of [json].
  factory RawUserRelationFollowing(Map<String, dynamic> json) {
    final snapshot = _freezeMap(json);
    return RawUserRelationFollowing._(
      snapshot,
      const DeepCollectionEquality().hash(snapshot),
    );
  }

  const RawUserRelationFollowing._(this.json, this._fingerprint);

  /// Creates a snapshot from a JSON response.
  factory RawUserRelationFollowing.fromJson(Map<String, dynamic> json) =>
      RawUserRelationFollowing(json);

  /// The deeply immutable raw JSON snapshot.
  final Map<String, dynamic> json;

  final int _fingerprint;

  /// Returns the raw value associated with [key].
  dynamic operator [](Object? key) => json[key];

  /// Returns a detached, mutable JSON representation.
  Map<String, dynamic> toJson() => _copyMap(json);

  @override
  bool operator ==(Object other) =>
      other is RawUserRelationFollowing &&
      other._fingerprint == _fingerprint &&
      const DeepCollectionEquality().equals(other.json, json);

  @override
  int get hashCode => _fingerprint;
}

Map<String, dynamic> _freezeMap(Map<String, dynamic> json) => Map.unmodifiable(
  json.map((key, value) => MapEntry(key, _freezeValue(value))),
);

Object? _freezeValue(Object? value) {
  if (value is Map<String, dynamic>) return _freezeMap(value);
  if (value is List<Object?>) {
    return List<Object?>.unmodifiable(value.map(_freezeValue));
  }
  return value;
}

Map<String, dynamic> _copyMap(Map<String, dynamic> json) =>
    json.map((key, value) => MapEntry(key, _copyValue(value)));

Object? _copyValue(Object? value) {
  if (value is Map<String, dynamic>) return _copyMap(value);
  if (value is List<Object?>) return value.map(_copyValue).toList();
  return value;
}
