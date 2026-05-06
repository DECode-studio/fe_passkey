import 'package:fe_passkey/features/auth/domain/repositories/auth_repository.dart';
import 'package:fe_passkey/features/auth/domain/usecases/login_with_passkey.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginWithPasskey useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginWithPasskey(mockRepository);
  });

  const tEmail = 'test@example.com';

  test('should call loginWithPasskey on the repository', () async {
    // arrange
    when(() => mockRepository.loginWithPasskey(
          email: any(named: 'email'),
        )).thenAnswer((_) async => {});

    // act
    await useCase(email: tEmail);

    // assert
    verify(() => mockRepository.loginWithPasskey(
          email: tEmail,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should support nullable email for username-less login', () async {
    // arrange
    when(() => mockRepository.loginWithPasskey(
          email: null,
        )).thenAnswer((_) async => {});

    // act
    await useCase();

    // assert
    verify(() => mockRepository.loginWithPasskey(
          email: null,
        )).called(1);
  });
}
