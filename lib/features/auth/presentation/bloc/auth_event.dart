import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthRegisterWithPasskeyRequested extends AuthEvent {
  const AuthRegisterWithPasskeyRequested({
    required this.email,
    this.displayName,
  });

  final String email;
  final String? displayName;

  @override
  List<Object?> get props => [email, displayName];
}

class AuthLoginWithPasskeyRequested extends AuthEvent {
  const AuthLoginWithPasskeyRequested({this.email});

  final String? email;

  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
