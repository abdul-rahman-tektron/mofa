import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/localization_service.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/res/app_theme.dart';
import 'package:mofa/screens/apply_pass/apply_pass_screen.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'screens/bottom_bar/bottom_bar_screen.dart';
import 'screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageHelper.init();
  String languageCode = await SecureStorageHelper.getLanguageCode() ?? "en";
  final token = await SecureStorageHelper.getToken();
  final localizationService = LocalizationService();
  await localizationService.load(languageCode); // Default language
  runApp(MyApp(localizationService: localizationService, token: token,));
}

class MyApp extends StatelessWidget {
  LocalizationService localizationService = LocalizationService();
  String? token;
  MyApp({super.key, required this.localizationService, required this.token});

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
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: ToastificationWrapper(
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
                // initialRoute: snapshot.data == true ? AppRoutes.home : AppRoutes.login,
                home: token != null ?  BottomBarScreen() : const LoginScreen(),
                theme: AppTheme.getTheme(
                  context.watch<LanguageNotifier>().currentLang == 'ar' ? 'DroidKufi' : 'Lexend',
                ),
                title: 'Mofa',
              ),
            ),
          );
        }
      ),
    );
  }
}

