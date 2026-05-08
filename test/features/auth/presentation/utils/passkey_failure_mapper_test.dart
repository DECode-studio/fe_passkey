import 'package:fe_passkey/features/auth/presentation/utils/passkey_failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps network blocked error before generic network', () {
    final message = PasskeyFailureMapper.map(
      Exception(
        'ApiException(statusCode: 403, code: NETWORK_BLOCKED, message: blocked by fortiguard)',
      ),
    );

    expect(
      message,
      'Akses ke server diblokir kebijakan jaringan. Coba jaringan lain atau ganti domain backend.',
    );
  });

  test('maps ngrok offline error', () {
    final message = PasskeyFailureMapper.map(
      Exception(
        'ApiException(statusCode: 404, code: TUNNEL_OFFLINE, message: ERR_NGROK_3200 endpoint is offline)',
      ),
    );

    expect(
      message,
      'Server backend sedang offline (tunnel ngrok mati). Jalankan ulang backend/tunnel lalu coba lagi.',
    );
  });

  test('maps timeout error', () {
    final message = PasskeyFailureMapper.map(
      Exception(
        'ApiException(statusCode: null, code: TIMEOUT_ERROR, message: connection timeout)',
      ),
    );

    expect(
      message,
      'Koneksi ke server timeout. Cek backend/tunnel dan coba lagi.',
    );
  });
}
