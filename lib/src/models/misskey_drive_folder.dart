import 'package:freezed_annotation/freezed_annotation.dart';

part 'misskey_drive_folder.freezed.dart';
part 'misskey_drive_folder.g.dart';

/// A Misskey drive folder.
@freezed
@JsonSerializable()
class MisskeyDriveFolder with _$MisskeyDriveFolder {
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
  @override
  final String id;

  /// The creation timestamp.
  @override
  final DateTime createdAt;

  /// The folder name.
  @override
  final String name;

  /// The parent folder ID.
  @override
  final String? parentId;

  /// The parent folder.
  @override
  final MisskeyDriveFolder? parent;

  /// The number of child folders.
  @JsonKey(defaultValue: 0)
  @override
  final int? foldersCount;

  /// The number of files in this folder.
  @JsonKey(defaultValue: 0)
  @override
  final int? filesCount;
}
