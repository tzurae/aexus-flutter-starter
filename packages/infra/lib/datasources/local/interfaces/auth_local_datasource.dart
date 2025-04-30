abstract class AuthLocalDataSource {
  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);
  Future<void> clearAuthToken(); // Added for completeness

  Future<bool> isLoggedIn();
  Future<void> saveIsLoggedIn(bool value);
  Future<void> clearLoginStatus(); // Added for completeness
}
