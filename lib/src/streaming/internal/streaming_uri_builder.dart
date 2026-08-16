import '../../exception/misskey_client_exception.dart';

/// Builds the WebSocket endpoint used by the Misskey Streaming API.
Uri buildStreamingUri(Uri baseUrl, {String? token}) {
  final scheme = switch (baseUrl.scheme.toLowerCase()) {
    'https' => 'wss',
    'http' => 'ws',
    final unsupported => throw MisskeyStreamingConnectionException(
      message: 'Unsupported base URL scheme: $unsupported',
      operation: 'buildStreamingUri',
      context: {'scheme': unsupported},
    ),
  };

  final segments = [...baseUrl.pathSegments];
  while (segments.isNotEmpty && segments.last.isEmpty) {
    segments.removeLast();
  }
  if (segments.isNotEmpty && segments.last == 'api') {
    segments.removeLast();
  }
  segments.add('streaming');

  final queryParameters = <String, String>{};
  if (token != null && token.isNotEmpty) {
    queryParameters['i'] = token;
  }

  return Uri(
    scheme: scheme,
    userInfo: baseUrl.userInfo,
    host: baseUrl.host,
    port: baseUrl.hasPort ? baseUrl.port : null,
    pathSegments: segments,
    queryParameters: queryParameters.isEmpty ? null : queryParameters,
  );
}
