import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/auth_token_model.dart';
import '../models/passkey_options_model.dart';

@injectable
class AuthRemoteDatasource {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  Future<PasskeyOptionsModel> getRegisterOptions({
    required String email,
    String? displayName,
  }) async {
    final response = await _dio.post(
      '/passkey/register/options',
      data: {
        'email': email,
        // ignore: use_null_aware_elements
        if (displayName != null) 'displayName': displayName,
      },
    );

    return PasskeyOptionsModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthTokenModel> verifyRegister({
    required String email,
    required Map<String, dynamic> response,
  }) async {
    final result = await _dio.post(
      '/passkey/register/verify',
      data: {'email': email, 'response': response},
    );

    return AuthTokenModel.fromJson(result.data as Map<String, dynamic>);
  }

  Future<PasskeyOptionsModel> getLoginOptions({String? email}) async {
    final response = await _dio.post(
      '/passkey/login/options',
      data: {if (email != null && email.isNotEmpty) 'email': email},
    );

    return PasskeyOptionsModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthTokenModel> verifyLogin({
    required String email,
    required Map<String, dynamic> response,
  }) async {
    final result = await _dio.post(
      '/passkey/login/verify',
      data: {'email': email, 'response': response},
    );

    return AuthTokenModel.fromJson(result.data as Map<String, dynamic>);
  }

  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/passkey/refresh',
      data: {'refreshToken': refreshToken},
    );

    return AuthTokenModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }
}
