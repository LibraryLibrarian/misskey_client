import 'package:json_annotation/json_annotation.dart';

part 'misskey_drive_folder.g.dart';

/// A Misskey drive folder.
@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$MisskeyDriveFolderToJson(this);

  /// The folder ID.
  final String id;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The folder name.
  final String name;

  /// The parent folder ID.
  final String? parentId;

  /// The parent folder.
  final MisskeyDriveFolder? parent;

  /// The number of child folders.
  @JsonKey(defaultValue: 0)
  final int? foldersCount;

  /// The number of files in this folder.
  @JsonKey(defaultValue: 0)
  final int? filesCount;
}
