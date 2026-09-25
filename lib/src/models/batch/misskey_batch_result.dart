import 'package:meta/meta.dart';

/// The reason an input was not started.
enum MisskeyBatchSkipReason {
  /// Cancellation was requested.
  cancelled,

  /// The server rate-limited a request.
  rateLimited,

  /// An earlier error stopped the batch.
  stoppedAfterError,

  /// A prerequisite operation did not succeed.
  dependencyFailed,
}

/// The outcome of one batch input. Use `T = Null` for no-value operations.
@immutable
sealed class MisskeyBatchItemResult<I, T> {
  /// Creates an outcome for [input] at its original [index].
  const MisskeyBatchItemResult({required this.input, required this.index});

  /// The original input.
  final I input;

  /// The zero-based position in the input list.
  final int index;

  /// Whether this input completed successfully.
  bool get isSuccess => this is MisskeyBatchSuccess<I, T>;
}

/// An input that completed successfully.
@immutable
final class MisskeyBatchSuccess<I, T> extends MisskeyBatchItemResult<I, T> {
  /// Creates a successful outcome.
  const MisskeyBatchSuccess({
    required super.input,
    required super.index,
    required this.value,
  });

  /// The operation's return value.
  final T value;
}

/// An input whose operation threw an error.
@immutable
final class MisskeyBatchFailure<I, T> extends MisskeyBatchItemResult<I, T> {
  /// Creates a failed outcome preserving the original error and stack trace.
  const MisskeyBatchFailure({
    required super.input,
    required super.index,
    required this.error,
    required this.stackTrace,
  });

  /// The original error.
  final Object error;

  /// The original stack trace.
  final StackTrace stackTrace;
}

/// An input whose operation was not started.
@immutable
final class MisskeyBatchSkipped<I, T> extends MisskeyBatchItemResult<I, T> {
  /// Creates a skipped outcome with an optional originating error.
  const MisskeyBatchSkipped({
    required super.input,
    required super.index,
    required this.reason,
    this.cause,
  });

  /// Why the operation was not started.
  final MisskeyBatchSkipReason reason;

  /// The error that caused the stop, if any.
  final Object? cause;
}

/// Immutable batch outcomes in input order.
@immutable
final class MisskeyBatchResult<I, T> {
  /// Copies [items] into an unmodifiable list.
  MisskeyBatchResult({required List<MisskeyBatchItemResult<I, T>> items})
    : items = List.unmodifiable(items);

  /// Creates an empty, complete batch result.
  const MisskeyBatchResult.empty() : items = const [];

  /// All outcomes in input order.
  final List<MisskeyBatchItemResult<I, T>> items;

  /// Successful outcomes in input order.
  Iterable<MisskeyBatchSuccess<I, T>> get successes =>
      items.whereType<MisskeyBatchSuccess<I, T>>();

  /// Failed outcomes in input order.
  Iterable<MisskeyBatchFailure<I, T>> get failures =>
      items.whereType<MisskeyBatchFailure<I, T>>();

  /// Skipped outcomes in input order.
  Iterable<MisskeyBatchSkipped<I, T>> get skipped =>
      items.whereType<MisskeyBatchSkipped<I, T>>();

  /// Whether every input succeeded; also true for an empty batch.
  bool get isComplete => items.every((item) => item.isSuccess);
}
