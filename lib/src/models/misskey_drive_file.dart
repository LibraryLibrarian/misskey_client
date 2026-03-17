import 'package:json_annotation/json_annotation.dart';

import 'misskey_drive_folder.dart';
import 'misskey_user.dart';

part 'misskey_drive_file.g.dart';

/// Misskey のドライブファイル
@JsonSerializable(createToJson: false)
class MisskeyDriveFile {
  const MisskeyDriveFile({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.type,
    required this.size,
    required this.md5,
    required this.url,
    this.thumbnailUrl,
    this.comment,
    this.folderId,
    this.folder,
    this.userId,
    this.user,
    this.isSensitive,
    this.blurhash,
    this.properties,
  });

  factory MisskeyDriveFile.fromJson(Map<String, dynamic> json) =>
      _$MisskeyDriveFileFromJson(json);

  final String id;
  final DateTime createdAt;
  final String name;

  /// MIMEタイプ
  final String type;

  /// ファイルサイズ（バイト）
  final int size;

  final String md5;
  final String url;
  final String? thumbnailUrl;
  final String? comment;
  final String? folderId;
  final MisskeyDriveFolder? folder;
  final String? userId;
  final MisskeyUser? user;

  @JsonKey(defaultValue: false)
  final bool? isSensitive;

  final String? blurhash;

  /// 画像のプロパティ（width, height等）
  final MisskeyDriveFileProperties? properties;
}

/// ドライブファイルのプロパティ（画像サイズ等）
@JsonSerializable(createToJson: false)
class MisskeyDriveFileProperties {
  const MisskeyDriveFileProperties({
    this.width,
    this.height,
    this.orientation,
    this.avgColor,
  });

  factory MisskeyDriveFileProperties.fromJson(Map<String, dynamic> json) =>
      _$MisskeyDriveFilePropertiesFromJson(json);

  final int? width;
  final int? height;
  final int? orientation;
  final String? avgColor;
}
