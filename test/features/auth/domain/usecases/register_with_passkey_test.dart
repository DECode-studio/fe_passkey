import 'package:fe_passkey/features/auth/domain/repositories/auth_repository.dart';
import 'package:fe_passkey/features/auth/domain/usecases/register_with_passkey.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterWithPasskey useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterWithPasskey(mockRepository);
  });

  const tEmail = 'test@example.com';
  const tDisplayName = 'Test User';

  test('should call registerWithPasskey on the repository', () async {
    // arrange
    when(() => mockRepository.registerWithPasskey(
          email: any(named: 'email'),
          displayName: any(named: 'displayName'),
        )).thenAnswer((_) async => {});

    // act
    await useCase(email: tEmail, displayName: tDisplayName);

    // assert
    verify(() => mockRepository.registerWithPasskey(
          email: tEmail,
          displayName: tDisplayName,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw an exception when repository fails', () async {
    // arrange
    when(() => mockRepository.registerWithPasskey(
          email: any(named: 'email'),
          displayName: any(named: 'displayName'),
        )).thenThrow(Exception('Failed'));

    // assert
    expect(
      () => useCase(email: tEmail, displayName: tDisplayName),
      throwsA(isA<Exception>()),
    );
    verify(() => mockRepository.registerWithPasskey(
          email: tEmail,
          displayName: tDisplayName,
        )).called(1);
  });
}
