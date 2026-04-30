// lib/core/utils/app_router.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/alphabets/alphabets_screen.dart';
import '../../features/numbers/numbers_screen.dart';
import '../../features/shapes/shapes_screen.dart';
import '../../features/practice/practice_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/privacy_policy_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.splashRoute:
        return _route(const SplashScreen(), settings);

      case AppConstants.homeRoute:
        return _route(const HomeScreen(), settings);

      case AppConstants.alphabetsRoute:
        return _route(const AlphabetsScreen(), settings);

      case AppConstants.numbersRoute:
        return _route(const NumbersScreen(), settings);

      case AppConstants.shapesRoute:
        return _route(const ShapesScreen(), settings);

      case AppConstants.practiceRoute:
        return _route(const PracticeScreen(), settings);

      case AppConstants.settingsRoute:
        return _route(const SettingsScreen(), settings);

      case AppConstants.privacyPolicyRoute:
        return _route(const PrivacyPolicyScreen(), settings);

      default:
        return _errorRoute(settings);
    }
  }

  // ================= MAIN ROUTE =================
  static PageRouteBuilder _route(Widget page, RouteSettings settings) {
    final curved = CurvedAnimation(
      parent: const AlwaysStoppedAnimation(1), // placeholder (replaced below)
      curve: Curves.easeOutCubic,
    );

    return PageRouteBuilder(
      settings: settings, // ✅ IMPORTANT
      pageBuilder: (_, animation, _) {
        final curvedAnim =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(curvedAnim),
            child: page,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  // ================= ERROR ROUTE =================
  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(
          child: Text(
            'Route not found:\n${settings.name}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}