import 'dart:async';

/// Requests cooperative cancellation of a batch operation.
///
/// Cancellation prevents new work from starting. In-flight requests are not
/// aborted and are awaited to completion; no Dio `CancelToken` is used.
final class MisskeyCancellationToken {
  final Completer<void> _cancelled = Completer<void>();

  /// Whether cancellation has been requested.
  bool get isCancelled => _cancelled.isCompleted;

  /// Completes when cancellation is requested.
  Future<void> get whenCancelled => _cancelled.future;

  /// Requests cancellation. Repeated calls have no effect.
  void cancel() {
    if (!isCancelled) _cancelled.complete();
  }
}
