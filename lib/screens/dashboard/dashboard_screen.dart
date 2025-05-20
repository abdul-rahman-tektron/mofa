import 'package:flutter/material.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_language_text.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(context.watchLang.translate(AppLanguageText.dashboard)),
      ),
    );
  }
}
