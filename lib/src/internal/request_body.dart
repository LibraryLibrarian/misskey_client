import 'optional.dart';

/// Writes an [Optional] parameter into a request [body].
///
/// When [opt] is `null` (unspecified) the function does nothing, leaving the
/// key out of the body so the server keeps the current value. When [opt] is a
/// [Some] instance, `body[key]` is set to the wrapped value, which is `null`
/// for `Optional.null_()` and therefore clears the field.
void putOptional<T>(Map<String, dynamic> body, String key, Optional<T>? opt) {
  if (opt case Some<T>(:final value)) {
    body[key] = value;
  }
}
