import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/localization/localization_service.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/res/app_theme.dart';
import 'package:mofa/utils/common/app_routes.dart';
import 'package:mofa/utils/common/encrypt.dart';
import 'package:mofa/utils/common/secure_storage.dart';
import 'package:provider/provider.dart';

import 'screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageHelper.init();
  String languageCode = await SecureStorageHelper.getLanguageCode() ?? "en";
  final localizationService = LocalizationService();
  await localizationService.load(languageCode); // Default language
  runApp(MyApp(localizationService: localizationService,));
}

class MyApp extends StatelessWidget {
  LocalizationService localizationService = LocalizationService();
  MyApp({super.key, required this.localizationService});

  // This widget is the root of your application.
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommonNotifier>(
          create: (_) => CommonNotifier(),
        ),
        ChangeNotifierProvider<LanguageNotifier>(
          create: (_) => LanguageNotifier(localizationService),
        ),
      ],
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: Locale(context.watch<LanguageNotifier>().currentLang),
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              navigatorKey: navigatorKey,
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: AppRoutes.login,
              theme: AppTheme.theme,
              title: 'Mofa',
            ),
          );
        }
      ),
    );
  }
}

