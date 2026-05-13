// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'services/admob_service.dart';
import 'services/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
// Initialize AdMob service
  await AdMobService().initializeAds();
  runApp(
    const ProviderScope(
      child: TapPicoApp(),
    ),
  );
}

class TapPicoApp extends ConsumerWidget {
  const TapPicoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eyeProtectorOn = ref.watch(eyeProtectorProvider);

    final app = MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppConstants.splashRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );

    if (!eyeProtectorOn) return app;

    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Color(0x33FF8C00),
        BlendMode.softLight,
      ),
      child: app,
    );
  }
}
