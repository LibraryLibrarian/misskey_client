/// ユーザーのドライブ容量情報。
///
/// ユーザーのドライブの最大容量と現在の使用量を保持
class DriveCapacityInfo {
  /// コンストラクタ
  const DriveCapacityInfo({
    required this.capacity,
    required this.usage,
  });

  /// JSONから[DriveCapacityInfo]を生成
  factory DriveCapacityInfo.fromJson(Map<String, dynamic> json) {
    return DriveCapacityInfo(
      capacity: json['capacity'] as int,
      usage: json['usage'] as int,
    );
  }

  /// ユーザーに割り当てられた最大ストレージ容量（バイト）
  final int capacity;

  /// 現在のドライブ使用量（バイト）
  final int usage;

  /// [DriveCapacityInfo]をJSONに変換
  Map<String, dynamic> toJson() => {
        'capacity': capacity,
        'usage': usage,
      };

  /// 利用可能な容量（バイト）
  int get availableCapacity => capacity - usage;

  /// 使用率（0.0〜1.0）
  double get usageRatio => capacity > 0 ? usage / capacity : 0.0;

  /// 使用率（パーセンテージ、0〜100）
  double get usagePercentage => usageRatio * 100;

  /// バイト数を可読形式にフォーマット
  ///
  /// 例: 1024 → "1.00 KB"、1048576 → "1.00 MB"
  static String _formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toDouble();
    var suffixIndex = 0;

    while (size > 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }

    return '${size.toStringAsFixed(2)} ${suffixes[suffixIndex]}';
  }

  /// 容量情報の整形済み文字列表現
  ///
  /// 例: "Usage: 2.87 GB / 18.00 GB (15.9%)"
  String get formatted =>
      'Usage: ${_formatBytes(usage)} / ${_formatBytes(capacity)} '
      '(${usagePercentage.toStringAsFixed(1)}%)';

  @override
  String toString() => 'DriveCapacityInfo($formatted)';
}
