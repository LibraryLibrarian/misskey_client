import 'package:meta/meta.dart';

import '../../client/misskey_http.dart';
import '../../client/request_options.dart';
import '../../models/admin/misskey_captcha_settings.dart';

/// Provides CAPTCHA configuration admin APIs (`/api/admin/captcha/*`).
///
/// All endpoints require administrator privileges.
class AdminCaptchaApi {
  const AdminCaptchaApi({required this.http});

  @internal
  final MisskeyHttp http;

  /// Fetches the current CAPTCHA settings (`/api/admin/captcha/current`).
  Future<MisskeyCaptchaSettings> current() async {
    final res = await http.send<Map<String, dynamic>>(
      '/admin/captcha/current',
      body: const <String, dynamic>{},
      options: const RequestOptions(idempotent: true),
    );
    return MisskeyCaptchaSettings.fromJson(res);
  }

  /// Saves the CAPTCHA settings (`/api/admin/captcha/save`).
  ///
  /// [provider] is `none`, `hcaptcha`, `mcaptcha`, `recaptcha`,
  /// `turnstile`, or `testcaptcha`. [sitekey] and [secret] are the
  /// provider keys, [instanceUrl] is required for mCaptcha, and
  /// [captchaResult] carries a solved challenge used by the server to
  /// verify the configuration before saving.
  Future<void> save({
    required String provider,
    String? captchaResult,
    String? sitekey,
    String? secret,
    String? instanceUrl,
  }) => http.send<Object?>(
    '/admin/captcha/save',
    body: <String, dynamic>{
      'provider': provider,
      'captchaResult': ?captchaResult,
      'sitekey': ?sitekey,
      'secret': ?secret,
      'instanceUrl': ?instanceUrl,
    },
  );
}
