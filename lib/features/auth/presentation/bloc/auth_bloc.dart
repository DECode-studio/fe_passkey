import 'package:fe_passkey/core/storage/token_storage.dart';
import 'package:fe_passkey/core/utils/auth_logger.dart';
import 'package:fe_passkey/core/utils/security_utils.dart';
import 'package:fe_passkey/features/auth/domain/usecases/check_passkey_support.dart';
import 'package:fe_passkey/features/auth/domain/usecases/login_with_passkey.dart';
import 'package:fe_passkey/features/auth/domain/usecases/logout.dart';
import 'package:fe_passkey/features/auth/domain/usecases/register_with_passkey.dart';
import 'package:fe_passkey/features/auth/presentation/utils/passkey_failure_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RegisterWithPasskey registerWithPasskey,
    required LoginWithPasskey loginWithPasskey,
    required Logout logout,
    required CheckPasskeySupport checkPasskeySupport,
    required TokenStorage tokenStorage,
  }) : _registerWithPasskey = registerWithPasskey,
       _loginWithPasskey = loginWithPasskey,
       _logout = logout,
       _checkPasskeySupport = checkPasskeySupport,
       _tokenStorage = tokenStorage,
       super(const AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthRegisterWithPasskeyRequested>(_onRegisterWithPasskey);
    on<AuthLoginWithPasskeyRequested>(_onLoginWithPasskey);
    on<AuthLogoutRequested>(_onLogout);
  }

  final RegisterWithPasskey _registerWithPasskey;
  final LoginWithPasskey _loginWithPasskey;
  final Logout _logout;
  final CheckPasskeySupport _checkPasskeySupport;
  final TokenStorage _tokenStorage;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final isSupported = await _checkPasskeySupport();
    final token = await _tokenStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          isPasskeySupported: isSupported,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          isPasskeySupported: isSupported,
        ),
      );
    }
  }

  Future<void> _onRegisterWithPasskey(
    AuthRegisterWithPasskeyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    AuthLogger.logPasskeyStart('Register');

    // Check device security and Google Play Services
    final requirements = await SecurityUtils.checkSecurityRequirements();
    
    if (!requirements['isSecure']!) {
      emit(state.copyWith(
        status: AuthStatus.securityNotSet,
        message: 'Security PIN/Biometric belum diatur. Mohon atur keamanan perangkat Anda terlebih dahulu.',
      ));
      return;
    }

    if (!requirements['isPlayServicesAvailable']!) {
      emit(state.copyWith(
        status: AuthStatus.playServicesMissing,
        message: 'Google Play Services atau Google Password Manager belum aktif. Pastikan Anda sudah login ke Akun Google di perangkat ini.',
      ));
      return;
    }

    try {
      await _registerWithPasskey(
        email: event.email,
        displayName: event.displayName,
      );

      AuthLogger.logPasskeySuccess('Register');
      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (error) {
      AuthLogger.logPasskeyFailure('Register', error);
      emit(
        state.copyWith(status: AuthStatus.failure, message: _mapError(error)),
      );
    }
  }

  Future<void> _onLoginWithPasskey(
    AuthLoginWithPasskeyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    AuthLogger.logPasskeyStart('Login');

    // Check device security and Google Play Services
    final requirements = await SecurityUtils.checkSecurityRequirements();
    
    if (!requirements['isSecure']!) {
      emit(state.copyWith(
        status: AuthStatus.securityNotSet,
        message: 'Security PIN/Biometric belum diatur. Mohon atur keamanan perangkat Anda terlebih dahulu.',
      ));
      return;
    }

    if (!requirements['isPlayServicesAvailable']!) {
      emit(state.copyWith(
        status: AuthStatus.playServicesMissing,
        message: 'Google Play Services atau Google Password Manager belum aktif. Pastikan Anda sudah login ke Akun Google di perangkat ini.',
      ));
      return;
    }

    try {
      await _loginWithPasskey(email: event.email);

      AuthLogger.logPasskeySuccess('Login');
      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (error) {
      AuthLogger.logPasskeyFailure('Login', error);
      emit(
        state.copyWith(status: AuthStatus.failure, message: _mapError(error)),
      );
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _logout();
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  String _mapError(Object error) {
    return PasskeyFailureMapper.map(error);
  }
}
