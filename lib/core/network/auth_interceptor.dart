import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../di/injection.dart';
import '../utils/auth_logger.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._dio);

  final TokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      if (_isRefreshing) {
        // If already refreshing, you might want to wait or just proceed with error
        // For POC, we'll let it fail or implement a simple queue if needed.
        return handler.next(err);
      }

      _isRefreshing = true;
      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          final remoteDatasource = getIt<AuthRemoteDatasource>();
          final session = await remoteDatasource.refreshToken(refreshToken);

          await _tokenStorage.saveTokens(
            accessToken: session.accessToken,
            refreshToken: session.refreshToken,
          );

          AuthLogger.logTokenRefresh(true);

          // Retry the original request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';
          
          final response = await _dio.fetch(options);
          _isRefreshing = false;
          return handler.resolve(response);
        }
      } catch (_) {
        AuthLogger.logTokenRefresh(false);
        await _tokenStorage.clear();
      } finally {
        _isRefreshing = false;
      }
    } else if (statusCode == 403 || statusCode == 409) {
      AuthLogger.logSecurityEvent('Critical Error $statusCode - Clearing Session');
      await _tokenStorage.clear();
    }

    return handler.next(err);
  }
}
