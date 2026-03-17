/// APIパラメータの「未指定」と「明示的にnullを送信」を区別するためのラッパー型
///
/// Dartのoptionalパラメータでは`null`が「未指定」を意味するため、
/// サーバーに`null`を送信して値をクリアする操作を表現できない。
/// この型を使うことで3状態を表現する:
///
/// - パラメータ省略（デフォルト`null`）→ リクエストボディに含めない（変更なし）
/// - `Optional(value)` → 値をセットする
/// - `Optional.null_()` → `null`を送信してクリアする
///
/// ```dart
/// // 名前を変更し、説明をクリアする
/// client.account.update(
///   name: Optional('新しい名前'),
///   description: Optional.null_(),
/// );
/// ```
sealed class Optional<T> {
  /// 値をセットする（`null`を送信する場合は[Optional.null_]を使う）
  const factory Optional(T value) = Some<T>;

  const Optional._();

  /// 明示的に`null`を送信して値をクリアする
  const factory Optional.null_() = Some<T>.null_;
}

/// 値が指定されたことを表す（値が`null`の場合は「nullを送信する」を意味する）
final class Some<T> extends Optional<T> {
  /// 値を指定する
  const Some(this.value) : super._();

  /// 明示的に`null`を送信する
  const Some.null_()
      : value = null,
        super._();

  /// 指定された値（`null`の場合はクリアを意味する）
  final T? value;
}
