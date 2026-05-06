import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginWithPasskey {
  const LoginWithPasskey(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    String? email,
  }) {
    return _repository.loginWithPasskey(
      email: email,
    );
  }
}
