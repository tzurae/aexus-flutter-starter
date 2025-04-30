abstract class ThemeLocalDataSource {
  Future<int?> getThemeMode();
  Future<void> saveThemeMode(int mode);

  Future<bool> isDarkMode(); // Keep based on SettingRepositoryImpl usage
  Future<void> saveIsDarkMode(
      bool value); // Keep based on SettingRepositoryImpl usage
}
