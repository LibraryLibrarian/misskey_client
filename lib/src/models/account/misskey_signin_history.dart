import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters.dart';

part 'misskey_signin_history.freezed.dart';
part 'misskey_signin_history.g.dart';

/// A sign-in history entry.
@freezed
@JsonSerializable()
class MisskeySigninHistory with _$MisskeySigninHistory {
  const MisskeySigninHistory({
    required this.id,
    required this.createdAt,
    this.ip,
    this.headers,
    this.success,
  });

  factory MisskeySigninHistory.fromJson(Map<String, dynamic> json) =>
      _$MisskeySigninHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeySigninHistoryToJson(this);

  /// The unique identifier of this sign-in record.
  @override
  final String id;

  /// The date and time when the sign-in occurred.
  @SafeDateTimeConverter()
  @override
  final DateTime createdAt;

  /// The source IP address.
  @override
  final String? ip;

  /// The request headers.
  @override
  final Map<String, dynamic>? headers;

  /// Whether the sign-in was successful.
  @override
  final bool? success;
}
