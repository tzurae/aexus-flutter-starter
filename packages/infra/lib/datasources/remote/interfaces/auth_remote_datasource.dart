abstract class AuthRemoteDataSource {
  Future<bool> login(String email, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
}
