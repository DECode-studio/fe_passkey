import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL')
  static String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'RP_ID')
  static String rpId = _Env.rpId;
}
