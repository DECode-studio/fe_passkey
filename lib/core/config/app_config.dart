import 'env.dart';

class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.rpId});

  final String apiBaseUrl;
  final String rpId;

  static final current = AppConfig(apiBaseUrl: Env.apiBaseUrl, rpId: Env.rpId);
}
