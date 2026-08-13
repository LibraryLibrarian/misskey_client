import 'package:dio/dio.dart';
import 'package:misskey_client/misskey_client.dart';
import 'package:misskey_client/src/internal/dio_error_handler.dart';
import 'package:test/test.dart';

/// [statusCode] と [data] を持つ [DioException] を組み立てる。
///
/// [headers] を渡すとレスポンスヘッダー(例: retry-after)を模擬できる。
DioException _errorWithStatus(
  int statusCode, {
  dynamic data,
  Map<String, List<String>>? headers,
}) {
  final options = RequestOptions(path: '/notes/create');
  return DioException(
    requestOptions: options,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
      headers: Headers.fromMap(headers ?? const {}),
    ),
    type: DioExceptionType.badResponse,
  );
}

DioException _networkError(DioExceptionType type, {String? message}) {
  return DioException(
    requestOptions: RequestOptions(path: '/notes/create'),
    type: type,
    message: message,
  );
}

void main() {
  group('convertDioException - status code mapping', () {
    test('401 maps to MisskeyUnauthorizedException', () {
      final result = convertDioException(_errorWithStatus(401));
      expect(result, isA<MisskeyUnauthorizedException>());
      expect((result as MisskeyApiException).statusCode, 401);
    });

    test('403 maps to MisskeyForbiddenException', () {
      final result = convertDioException(_errorWithStatus(403));
      expect(result, isA<MisskeyForbiddenException>());
    });

    test('404 maps to MisskeyNotFoundException', () {
      final result = convertDioException(_errorWithStatus(404));
      expect(result, isA<MisskeyNotFoundException>());
    });

    test('422 maps to MisskeyValidationException', () {
      final result = convertDioException(_errorWithStatus(422));
      expect(result, isA<MisskeyValidationException>());
    });

    test('429 maps to MisskeyRateLimitException', () {
      final result = convertDioException(_errorWithStatus(429));
      expect(result, isA<MisskeyRateLimitException>());
    });

    test('500 maps to MisskeyServerException with statusCode preserved', () {
      final result = convertDioException(_errorWithStatus(500));
      expect(result, isA<MisskeyServerException>());
      expect((result as MisskeyServerException).statusCode, 500);
    });

    test('503 (any 5xx) maps to MisskeyServerException', () {
      final result = convertDioException(_errorWithStatus(503));
      expect(result, isA<MisskeyServerException>());
      expect((result as MisskeyServerException).statusCode, 503);
    });

    test('unmapped status codes fall back to MisskeyApiException', () {
      final result = convertDioException(_errorWithStatus(418));
      expect(result, isA<MisskeyApiException>());
      expect(result, isNot(isA<MisskeyUnauthorizedException>()));
      expect((result as MisskeyApiException).statusCode, 418);
    });
  });

  group('convertDioException - error body parsing', () {
    test('extracts code/message/errorId from nested error object', () {
      final result = convertDioException(
        _errorWithStatus(
          400,
          data: {
            'error': {
              'code': 'INVALID_PARAM',
              'message': 'Invalid parameter.',
              'id': 'abc-123',
            },
          },
        ),
      );
      final api = result as MisskeyApiException;
      expect(api.code, 'INVALID_PARAM');
      expect(api.message, 'Invalid parameter.');
      expect(api.errorId, 'abc-123');
    });

    test('extracts code/message from flat (non-nested) error object', () {
      final result = convertDioException(
        _errorWithStatus(
          400,
          data: {'code': 'FLAT_ERROR', 'message': 'Flat error message.'},
        ),
      );
      final api = result as MisskeyApiException;
      expect(api.code, 'FLAT_ERROR');
      expect(api.message, 'Flat error message.');
    });

    test('leaves code/errorId null when error object omits them', () {
      final result = convertDioException(
        _errorWithStatus(400, data: {'error': <String, dynamic>{}}),
      );
      final api = result as MisskeyApiException;
      expect(api.code, isNull);
      expect(api.errorId, isNull);
    });

    test('falls back to DioException message when data is not a Map', () {
      final options = RequestOptions(path: '/notes/create');
      final exception = DioException(
        requestOptions: options,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 500,
          data: '<html>Internal Server Error</html>',
        ),
        type: DioExceptionType.badResponse,
        message: 'Http status error [500]',
      );
      final result = convertDioException(exception);
      final api = result as MisskeyApiException;
      expect(api.code, isNull);
      expect(api.message, 'Http status error [500]');
    });

    test('falls back to DioException message when data is null', () {
      final result = convertDioException(_errorWithStatus(500));
      final api = result as MisskeyApiException;
      expect(api.message, isNotEmpty);
    });
  });

  group('convertDioException - retry-after header (429)', () {
    test('parses a numeric retry-after header into a Duration', () {
      final result = convertDioException(
        _errorWithStatus(
          429,
          headers: {
            'retry-after': ['30'],
          },
        ),
      );
      final rateLimit = result as MisskeyRateLimitException;
      expect(rateLimit.retryAfter, const Duration(seconds: 30));
    });

    test('retryAfter is null when the header is absent', () {
      final result = convertDioException(_errorWithStatus(429));
      expect((result as MisskeyRateLimitException).retryAfter, isNull);
    });

    test('retryAfter is null when the header is not a valid integer', () {
      final result = convertDioException(
        _errorWithStatus(
          429,
          headers: {
            'retry-after': ['Wed, 21 Oct 2026 07:28:00 GMT'],
          },
        ),
      );
      expect((result as MisskeyRateLimitException).retryAfter, isNull);
    });
  });

  group('convertDioException - network errors (no response)', () {
    test('connectionError maps to MisskeyNetworkException', () {
      final result = convertDioException(
        _networkError(DioExceptionType.connectionError),
      );
      expect(result, isA<MisskeyNetworkException>());
    });

    test('connectionTimeout maps to MisskeyNetworkException', () {
      final result = convertDioException(
        _networkError(DioExceptionType.connectionTimeout),
      );
      expect(result, isA<MisskeyNetworkException>());
    });

    test('receiveTimeout maps to MisskeyNetworkException', () {
      final result = convertDioException(
        _networkError(DioExceptionType.receiveTimeout),
      );
      expect(result, isA<MisskeyNetworkException>());
    });

    test('cancel maps to MisskeyNetworkException', () {
      final result = convertDioException(
        _networkError(DioExceptionType.cancel),
      );
      expect(result, isA<MisskeyNetworkException>());
    });

    test('preserves the original DioException as cause', () {
      final original = _networkError(
        DioExceptionType.connectionError,
        message: 'Failed host lookup',
      );
      final result = convertDioException(original) as MisskeyNetworkException;
      expect(result.cause, same(original));
      expect(result.message, 'Failed host lookup');
    });

    test('endpoint is carried through to the resulting exception', () {
      final result = convertDioException(
        _networkError(DioExceptionType.connectionError),
        '/notes/timeline',
      );
      expect((result as MisskeyNetworkException).endpoint, '/notes/timeline');
    });
  });
}
