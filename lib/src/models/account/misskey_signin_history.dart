import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'misskey_signin_history.g.dart';

/// A sign-in history entry.
@JsonSerializable()
class MisskeySigninHistory {
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
  final String id;

  /// The date and time when the sign-in occurred.
  @SafeDateTimeConverter()
  final DateTime createdAt;

  /// The source IP address.
  final String? ip;

  /// The request headers.
  final Map<String, dynamic>? headers;

  /// Whether the sign-in was successful.
  final bool? success;
}
