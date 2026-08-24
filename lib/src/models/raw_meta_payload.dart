import 'package:collection/collection.dart';

/// An immutable snapshot of a raw metadata API response.
///
/// Equality uses a fingerprint calculated once when the payload is created,
/// avoiding repeated deep traversal of potentially large metadata responses.
final class RawMetaPayload {
  /// Creates an immutable snapshot of [json] and calculates its fingerprint.
  factory RawMetaPayload(Map<String, dynamic> json) {
    if (json.isEmpty) return const RawMetaPayload.empty();
    final snapshot = _freezeMap(json);
    return RawMetaPayload._(
      snapshot,
      const DeepCollectionEquality().hash(snapshot),
    );
  }

  /// Creates an empty payload.
  const RawMetaPayload.empty()
    : json = const <String, dynamic>{},
      _fingerprint = 0;

  const RawMetaPayload._(this.json, this._fingerprint);

  /// The immutable raw JSON snapshot.
  final Map<String, dynamic> json;

  final int _fingerprint;

  dynamic operator [](Object? key) => json[key];

  /// The number of entries in the raw payload.
  int get length => json.length;

  /// Whether the raw payload contains no entries.
  bool get isEmpty => json.isEmpty;

  /// Whether the raw payload contains at least one entry.
  bool get isNotEmpty => json.isNotEmpty;

  /// The keys in the raw payload.
  Iterable<String> get keys => json.keys;

  @override
  bool operator ==(Object other) =>
      other is RawMetaPayload && other._fingerprint == _fingerprint;

  @override
  int get hashCode => _fingerprint;
}

Map<String, dynamic> _freezeMap(Map<String, dynamic> json) => Map.unmodifiable(
  json.map((key, value) => MapEntry(key, _freezeValue(value))),
);

Object? _freezeValue(Object? value) {
  if (value is Map<String, dynamic>) return _freezeMap(value);
  if (value is List<Object?>) {
    return List<Object?>.unmodifiable(value.map(_freezeValue));
  }
  return value;
}
