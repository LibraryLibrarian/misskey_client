import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';

import '../../api/drive/drive_files_api.dart';
import '../../exception/misskey_client_exception.dart';
import '../../models/misskey_drive_file.dart';
import '../../streaming/internal/subscription_connection.dart';
import '../../streaming/misskey_streaming.dart';
import '../../streaming/streaming_subscription.dart';

/// Waits for a URL upload using an existing main-channel subscription.
@internal
Future<MisskeyDriveFile> uploadFromUrlAndWait({
  required DriveFilesApi files,
  required MisskeyStreaming Function()? streaming,
  required String url,
  String? folderId,
  bool? isSensitive,
  String? comment,
  bool? force,
  String? marker,
  MisskeyStreamingSubscription? mainSubscription,
  required Duration timeout,
}) async {
  final client = streaming?.call();
  const guidance =
      'subscribe to MisskeyStreamingChannel.main() and connect first';
  var subscription = mainSubscription;
  if (subscription != null) {
    if (subscription.channel != 'main') {
      throw ArgumentError.value(
        mainSubscription,
        'mainSubscription',
        'Must be a main-channel subscription',
      );
    }
    if (!subscription.isActive) {
      throw StateError('Main subscription is inactive; $guidance');
    }
  } else {
    for (final candidate
        in client?.subscriptions ?? const <MisskeyStreamingSubscription>[]) {
      if (candidate.channel == 'main') {
        subscription = candidate;
        break;
      }
    }
  }
  if (subscription == null || !isSubscriptionConnected(subscription)) {
    throw StateError('No connected main subscription; $guidance');
  }
  if (marker == '') {
    throw ArgumentError.value(marker, 'marker', 'Must not be empty');
  }
  final random = marker == null ? Random.secure() : null;
  final uploadMarker =
      marker ??
      List.generate(
        16,
        (_) => random!.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
  final result = Completer<MisskeyDriveFile>();
  // HTTP の応答前に届いたエラーも未処理にせず、応答後に再送出する。
  unawaited(
    result.future.then<void>((_) {}, onError: (Object _, StackTrace _) {}),
  );
  final listener = subscription.messages.listen(
    (message) {
      final body = message.body;
      if (result.isCompleted ||
          message.type != 'urlUploadFinished' ||
          body is! Map ||
          body['marker'] != uploadMarker) {
        return;
      }
      try {
        final file = Map<String, dynamic>.from(body['file'] as Map);
        result.complete(MisskeyDriveFile.fromJson(file));
      } catch (error, stackTrace) {
        result.completeError(
          MisskeyStreamingProtocolException(
            message: 'Could not decode URL upload result',
            operation: 'uploadFromUrlAndWait',
            context: {'marker': uploadMarker},
            cause: error,
            stackTrace: stackTrace,
          ),
          stackTrace,
        );
      }
    },
    onError: (Object error, StackTrace stackTrace) {
      if (!result.isCompleted) result.completeError(error, stackTrace);
    },
    onDone: () {
      if (!result.isCompleted) {
        result.completeError(
          MisskeyStreamingSubscriptionException(
            message: 'Main subscription closed while waiting for URL upload',
            operation: 'uploadFromUrlAndWait',
            context: {'marker': uploadMarker},
          ),
        );
      }
    },
  );
  try {
    await files.uploadFromUrl(
      url: url,
      folderId: folderId,
      isSensitive: isSensitive,
      comment: comment,
      marker: uploadMarker,
      force: force,
    );
    return await result.future.timeout(
      timeout,
      onTimeout: () {
        throw MisskeyStreamingTimeoutException(
          operation: 'uploadFromUrlAndWait',
          timeout: timeout,
          context: {'marker': uploadMarker},
        );
      },
    );
  } finally {
    await listener.cancel();
  }
}
