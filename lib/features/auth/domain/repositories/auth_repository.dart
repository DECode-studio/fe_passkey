abstract class AuthRepository {
  Future<void> registerWithPasskey({required String email, String? displayName});

  Future<void> loginWithPasskey({String? email});

  Future<void> logout();

  Future<bool> checkPasskeySupport();
}
