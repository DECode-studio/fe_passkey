import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:passkeys/authenticator.dart';
import '../network/dio_client.dart';
import '../storage/secure_token_storage.dart';
import '../storage/token_storage.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  TokenStorage tokenStorage(FlutterSecureStorage storage) => SecureTokenStorage(storage);

  @lazySingleton
  DioClient dioClient(TokenStorage tokenStorage) => DioClient(tokenStorage);

  @lazySingleton
  Dio dio(DioClient client) => client.create();

  @lazySingleton
  PasskeyAuthenticator get passkeyAuthenticator => PasskeyAuthenticator();
}
