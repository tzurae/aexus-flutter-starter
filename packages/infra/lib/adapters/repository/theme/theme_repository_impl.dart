import 'dart:async';

import 'package:domains/theme/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:infra/datasources/local/interfaces/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource _themeLocalDataSource;

  static const ThemeMode _defaultThemeMode = ThemeMode.system;

  ThemeRepositoryImpl(this._themeLocalDataSource);

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeModeIndex = await _themeLocalDataSource.getThemeMode();

    if (themeModeIndex != null &&
        themeModeIndex >= 0 &&
        themeModeIndex < ThemeMode.values.length) {
      return ThemeMode.values[themeModeIndex];
    }

    return _defaultThemeMode;
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _themeLocalDataSource.saveThemeMode(themeMode.index);
  }

  @override
  Future<bool> isDarkMode() async {
    return _themeLocalDataSource.isDarkMode();
  }
}
