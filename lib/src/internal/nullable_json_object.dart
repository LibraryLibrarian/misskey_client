/// Returns a nullable JSON object, treating an empty HTTP body as `null`.
///
/// Throws [FormatException] for any other response shape.
Map<String, dynamic>? nullableJsonObject(Object? response) {
  if (response == null || response == '') return null;
  if (response is Map<String, dynamic>) return response;
  throw const FormatException(
    'Expected a JSON object or an empty response body.',
  );
}
