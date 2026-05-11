import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/auth_logger.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/passkey_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required PasskeyDatasource passkeyDatasource,
    required TokenStorage tokenStorage,
  }) : _remoteDatasource = remoteDatasource,
       _passkeyDatasource = passkeyDatasource,
       _tokenStorage = tokenStorage;

  final AuthRemoteDatasource _remoteDatasource;
  final PasskeyDatasource _passkeyDatasource;
  final TokenStorage _tokenStorage;

  @override
  Future<void> registerWithPasskey({required String email, String? displayName}) async {
    try {
      AuthLogger.logPasskeyStart('REGISTER', identifier: email);
      final options = await _remoteDatasource.getRegisterOptions(
        email: email,
        displayName: displayName,
      );

      CoreLogger.d('[AUTH] Register Options received: ${options.challengeId}');
      final credential = await _passkeyDatasource.register(
        publicKeyOptions: options.publicKey,
      );

      AuthLogger.logPasskeySuccess('REGISTER');
      final session = await _remoteDatasource.verifyRegister(
        email: email,
        response: credential,
      );

      await _tokenStorage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> loginWithPasskey({String? email}) async {
    try {
      AuthLogger.logPasskeyStart('LOGIN', identifier: email);
      final options = await _remoteDatasource.getLoginOptions(email: email);

      CoreLogger.d('[AUTH] Login Options received: ${options.challengeId}');
      final credential = await _passkeyDatasource.authenticate(
        publicKeyOptions: options.publicKey,
      );

      AuthLogger.logPasskeySuccess('LOGIN');
      final session = await _remoteDatasource.verifyLogin(
        email: email ?? '',
        response: credential,
      );

      await _tokenStorage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDatasource.logout();
    } finally {
      await _tokenStorage.clear();
    }
  }

  @override
  Future<bool> checkPasskeySupport() async {
    return _passkeyDatasource.isSupported();
  }

  void _handleError(Object error) {
    AuthLogger.logPasskeyFailure('GENERAL', error);

    if (error is ApiException) {
      throw error;
    }

    // For passkey native errors, we rethrow them so the BLoC can map them via PasskeyFailureMapper
    if (error.toString().contains('passkey') ||
        error.toString().contains('authenticator') ||
        error.toString().contains('RegisterRequestType') ||
        error.toString().contains('AuthenticateRequestType') ||
        error.toString().contains('PlatformException') ||
        error.toString().contains('TYPE_CREATE_PUBLIC_KEY_CREDENTIAL_DOM_EXCEPTION') ||
        error.toString().contains('TYPE_SECURITY_ERROR')) {
      throw error;
    }

    if (error is DioException) {
      final rawError = error.error?.toString() ?? '';
      final responseText = error.response?.data?.toString().toLowerCase() ?? '';
      final isTimeout = error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.message?.toLowerCase().contains('timeout') == true;
      final isTlsError = rawError.contains('CERTIFICATE_VERIFY_FAILED') ||
          rawError.contains('HandshakeException');
      final isNgrokOffline =
          error.response?.statusCode == 404 &&
          (responseText.contains('err_ngrok_3200') ||
              responseText.contains('is offline') ||
              responseText.contains('endpoint') && responseText.contains('offline'));
      final isNetworkPolicyBlocked =
          error.response?.statusCode == 403 &&
          (responseText.contains('fortiguard') ||
              responseText.contains('proxy avoidance') ||
              responseText.contains('web page blocked'));

      throw ApiException(
        message: isTimeout
            ? 'Koneksi ke server timeout. Pastikan backend/tunnel aktif dan jaringan stabil.'
            : isTlsError
            ? 'Gagal koneksi TLS. Untuk environment development, cek sertifikat/tunnel (ngrok) atau gunakan build debug terbaru.'
            : isNgrokOffline
                ? 'Tunnel backend sedang offline (ERR_NGROK_3200). Jalankan ulang tunnel atau update API_BASE_URL ke endpoint aktif.'
            : isNetworkPolicyBlocked
                ? 'Akses ke URL backend diblokir kebijakan jaringan (FortiGuard/Proxy filter). Gunakan endpoint yang tidak diblokir atau jaringan lain.'
                : (error.message ?? 'Terjadi kesalahan jaringan'),
        statusCode: error.response?.statusCode,
        code: isTimeout
            ? 'TIMEOUT_ERROR'
            : isTlsError
            ? 'TLS_ERROR'
            : isNgrokOffline
                ? 'TUNNEL_OFFLINE'
            : isNetworkPolicyBlocked
                ? 'NETWORK_BLOCKED'
                : 'NETWORK_ERROR',
      );
    }

    throw ApiException(
      message: 'Terjadi kesalahan tidak terduga: $error',
      code: 'UNKNOWN_ERROR',
    );
  }
}
