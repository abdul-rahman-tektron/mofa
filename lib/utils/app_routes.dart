// lib/routes/app_routes.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/model/custom_args/custom_args.dart';
import 'package:mofa/screens/apply_pass/apply_pass_screen.dart';
import 'package:mofa/screens/apply_pass_category/apply_pass_category_screen.dart'
    show ApplyPassCategoryScreen;
import 'package:mofa/screens/bottom_bar/bottom_bar_screen.dart';
import 'package:mofa/screens/custom_screen/network_error_screen.dart';
import 'package:mofa/screens/custom_screen/not_found_screen.dart';
import 'package:mofa/screens/edit_profile/edit_profile_screen.dart';
import 'package:mofa/screens/finish_apply_pass/finish_apply_pass_screen.dart';
import 'package:mofa/screens/health_and_safety/health_and_safety_screen.dart';
import 'package:mofa/screens/login/login_screen.dart';
import 'package:mofa/screens/pdf_viewer/pdf_viewer.dart';
import 'package:mofa/screens/register/register_screen.dart';
import 'package:mofa/screens/stepper_handler/stepper_handler_screen.dart';
import 'package:mofa/utils/enum_values.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String applyPass = '/apply-pass';
  static const String stepper = '/stepper';
  static const String applyPassCategory = '/apply-pass-category';
  static const String bottomBar = '/bottom-bar';
  static const String healthAndSafety = '/health-and-safety';
  static const String finishApplyPass = '/finish-apply-pass';
  static const String pdfViewer = '/pdf_viewer';
  static const String editProfile = '/edit-profile';
  static const String networkError = '/network-error';
  static const String notFound = '/not-found';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.bottomBar:
        return MaterialPageRoute(builder: (_) => BottomBarScreen());

      case AppRoutes.applyPass:
        return MaterialPageRoute(builder: (_) => const ApplyPassScreen());

      case AppRoutes.pdfViewer:
        final args = settings.arguments as Uint8List;
        return MaterialPageRoute(
          builder: (_) => PdfFullScreenViewer(pdfBytes: args),
        );

      case AppRoutes.stepper:
        final args = settings.arguments as StepperScreenArgs;
        return MaterialPageRoute(
          builder: (_) => StepperHandlerScreen(
            category: args.category,
            isUpdate: args.isUpdate,
            id: args.id,
          ),
        );


      case AppRoutes.applyPassCategory:
        final args = settings.arguments as ApplyPassCategory;
        return MaterialPageRoute(
          builder:
              (_) => ApplyPassCategoryScreen(category: args, onNext: () {}),
        );

      case AppRoutes.healthAndSafety:
        return MaterialPageRoute(
          builder:
              (_) => HealthAndSafetyScreen(onNext: () {}, onPrevious: () {}),
        );

        case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder:
              (_) => EditProfileScreen(),
        );

      case AppRoutes.finishApplyPass:
        return MaterialPageRoute(
          builder: (_) => FinishApplyPassScreen(onPrevious: () {}),
        );

      case AppRoutes.networkError:
        return MaterialPageRoute(builder: (_) => const NetworkErrorScreen());

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
