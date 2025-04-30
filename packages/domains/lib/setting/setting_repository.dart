import 'dart:async';

abstract class SettingRepository {
  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value);

  Future<bool> isDarkMode(); // Changed to return Future<bool>

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value);

  Future<String?> get currentLanguage; // Changed to return Future<String?>
}
