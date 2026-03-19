import 'package:json_annotation/json_annotation.dart';

part 'drive_capacity_info.g.dart';

/// Drive storage capacity information for a user.
@JsonSerializable()
class DriveCapacityInfo {
  const DriveCapacityInfo({
    required this.capacity,
    required this.usage,
  });

  factory DriveCapacityInfo.fromJson(Map<String, dynamic> json) =>
      _$DriveCapacityInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DriveCapacityInfoToJson(this);

  /// The maximum storage capacity allocated to the user, in bytes.
  final int capacity;

  /// The current drive usage, in bytes.
  final int usage;

  /// The available capacity, in bytes.
  int get availableCapacity => capacity - usage;

  /// The usage ratio (0.0 to 1.0).
  double get usageRatio => capacity > 0 ? usage / capacity : 0.0;

  /// The usage as a percentage (0 to 100).
  double get usagePercentage => usageRatio * 100;

  /// バイト数を可読形式にフォーマット
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

  /// A formatted string representation of the capacity information.
  String get formatted =>
      'Usage: ${_formatBytes(usage)} / ${_formatBytes(capacity)} '
      '(${usagePercentage.toStringAsFixed(1)}%)';

  @override
  String toString() => 'DriveCapacityInfo($formatted)';
}
