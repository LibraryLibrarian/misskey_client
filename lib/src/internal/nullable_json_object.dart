/// Returns a nullable JSON object, treating an empty HTTP body as `null`.
///
/// Misskey answers HTTP 204 with no body when an endpoint returns nothing,
/// for example when the requested target does not exist or a note has no text
/// to translate. [endpoint] is only used in the error message.
///
/// Throws [FormatException] for any other response shape.
Map<String, dynamic>? nullableJsonObject(Object? response, String endpoint) {
  if (response == null || response == '') return null;
  if (response is Map<String, dynamic>) return response;
  throw FormatException(
    'Unexpected response from $endpoint: '
    'expected a JSON object or an empty body.',
  );
}
