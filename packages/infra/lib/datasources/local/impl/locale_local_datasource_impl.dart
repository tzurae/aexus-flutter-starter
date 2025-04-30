import 'package:infra/datasources/local/constants/preferences.dart';
import 'package:infra/datasources/local/interfaces/locale_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  final SharedPreferences _sharedPreference;

  LocaleLocalDataSourceImpl(this._sharedPreference);

  @override
  Future<String?> getLanguageCode() async {
    // Assuming 'current_language' is the key, add it to Preferences.dart if needed
    return _sharedPreference.getString(Preferences.current_language);
  }

  @override
  Future<void> saveLanguageCode(String code) async {
    // Assuming 'current_language' is the key, add it to Preferences.dart if needed
    await _sharedPreference.setString(Preferences.current_language, code);
  }
}
