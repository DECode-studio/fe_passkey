import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/env.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient(this._tokenStorage);

  final TokenStorage _tokenStorage;

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Use our dedicated AuthInterceptor
    dio.interceptors.add(AuthInterceptor(_tokenStorage, dio));

    // Add logging interceptor if in debug mode
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );

    return dio;
  }
}
