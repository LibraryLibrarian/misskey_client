import 'misskey_note.dart';
import 'misskey_user.dart';

/// `ap/show` のレスポンス（`User` または `Note` を返す）
sealed class ApShowResult {
  const ApShowResult();

  /// JSONレスポンスから適切なサブタイプを生成する
  ///
  /// `type` フィールドが `"User"` なら [ApShowUser]、
  /// `"Note"` なら [ApShowNote] を返す。
  factory ApShowResult.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final object = json['object'] as Map<String, dynamic>;
    return switch (type) {
      'User' => ApShowUser(object: MisskeyUser.fromJson(object)),
      'Note' => ApShowNote(object: MisskeyNote.fromJson(object)),
      _ => throw FormatException('ap/show: 不明なtype "$type"'),
    };
  }
}

/// `ap/show` がユーザーを返した場合
class ApShowUser extends ApShowResult {
  const ApShowUser({required this.object});

  final MisskeyUser object;
}

/// `ap/show` がノートを返した場合
class ApShowNote extends ApShowResult {
  const ApShowNote({required this.object});

  final MisskeyNote object;
}
