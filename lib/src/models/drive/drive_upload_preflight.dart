import 'dart:collection';

import 'package:meta/meta.dart';

import '../misskey_role_policies.dart';
import 'drive_capacity_info.dart';

/// The severity assigned to an upload preflight issue.
enum DriveUploadIssueSeverity {
  /// Prevents the upload.
  blocking,

  /// Provides information without preventing the upload.
  advisory,
}

/// An issue found during an upload preflight check.
@immutable
sealed class DriveUploadIssue {
  /// Creates an upload issue.
  const DriveUploadIssue();

  /// The severity of this issue; [DriveUploadIssueSeverity.blocking] prevents
  /// the upload.
  DriveUploadIssueSeverity get severity;
}

/// Reports that an upload exceeds a file-size limit.
@immutable
final class DriveUploadFileTooLarge extends DriveUploadIssue {
  /// Creates a file-size issue.
  const DriveUploadFileTooLarge({
    required this.size,
    required this.maxSize,
    required this.instanceLimit,
  });

  /// The candidate file size in bytes.
  final int size;

  /// The maximum permitted size in bytes.
  final int maxSize;

  /// Whether [maxSize] is the instance multipart limit rather than a policy
  /// limit.
  final bool instanceLimit;

  @override
  DriveUploadIssueSeverity get severity => DriveUploadIssueSeverity.blocking;

  @override
  String toString() =>
      'DriveUploadFileTooLarge(size: $size, maxSize: $maxSize, '
      'instanceLimit: $instanceLimit)';
}

/// Reports that an upload would exceed available Drive capacity.
@immutable
final class DriveUploadInsufficientCapacity extends DriveUploadIssue {
  /// Creates a capacity issue.
  const DriveUploadInsufficientCapacity({
    required this.size,
    required this.availableBytes,
  });

  /// The candidate file size in bytes.
  final int size;

  /// The Drive capacity available before this upload, in bytes.
  final int availableBytes;

  @override
  DriveUploadIssueSeverity get severity => DriveUploadIssueSeverity.blocking;

  @override
  String toString() =>
      'DriveUploadInsufficientCapacity(size: $size, '
      'availableBytes: $availableBytes)';
}

/// Reports that a MIME type is not allowed by the effective policies.
///
/// This is advisory because the server determines the actual MIME type by
/// inspecting the uploaded file.
@immutable
final class DriveUploadTypeNotAllowed extends DriveUploadIssue {
  /// Creates a MIME type issue.
  DriveUploadTypeNotAllowed({
    required this.mimeType,
    required Iterable<String> allowedTypes,
  }) : allowedTypes = UnmodifiableListView(List.of(allowedTypes));

  /// The locally supplied MIME type.
  final String mimeType;

  /// The MIME type patterns allowed by the effective policies.
  final List<String> allowedTypes;

  @override
  DriveUploadIssueSeverity get severity => DriveUploadIssueSeverity.advisory;

  @override
  String toString() =>
      'DriveUploadTypeNotAllowed(mimeType: $mimeType, '
      'allowedTypes: $allowedTypes)';
}

/// Reports policy values that were unavailable for a preflight check.
@immutable
final class DriveUploadPoliciesUnavailable extends DriveUploadIssue {
  /// Creates a policy availability issue.
  DriveUploadPoliciesUnavailable({required Iterable<String> missing})
    : missing = UnmodifiableListView(List.of(missing));

  /// The names of unavailable policy values.
  final List<String> missing;

  @override
  DriveUploadIssueSeverity get severity => DriveUploadIssueSeverity.advisory;

  @override
  String toString() => 'DriveUploadPoliciesUnavailable(missing: $missing)';
}

/// The result of checking a candidate Drive upload.
@immutable
final class DriveUploadCheck {
  /// Creates an upload check result.
  DriveUploadCheck({required Iterable<DriveUploadIssue> issues})
    : issues = UnmodifiableListView(List.of(issues));

  /// All blocking and advisory issues found by the check.
  final List<DriveUploadIssue> issues;

  /// Whether no blocking issue was found.
  bool get canUpload => !issues.any(
    (issue) => issue.severity == DriveUploadIssueSeverity.blocking,
  );

  @override
  String toString() => 'DriveUploadCheck(issues: $issues)';
}

/// A snapshot of the limits relevant to a Drive upload.
///
/// Results are advisory because limits and usage can change after this
/// snapshot. The server can return an existing same-hash file before it
/// evaluates role-policy checks, so reported policy file-size, capacity, or
/// MIME type issues can be false positives for duplicate content.
@immutable
final class DriveUploadPreflight {
  /// Creates an upload preflight snapshot.
  ///
  /// This constructor is public so applications can create snapshots for local
  /// tests without making API requests.
  const DriveUploadPreflight({
    this.policies,
    required this.capacity,
    this.bypassesPolicyLimits = false,
    this.instanceMaxFileSize,
  });

