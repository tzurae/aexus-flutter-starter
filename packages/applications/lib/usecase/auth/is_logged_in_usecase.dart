// package:applications/domain/use_case/auth/is_logged_in_use_case.dart;
import 'package:applications/core/use_case.dart';
import 'package:domains/auth/auth_repository.dart';

class IsLoggedInUseCase implements UseCase<bool, void> {
  final AuthRepository _authRepository;

  IsLoggedInUseCase(this._authRepository);

  @override
  Future<bool> call({required void params}) async {
    return await _authRepository.isLoggedIn();
  }
}
