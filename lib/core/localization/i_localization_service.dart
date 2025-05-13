abstract class ILocalizationService {
  Future<void> load(String languageCode);
  String translate(String key);
  String get currentLanguage;
}