  /// The effective role policies, if they were available.
  final MisskeyRolePolicies? policies;

  /// The Drive capacity snapshot.
  final DriveCapacityInfo capacity;

  /// Whether the current user bypasses role policy limits.
  final bool bypassesPolicyLimits;

  /// The instance multipart file-size limit in bytes, if supplied.
  final int? instanceMaxFileSize;

  /// Checks one candidate upload against this snapshot.
  ///
  /// A missing [mimeType] skips the advisory MIME type check. A negative
  /// [size] is invalid and throws [ArgumentError].
  DriveUploadCheck check({required int size, String? mimeType}) {
    if (size < 0) {
      throw ArgumentError.value(size, 'size', 'must not be negative');
    }

    final issues = <DriveUploadIssue>[];
    final instanceMaxFileSize = this.instanceMaxFileSize;
    if (instanceMaxFileSize != null && instanceMaxFileSize < size) {
      issues.add(
        DriveUploadFileTooLarge(
          size: size,
          maxSize: instanceMaxFileSize,
          instanceLimit: true,
        ),
      );
    }

    if (!bypassesPolicyLimits) {
      final policies = this.policies;
      if (policies == null) {
        issues.add(DriveUploadPoliciesUnavailable(missing: ['policies']));
      } else {
        final missing = <String>[];
        if (policies.maxFileSizeMb == null) missing.add('maxFileSizeMb');
        if (policies.driveCapacityMb == null) missing.add('driveCapacityMb');
        if (policies.uploadableFileTypes == null) {
          missing.add('uploadableFileTypes');
        }
        if (missing.isNotEmpty) {
          issues.add(DriveUploadPoliciesUnavailable(missing: missing));
        }

        final maxFileSizeMb = policies.maxFileSizeMb;
        if (maxFileSizeMb != null) {
          final maxSize = maxFileSizeMb * 1024 * 1024;
          if (maxSize < size) {
            issues.add(
              DriveUploadFileTooLarge(
                size: size,
                maxSize: maxSize,
                instanceLimit: false,
              ),
            );
          }
        }

        final allowedTypes = policies.uploadableFileTypes;
        if (mimeType != null &&
            allowedTypes != null &&
            !_isAllowedMimeType(mimeType, allowedTypes)) {
          issues.add(
            DriveUploadTypeNotAllowed(
              mimeType: mimeType,
              allowedTypes: allowedTypes,
            ),
          );
        }
      }
      if (capacity.capacity < capacity.usage + size) {
        issues.add(
          DriveUploadInsufficientCapacity(
            size: size,
            availableBytes: capacity.availableCapacity,
          ),
        );
      }
    }

    return DriveUploadCheck(issues: issues);
  }

  /// Checks candidates in order, accounting for their cumulative size.
  ///
  /// Records require an explicit `mimeType: null` when no MIME type is known;
  /// for example, `checkAll([(size: 10, mimeType: null)])`. Every candidate
  /// contributes to the projected usage for following candidates, including
  /// candidates that have other blocking issues.
  List<DriveUploadCheck> checkAll(
    Iterable<({int size, String? mimeType})> candidates,
  ) {
    var projected = this;
    final checks = <DriveUploadCheck>[];
    for (final candidate in candidates) {
      checks.add(
        projected.check(size: candidate.size, mimeType: candidate.mimeType),
      );
      projected = projected.afterUpload(candidate.size);
    }
    return UnmodifiableListView(checks);
  }

  /// Returns a snapshot with [bytes] added to the Drive usage.
  ///
  /// A negative [bytes] value is invalid and throws [ArgumentError].
  DriveUploadPreflight afterUpload(int bytes) {
    if (bytes < 0) {
      throw ArgumentError.value(bytes, 'bytes', 'must not be negative');
    }
    return DriveUploadPreflight(
      policies: policies,
      capacity: DriveCapacityInfo(
        capacity: capacity.capacity,
        usage: capacity.usage + bytes,
      ),
      bypassesPolicyLimits: bypassesPolicyLimits,
      instanceMaxFileSize: instanceMaxFileSize,
    );
  }

  @override
  String toString() =>
      'DriveUploadPreflight(policies: $policies, capacity: $capacity, '
      'bypassesPolicyLimits: $bypassesPolicyLimits, '
      'instanceMaxFileSize: $instanceMaxFileSize)';
}

bool _isAllowedMimeType(String mimeType, List<String> allowedTypes) {
  for (final allowedType in allowedTypes) {
    if (allowedType == '*' || allowedType == '*/*') return true;
    if (allowedType.endsWith('/*')) {
      final prefix = allowedType.substring(0, allowedType.length - 1);
      if (mimeType.startsWith(prefix)) return true;
    } else if (mimeType == allowedType) {
      return true;
    }
  }
  return false;
}
