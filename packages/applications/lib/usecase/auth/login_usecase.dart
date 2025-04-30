import 'package:applications/core/use_case.dart';
import 'package:applications/dto/login_params_dto.dart';
import 'package:domains/auth/auth_repository.dart';
import 'package:domains/auth/login_credentials_vo.dart';

part 'login_usecase.g.dart';

class LoginUseCase implements UseCase<bool, LoginParamsDTO> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<bool> call({required LoginParamsDTO params}) async {
    final credentials = LoginCredentials(
      username: params.email,
      password: params.password,
    );
    return _authRepository.login(credentials);
  }
}
