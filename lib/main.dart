import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/localization/localization_service.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/res/app_theme.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/error_handler.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';
import 'screens/bottom_bar/bottom_bar_screen.dart';
import 'screens/login/login_screen.dart';

Future<void> main() async {

  runZonedGuarded(() async {
    // Initialize Flutter bindings **inside the zone**
    WidgetsFlutterBinding.ensureInitialized();

    // Lock orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize secure storage
    await SecureStorageHelper.init();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize your error handler
    await ErrorHandler.initialize();

    // Load localization and get token
    String languageCode = await SecureStorageHelper.getLanguageCode() ?? "en";
    final token = await SecureStorageHelper.getToken();
    final localizationService = LocalizationService();
    await localizationService.load(languageCode);

    // Run the app
    runApp(MyApp(localizationService: localizationService, token: token));
  }, (error, stackTrace) async {
    // Global error handler, report to Crashlytics or logs
    await ErrorHandler.recordError(error, stackTrace, fatal: true);
  });
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
          print("MediaQuery.of(context).devicePixelRatio");
          print(MediaQuery.of(context).devicePixelRatio);
          print(MediaQuery.of(context).textScaleFactor);
          print(MediaQuery.of(context).size);
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,               // adapt text for smaller screens
            splitScreenMode: true,
            child: ToastificationWrapper(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: Locale(context.watch<LanguageNotifier>().currentLang),
                supportedLocales: [
                  Locale(LanguageCode.en.name),
                  Locale(LanguageCode.ar.name),
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
                  context.watchLang.currentLang == LanguageCode.ar.name ? 'DroidKufi' : 'Lexend',
                ),
                title: 'Mofa',
                builder: (context, child) {
                    final mediaQueryData = MediaQuery.of(context);
                    final pixelRatio = mediaQueryData.devicePixelRatio;

                    // Apply custom logic based on density threshold
                    final textScale = pixelRatio > 3.0 ? 0.8 : 1.0;

                    print("textScale");
                    print(pixelRatio);
                    print(textScale);

                    return MediaQuery(
                      data: mediaQueryData.copyWith(textScaleFactor: textScale),
                      child: child!,
                    );
                },
              ),
            ),
          );
        }
      ),
    );
  }
}

