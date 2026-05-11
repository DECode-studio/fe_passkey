import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
  securityNotSet,
}

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.message,
    this.isPasskeySupported = true,
  });

  final AuthStatus status;
  final String? message;
  final bool isPasskeySupported;

  const AuthState.initial()
      : status = AuthStatus.initial,
        message = null,
        isPasskeySupported = true;

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    bool? isPasskeySupported,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      isPasskeySupported: isPasskeySupported ?? this.isPasskeySupported,
    );
  }

  @override
  List<Object?> get props => [status, message, isPasskeySupported];
}
