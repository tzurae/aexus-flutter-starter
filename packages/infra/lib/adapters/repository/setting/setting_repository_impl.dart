import 'dart:async';

import 'package:domains/setting/setting_repository.dart';
import 'package:infra/datasources/local/interfaces/locale_local_datasource.dart';
import 'package:infra/datasources/local/interfaces/theme_local_datasource.dart';

class SettingRepositoryImpl extends SettingRepository {
  // data source objects
  final ThemeLocalDataSource _themeLocalDataSource;
  final LocaleLocalDataSource _localeLocalDataSource;

  // constructor
  SettingRepositoryImpl(
    this._themeLocalDataSource,
    this._localeLocalDataSource,
  );

  // Theme: --------------------------------------------------------------------
  @override
  Future<void> changeBrightnessToDark(bool value) =>
      _themeLocalDataSource.saveIsDarkMode(value);

  @override
  Future<bool> isDarkMode() => _themeLocalDataSource.isDarkMode();

  // Language: -----------------------------------------------------------------
  @override
  Future<void> changeLanguage(String value) =>
      _localeLocalDataSource.saveLanguageCode(value);

  @override
  Future<String?> get currentLanguage =>
      _localeLocalDataSource.getLanguageCode();
}
