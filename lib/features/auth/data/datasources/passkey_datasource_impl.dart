import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
import 'passkey_datasource.dart';

@LazySingleton(as: PasskeyDatasource)
class PasskeyDatasourceImpl implements PasskeyDatasource {
  PasskeyDatasourceImpl(this._authenticator);

  final PasskeyAuthenticator _authenticator;

  @override
  Future<Map<String, dynamic>> register({
    required Map<String, dynamic> publicKeyOptions,
  }) async {
    final jsonOptions = jsonEncode(publicKeyOptions);
    debugPrint('[PASSKEY] Encoded JSON: $jsonOptions');
    final request = RegisterRequestType.fromJsonString(jsonOptions);
    debugPrint('[PASSKEY] RegisterRequestType: ${request.toJsonString()}');
    final response = await _authenticator.register(request);
    return jsonDecode(response.toJsonString()) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> authenticate({
    required Map<String, dynamic> publicKeyOptions,
  }) async {
    final jsonOptions = jsonEncode(publicKeyOptions);
    debugPrint('[PASSKEY] Encoded JSON: $jsonOptions');
    final request = AuthenticateRequestType.fromJsonString(jsonOptions);
    debugPrint('[PASSKEY] AuthenticateRequestType: ${request.toJsonString()}');
    final response = await _authenticator.authenticate(request);
    return jsonDecode(response.toJsonString()) as Map<String, dynamic>;
  }

  @override
  Future<bool> isSupported() async {
    try {
      if (kIsWeb) {
        final availability = await _authenticator.getAvailability().web();
        return availability.hasPasskeySupport;
      } else if (Platform.isAndroid) {
        final availability = await _authenticator.getAvailability().android();
        return availability.hasPasskeySupport;
      } else if (Platform.isIOS || Platform.isMacOS) {
        final availability = await _authenticator.getAvailability().iOS();
        return availability.hasPasskeySupport;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
