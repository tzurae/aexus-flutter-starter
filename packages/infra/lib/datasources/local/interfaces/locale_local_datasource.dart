abstract class LocaleLocalDataSource {
  // Assuming locale is stored as a language code string
  Future<String?> getLanguageCode();
  Future<void> saveLanguageCode(String code);
}
