import 'package:meta/meta.dart';

import '../streaming_subscription.dart';

final _connections = Expando<bool Function()>();

/// Associates a managed subscription with its owner's connection state.
@internal
void registerSubscriptionConnection(
  MisskeyStreamingSubscription subscription,
  bool Function() isConnected,
) {
  _connections[subscription] = isConnected;
}

/// Returns false for subscriptions not registered by a streaming client.
@internal
bool isSubscriptionConnected(MisskeyStreamingSubscription subscription) =>
    _connections[subscription]?.call() ?? false;
