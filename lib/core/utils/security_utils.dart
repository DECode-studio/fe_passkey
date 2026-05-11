import 'package:local_auth/local_auth.dart';
import 'package:app_settings/app_settings.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'dart:io';
import 'logger.dart';

class SecurityUtils {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Checks for all security requirements for Passkeys on Android
  static Future<Map<String, bool>> checkSecurityRequirements() async {
    final bool isSecure = await isDeviceSecure();
    bool isPlayServicesAvailable = true;

    if (Platform.isAndroid) {
      try {
        final GooglePlayServicesAvailability availability = 
            await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
        isPlayServicesAvailable = availability == GooglePlayServicesAvailability.success;
      } catch (e) {
        CoreLogger.e('Error checking Google Play Services: $e');
        isPlayServicesAvailable = false;
      }
    }

    return {
      'isSecure': isSecure,
      'isPlayServicesAvailable': isPlayServicesAvailable,
    };
  }

  /// Checks if the device has any security (PIN, Pattern, or Biometrics) set up.
  static Future<bool> isDeviceSecure() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      
      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      
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
