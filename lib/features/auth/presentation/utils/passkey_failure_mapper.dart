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
