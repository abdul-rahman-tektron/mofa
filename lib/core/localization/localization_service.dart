import 'dart:convert';
import 'package:flutter/services.dart';
import 'i_localization_service.dart';

class LocalizationService implements ILocalizationService {
  late Map<String, String> _localizedStrings;
  String _currentLanguage = 'en';

  @override
  String get currentLanguage => _currentLanguage;

  @override
  Future<void> load(String languageCode) async {
    final jsonStr = await rootBundle.loadString('assets/locales/$languageCode/translation.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    _currentLanguage = languageCode;
  }

  @override
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
