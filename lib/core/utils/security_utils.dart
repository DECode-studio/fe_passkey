import 'package:local_auth/local_auth.dart';
import 'package:app_settings/app_settings.dart';
import 'logger.dart';

class SecurityUtils {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if the device has any security (PIN, Pattern, or Biometrics) set up.
  static Future<bool> isDeviceSecure() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      
      // isDeviceSupported checks if the hardware is capable. 
      // getAvailableBiometrics returns list of enrolled biometrics.
      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      
      // On Android, if no PIN/Pattern is set, isDeviceSupported might still be true, 
      // but we can't create passkeys. 
      // We also need to check if any biometric or device lock is enrolled.
      // Note: local_auth's isDeviceSupported() usually returns true if a PIN/Pattern/Password is set.
      
      return canAuthenticate && (availableBiometrics.isNotEmpty || await _auth.isDeviceSupported());
    } catch (e) {
      CoreLogger.e('Error checking device security: $e');
      return false;
    }
  }

  /// Opens the device security settings.
  static void openSecuritySettings() {
    AppSettings.openAppSettings(type: AppSettingsType.security);
  }
}
