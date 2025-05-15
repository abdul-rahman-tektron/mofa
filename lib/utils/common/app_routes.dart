// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:mofa/main_screen.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/screens/apply_pass/apply_pass_screen.dart';
import 'package:mofa/screens/apply_pass_category/apply_pass_category_screen.dart' show ApplyPassCategoryScreen;
import 'package:mofa/screens/custom_screen/network_error_screen.dart';
import 'package:mofa/screens/custom_screen/not_found_screen.dart';
import 'package:mofa/screens/login/login_screen.dart';
import 'package:mofa/screens/register/register_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String applyPass = '/apply-pass';
  static const String applyPassCategory = '/apply-pass-category';
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

      case AppRoutes.applyPass:
        return MaterialPageRoute(builder: (_) => const ApplyPassScreen());

      case AppRoutes.applyPassCategory:
        final args = settings.arguments as ApplyPassCategory;
        return MaterialPageRoute(
            builder: (_) => ApplyPassCategoryScreen(category: args));

      case AppRoutes.networkError:
        return MaterialPageRoute(builder: (_) => const NetworkErrorScreen());

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}