/// A word-mute condition accepted by Misskey.
///
/// Use [MutedWordKeywords] for an AND-condition keyword group or
/// [MutedWordRegex] for a regular expression. [MutedWordUnknown] preserves an
/// unrecognized JSON shape returned by a fork or a newer server.
sealed class MutedWord {
  const MutedWord();
}

/// A word-mute condition that matches all of the specified [keywords].
final class MutedWordKeywords extends MutedWord {
  const MutedWordKeywords({required this.keywords});

  /// The keywords combined as an AND condition.
  final List<String> keywords;
}

/// A word-mute condition represented by a regular expression.
final class MutedWordRegex extends MutedWord {
  const MutedWordRegex({required this.pattern});

  /// The regular expression in the raw Misskey API format.
  final String pattern;
}

/// An unrecognized word-mute condition returned by the server.
///
/// This fallback keeps authenticated-user responses usable when a fork or a
/// newer Misskey version adds another condition shape. The raw value is
/// preserved when the model is converted back to JSON.
final class MutedWordUnknown extends MutedWord {
  const MutedWordUnknown({required this.rawValue});

  /// The unrecognized JSON value as returned by the server.
  final Object? rawValue;
}
