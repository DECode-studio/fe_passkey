import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterWithPasskey {
  const RegisterWithPasskey(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email, String? displayName}) {
    return _repository.registerWithPasskey(email: email, displayName: displayName);
  }
}
