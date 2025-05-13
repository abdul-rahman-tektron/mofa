import 'package:flutter/material.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:provider/provider.dart';

extension TranslateX on BuildContext {
  LanguageNotifier get watchLang => watch<LanguageNotifier>();
  LanguageNotifier get readLang => read<LanguageNotifier>();

  String tr(String key) => readLang.translate(key);
  void switchLang(String lang) => readLang.switchLanguage(lang);
  String get lang => readLang.currentLang;
}