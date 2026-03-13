import 'package:json_annotation/json_annotation.dart';

part 'misskey_drive_folder.g.dart';

/// Misskey のドライブフォルダ
@JsonSerializable(createToJson: false)
class MisskeyDriveFolder {
  const MisskeyDriveFolder({
    required this.id,
    required this.createdAt,
    required this.name,
    this.parentId,
    this.parent,
    this.foldersCount,
    this.filesCount,
  });

  factory MisskeyDriveFolder.fromJson(Map<String, dynamic> json) =>
      _$MisskeyDriveFolderFromJson(json);

  final String id;
  final DateTime createdAt;
  final String name;
  final String? parentId;
  final MisskeyDriveFolder? parent;

  @JsonKey(defaultValue: 0)
  final int? foldersCount;

  @JsonKey(defaultValue: 0)
  final int? filesCount;
}
