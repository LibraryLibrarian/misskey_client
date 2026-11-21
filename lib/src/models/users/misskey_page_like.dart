import 'package:freezed_annotation/freezed_annotation.dart';

import 'misskey_page.dart';

part 'misskey_page_like.freezed.dart';
part 'misskey_page_like.g.dart';

/// A Page like entry from the `/api/i/page-likes` response.
@freezed
@JsonSerializable()
class MisskeyPageLike with _$MisskeyPageLike {
  const MisskeyPageLike({required this.id, required this.page});

  factory MisskeyPageLike.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPageLikeFromJson(json);

  Map<String, dynamic> toJson() => _$MisskeyPageLikeToJson(this);

  /// The like ID.
  @override
  final String id;

  /// The liked Page.
  @override
  final MisskeyPage page;
}
