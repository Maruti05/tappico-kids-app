// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary   = Color(0xFF00C853); // vivid green
  static const Color secondary = Color(0xFFFF6D00); // vivid orange
  static const Color accent    = Color(0xFF2979FF); // vivid blue
  static const Color purple    = Color(0xFFAA00FF); // vivid purple
  static const Color pink      = Color(0xFFFF4081); // hot pink
  static const Color yellow    = Color(0xFFFFD600); // vivid yellow
  static const Color cyan      = Color(0xFF00E5FF); // vivid cyan
  static const Color red       = Color(0xFFFF1744); // vivid red

  // Background
  static const Color bgLight   = Color(0xFFF8F4FF); // warm lavender white
  static const Color bgCard    = Color(0xFFFFFFFF);

  // Text
  static const Color textDark  = Color(0xFF1A1A2E);
  static const Color textMid   = Color(0xFF444466);
  static const Color textLight = Color(0xFF888AAA);

  // Category card colors
  static const List<Color> alphabetGradient  = [Color(0xFF00C853), Color(0xFF69F0AE)];
  static const List<Color> numberGradient    = [Color(0xFFFF6D00), Color(0xFFFFAB40)];
  static const List<Color> shapeGradient     = [Color(0xFF2979FF), Color(0xFF82B1FF)];
  static const List<Color> practiceGradient  = [Color(0xFFAA00FF), Color(0xFFEA80FC)];
  static const List<Color> settingsGradient  = [Color(0xFFFF4081), Color(0xFFFF80AB)];

  // Letter card colors (cycling)
  static const List<Color> letterColors = [
    Color(0xFFFF1744), Color(0xFFFF6D00), Color(0xFFFFD600),
    Color(0xFF00C853), Color(0xFF2979FF), Color(0xFFAA00FF),
    Color(0xFFFF4081), Color(0xFF00E5FF), Color(0xFFFF6D00),
    Color(0xFF69F0AE), Color(0xFF82B1FF), Color(0xFFEA80FC),
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(
        fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.textDark,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.textDark,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMid,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMid,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textLight,
        letterSpacing: 0.5,
      ),
    ),
    scaffoldBackgroundColor: AppColors.bgLight,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textDark),
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
