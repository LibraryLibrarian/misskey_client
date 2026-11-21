import 'misskey_note.dart';
import 'misskey_user.dart';

/// Result of `ap/show`, which returns either a [MisskeyUser] or a
/// [MisskeyNote].
sealed class ApShowResult {
  const ApShowResult();

  /// Creates the appropriate subtype from a JSON response.
  ///
  /// Returns [ApShowUser] when the `type` field is `"User"`, [ApShowNote]
  /// when it is `"Note"`, and [ApShowUnknown] for any other type.
  factory ApShowResult.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final object = json['object'] as Map<String, dynamic>;
    return switch (type) {
      'User' => ApShowUser(object: MisskeyUser.fromJson(object)),
      'Note' => ApShowNote(object: MisskeyNote.fromJson(object)),
      _ => ApShowUnknown(type: type, object: object),
    };
  }
}

/// An `ap/show` result containing a user.
class ApShowUser extends ApShowResult {
  const ApShowUser({required this.object});

  /// The resolved user.
  final MisskeyUser object;
}

/// An `ap/show` result containing a note.
class ApShowNote extends ApShowResult {
  const ApShowNote({required this.object});

  /// The resolved note.
  final MisskeyNote object;
}

/// An `ap/show` result of a type this client does not model.
///
/// Misskey currently returns only users and notes; this keeps a future or
/// fork-specific type from failing the whole call.
class ApShowUnknown extends ApShowResult {
  const ApShowUnknown({required this.type, required this.object});

  /// The `type` value of the response.
  final String type;

  /// The resolved object as raw JSON.
  final Map<String, dynamic> object;
}
