import 'dart:async';

import 'package:domains/locale/locale_repository.dart';
import 'package:flutter/material.dart';
// import 'package:infra/datasources/local/sharedpref/shared_preference_helper.dart'; // Removed
import 'package:infra/datasources/local/interfaces/locale_local_datasource.dart'; // Added

class LocaleRepositoryImpl implements LocaleRepository {
  // final SharedPreferenceHelper _sharedPreferenceHelper; // Removed
  final LocaleLocalDataSource _localeLocalDataSource; // Added

  static const Locale _defaultLocale = Locale('en'); // Default to language code only

  LocaleRepositoryImpl(this._localeLocalDataSource); // Changed constructor

  @override
  Future<Locale> getLocale() async {
    final languageCode = await _localeLocalDataSource.getLanguageCode(); // Changed

    if (languageCode != null && languageCode.isNotEmpty) {
      // Potentially split languageCode if it contains region (e.g., "en_US")
      // For simplicity, assuming only language code is stored.
      return Locale(languageCode);
    }

    return _defaultLocale;
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _localeLocalDataSource.saveLanguageCode(locale.languageCode); // Changed
  }
}
