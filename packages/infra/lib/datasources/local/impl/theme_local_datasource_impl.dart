import 'package:infra/datasources/local/constants/preferences.dart';
import 'package:infra/datasources/local/interfaces/theme_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences _sharedPreference;

  ThemeLocalDataSourceImpl(this._sharedPreference);

  @override
  Future<int?> getThemeMode() async {
    return _sharedPreference.getInt(Preferences.theme_mode);
  }

  @override
  Future<void> saveThemeMode(int mode) async {
    await _sharedPreference.setInt(Preferences.theme_mode, mode);
  }

  @override
  Future<bool> isDarkMode() async {
    return _sharedPreference.getBool(Preferences.is_dark_mode) ?? false;
  }

  @override
  Future<void> saveIsDarkMode(bool value) async {
    await _sharedPreference.setBool(Preferences.is_dark_mode, value);
  }
}
