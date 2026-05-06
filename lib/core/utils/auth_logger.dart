import 'logger.dart';

class AuthLogger {
  static void logPasskeyStart(String flow, {String? identifier}) {
    CoreLogger.i('[PASSKEY][$flow] Flow started${identifier != null ? ' for $identifier' : ''}');
  }

  static void logPasskeySuccess(String flow) {
    CoreLogger.i('[PASSKEY][$flow] Flow completed successfully ✨');
  }

  static void logPasskeyFailure(String flow, Object error) {
    CoreLogger.e('[PASSKEY][$flow] Flow failed', error);
  }

  static void logTokenRefresh(bool success) {
    if (success) {
      CoreLogger.i('[AUTH][TOKEN] Refresh successful');
    } else {
      CoreLogger.w('[AUTH][TOKEN] Refresh failed - session cleared');
    }
  }

  static void logSecurityEvent(String message) {
    CoreLogger.w('[SECURITY] $message');
  }
}
