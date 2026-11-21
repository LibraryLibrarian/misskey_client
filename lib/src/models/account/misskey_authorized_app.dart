import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_authorized_app.freezed.dart';
part 'misskey_authorized_app.g.dart';

/// An application from the `/api/i/authorized-apps` response.
@freezed
@JsonSerializable()
class MisskeyAuthorizedApp with _$MisskeyAuthorizedApp {
  const MisskeyAuthorizedApp({
    required this.id,
    required this.name,
    required this.permission,
    this.callbackUrl,
    this.isAuthorized,
  });

  factory MisskeyAuthorizedApp.fromJson(Map<String, dynamic> json) =>
      _$MisskeyAuthorizedAppFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyAuthorizedAppToJson(this);

  /// The application ID.
  @override
  final String id;

  /// The application name.
  @override
  final String name;

  /// The application's requested permissions.
  @override
  final List<String> permission;

  /// The callback URL, or null if the application has none.
  @override
  final String? callbackUrl;

  /// Whether the current user has authorized the application, when supplied.
  @override
  final bool? isAuthorized;
}
