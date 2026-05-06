import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class CheckPasskeySupport {
  CheckPasskeySupport(this._repository);

  final AuthRepository _repository;

  Future<bool> call() async {
    return _repository.checkPasskeySupport();
  }
}
