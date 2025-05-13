// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:mofa/main_screen.dart';
import 'package:mofa/screens/custom_screen/network_error_screen.dart';
import 'package:mofa/screens/custom_screen/not_found_screen.dart';
import 'package:mofa/screens/login/login_screen.dart';
import 'package:mofa/screens/register/register_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String networkError = '/network-error';
  static const String notFound = '/not-found';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.networkError:
        return MaterialPageRoute(builder: (_) => const NetworkErrorScreen());

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}