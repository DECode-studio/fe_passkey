import '../../../../core/utils/logger.dart';

class PasskeyFailureMapper {
  static String map(Object error) {
    final raw = error.toString().toLowerCase();
    CoreLogger.d('[MAPPER] Mapping raw error: $raw');

    if (raw.contains('cancel') || raw.contains('abort')) {
      return 'Autentikasi dibatalkan.';
    }

    if (raw.contains('no credential') ||
        raw.contains('not found') ||
        raw.contains('notallowed')) {
      return 'Passkey tidak ditemukan atau tidak bisa digunakan di device ini.';
    }

    if (raw.contains('network_blocked') ||
        raw.contains('fortiguard') ||
        raw.contains('proxy avoidance')) {
      return 'Akses ke server diblokir kebijakan jaringan. Coba jaringan lain atau ganti domain backend.';
    }

    if (raw.contains('tunnel_offline') ||
        raw.contains('err_ngrok_3200') ||
        raw.contains('is offline')) {
      return 'Server backend sedang offline (tunnel ngrok mati). Jalankan ulang backend/tunnel lalu coba lagi.';
    }

    if (raw.contains('timeout_error') || raw.contains('timeout')) {
      return 'Koneksi ke server timeout. Cek backend/tunnel dan coba lagi.';
    }

    if (raw.contains('network') || raw.contains('socket')) {
      return 'Koneksi bermasalah. Periksa internet Anda.';
    }

    if (raw.contains('challenge')) {
      return 'Sesi autentikasi kedaluwarsa. Silakan coba lagi.';
    }

    if (raw.contains('unsupported')) {
      return 'Device ini belum mendukung passkey.';
    }

    return 'Terjadi kesalahan saat autentikasi passkey. Coba lagi.';
  }
}
