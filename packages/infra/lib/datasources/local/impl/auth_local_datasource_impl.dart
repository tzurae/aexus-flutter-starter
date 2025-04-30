import 'package:infra/datasources/local/constants/preferences.dart';
import 'package:infra/datasources/local/interfaces/auth_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreference;

  AuthLocalDataSourceImpl(this._sharedPreference);

  @override
  Future<String?> getAuthToken() async {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await _sharedPreference.setString(Preferences.auth_token, token);
  }

  @override
  Future<void> clearAuthToken() async {
    await _sharedPreference.remove(Preferences.auth_token);
  }

  @override
  Future<bool> isLoggedIn() async {
    return _sharedPreference.getBool(Preferences.is_logged_in) ?? false;
  }

  @override
  Future<void> saveIsLoggedIn(bool value) async {
    await _sharedPreference.setBool(Preferences.is_logged_in, value);
  }

  @override
  Future<void> clearLoginStatus() async {
    await _sharedPreference.remove(Preferences.is_logged_in);
  }
}
