import 'package:applications/dto/index.dart';
import 'package:applications/usecase/auth/login_usecase.dart';
import 'package:domains/auth/auth_repository.dart';
import 'package:domains/auth/login_credentials_vo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void loginUsecaseTest() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  test('should return true when login is successful', () async {
    // Arrange
    final loginParams = LoginParamsDTO(
      email: 'test@example.com',
      password: 'password123',
    );

    when(mockAuthRepository.login(argThat(predicate<LoginCredentials>(
            (credentials) =>
                credentials.username == loginParams.email &&
                credentials.password == loginParams.password))))
        .thenAnswer((_) async => true);

    // Act
    final result = await loginUseCase.call(params: loginParams);

    // Assert
    expect(result, true);
    verify(mockAuthRepository.login(argThat(predicate<LoginCredentials>(
        (credentials) =>
            credentials.username == loginParams.email &&
            credentials.password == loginParams.password)))).called(1);
  });

  test('should return false when login fails', () async {
    // Arrange
    final loginParams = LoginParamsDTO(
      email: 'test@example.com',
      password: 'wrong_password',
    );

    when(mockAuthRepository.login(argThat(predicate<LoginCredentials>(
            (credentials) =>
                credentials.username == loginParams.email &&
                credentials.password == loginParams.password))))
        .thenAnswer((_) async => false);

    // Act
    final result = await loginUseCase.call(params: loginParams);

    // Assert
    expect(result, false);
  });
}
