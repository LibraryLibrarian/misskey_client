/// A wrapper type that distinguishes between "not specified" and "explicitly
/// send null" for API parameters.
///
/// Dart's optional parameters treat `null` as "not specified", making it
/// impossible to express "send null to clear the value". This type represents
/// three states:
///
/// When the parameter is omitted (default `null`), it is not included in the
/// request body and the field remains unchanged. Passing `Optional(value)`
/// sets the field to the given value. Passing `Optional.null_()` sends
/// `null` explicitly to clear the field.
///
/// ```dart
/// // Update the name and clear the description.
/// client.account.update(
///   name: Optional('new name'),
///   description: Optional.null_(),
/// );
/// ```
sealed class Optional<T> {
  /// Sets a value (use [Optional.null_] to explicitly send `null`).
  const factory Optional(T value) = Some<T>;

  const Optional._();

  /// Explicitly sends `null` to clear the value.
  const factory Optional.null_() = Some<T>.null_;
}

/// Represents a specified value (a `null` value means "send null").
final class Some<T> extends Optional<T> {
  /// Creates an instance with the given [value].
  const Some(this.value) : super._();

  /// Creates an instance that explicitly sends `null`.
  const Some.null_()
      : value = null,
        super._();

  /// The specified value, or `null` if the intent is to clear it.
  final T? value;
}
