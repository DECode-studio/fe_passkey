import 'package:flutter/foundation.dart';

class AuthLogger {
  static void logPasskeyStart(String flow) {
    if (kDebugMode) {
      print('[PASSKEY][$flow] started');
    }
  }

  static void logPasskeySuccess(String flow) {
    if (kDebugMode) {
      print('[PASSKEY][$flow] success');
    }
  }

  static void logPasskeyFailure(String flow, Object error) {
    if (kDebugMode) {
      print('[PASSKEY][$flow] failure: $error');
    }
  }
}
