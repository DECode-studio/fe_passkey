import 'package:bloc_test/bloc_test.dart';
import 'package:fe_passkey/core/storage/token_storage.dart';
import 'package:fe_passkey/features/auth/domain/usecases/check_passkey_support.dart';
import 'package:fe_passkey/features/auth/domain/usecases/login_with_passkey.dart';
import 'package:fe_passkey/features/auth/domain/usecases/logout.dart';
import 'package:fe_passkey/features/auth/domain/usecases/register_with_passkey.dart';
import 'package:fe_passkey/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fe_passkey/features/auth/presentation/bloc/auth_event.dart';
import 'package:fe_passkey/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterWithPasskey extends Mock implements RegisterWithPasskey {}
class MockLoginWithPasskey extends Mock implements LoginWithPasskey {}
class MockLogout extends Mock implements Logout {}
class MockCheckPasskeySupport extends Mock implements CheckPasskeySupport {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late AuthBloc authBloc;
  late MockRegisterWithPasskey mockRegister;
  late MockLoginWithPasskey mockLogin;
  late MockLogout mockLogout;
  late MockCheckPasskeySupport mockCheckSupport;
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockRegister = MockRegisterWithPasskey();
    mockLogin = MockLoginWithPasskey();
    mockLogout = MockLogout();
    mockCheckSupport = MockCheckPasskeySupport();
    mockTokenStorage = MockTokenStorage();

    authBloc = AuthBloc(
      registerWithPasskey: mockRegister,
      loginWithPasskey: mockLogin,
      logout: mockLogout,
      checkPasskeySupport: mockCheckSupport,
      tokenStorage: mockTokenStorage,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when token exists and passkey is supported',
      build: () {
        when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => 'valid_token');
        when(() => mockCheckSupport()).thenAnswer((_) async => true);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthState(status: AuthStatus.authenticated, isPasskeySupported: true),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when token is null',
      build: () {
        when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => null);
        when(() => mockCheckSupport()).thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthState(status: AuthStatus.unauthenticated, isPasskeySupported: false),
      ],
    );
  });

  group('AuthRegisterWithPasskeyRequested', () {
    const tEmail = 'test@example.com';
    const tName = 'Test';

    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when registration is successful',
      build: () {
        when(() => mockRegister(email: any(named: 'email'), displayName: any(named: 'displayName')))
            .thenAnswer((_) async => {});
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthRegisterWithPasskeyRequested(email: tEmail, displayName: tName)),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.authenticated),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, failure] when registration fails',
      build: () {
        when(() => mockRegister(email: any(named: 'email'), displayName: any(named: 'displayName')))
            .thenThrow(Exception('Failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthRegisterWithPasskeyRequested(email: tEmail, displayName: tName)),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.failure),
      ],
    );
  });
}
