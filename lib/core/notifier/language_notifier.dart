import 'package:flutter/material.dart';
import 'package:mofa/core/localization/i_localization_service.dart';
import 'package:mofa/utils/common/secure_storage.dart';

class LanguageNotifier extends ChangeNotifier {
  final ILocalizationService _localizationService;

  LanguageNotifier(this._localizationService);

  String get currentLang => _localizationService.currentLanguage;

  Future<void> switchLanguage(String langCode) async {
    print(langCode);
    await _localizationService.load(langCode);
    await SecureStorageHelper.setLanguageCode(langCode);
    notifyListeners();
  }

  String translate(String key) {
    return _localizationService.translate(key);
  }
}
