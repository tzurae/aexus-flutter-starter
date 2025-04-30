import 'package:domains/auth/auth_repository.dart';
import 'package:domains/auth/login_credentials_vo.dart';
import 'package:infra/datasources/local/interfaces/auth_local_datasource.dart';
import 'package:infra/datasources/remote/interfaces/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
  );

  @override
  Future<bool> isLoggedIn() async {
    final isSupabaseLoggedIn = await _authRemoteDataSource.isLoggedIn();
    if (isSupabaseLoggedIn) {
      await _authLocalDataSource.saveIsLoggedIn(true);
      return true;
    }
    return _authLocalDataSource.isLoggedIn();
  }

  @override
  Future<bool> login(LoginCredentials params) async {
    final success = await _authRemoteDataSource.login(
      params.username,
      params.password,
    );
    if (success) {
      await _authLocalDataSource.saveIsLoggedIn(true);
    }
    return success;
  }

  @override
  Future<void> logout() async {
    await _authRemoteDataSource.logout();
    await _authLocalDataSource.clearLoginStatus();
    await _authLocalDataSource.clearAuthToken();
  }
}
