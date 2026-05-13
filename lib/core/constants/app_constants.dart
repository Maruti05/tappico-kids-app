// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String appName = 'TapPico';
  static const String tagline = 'Tap • Learn • Grow';
  static const String packageName = 'com.vedica.labs.ind.app.tappico';

  // Routes
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String alphabetsRoute = '/alphabets';
  static const String numbersRoute = '/numbers';
  static const String shapesRoute = '/shapes';
  static const String fruitsRoute = '/fruits';
  static const String birdsRoute = '/birds';
  static const String animalsRoute = '/animals';
  static const String domesticAnimalsRoute = '/domestic-animals';
  static const String wildAnimalsRoute = '/wild-animals';
  static const String insectsRoute = '/insects';
  static const String practiceRoute = '/practice';
  static const String settingsRoute = '/settings';
  static const String privacyPolicyRoute = '/privacy-policy';
  static const String colorsRoute = '/colors';
  static const String vehiclesRoute = '/vehicles';
  static const String bodyPartsRoute = '/body-parts';
  static const String vegetablesRoute = '/vegetables';

  // Prefs keys
  static const String soundEnabledKey = 'sound_enabled';
  static const String voiceSpeedKey = 'voice_speed';

  // TTS
  static const double defaultVoiceSpeed = 0.5;
  static const double slowVoiceSpeed = 0.35;
  static const double fastVoiceSpeed = 0.7;

  // Grid
  static const int alphabetCrossAxisCount = 4;
  static const int numberCrossAxisCount = 5;
  static const int shapeCrossAxisCount = 2;
  static const int fruitCrossAxisCount = 1;
  static const int birdCrossAxisCount = 1;
  static const int animalCrossAxisCount = 1;
  static const int itemCrossAxisCount = 1;

  // Animation durations
  static const Duration splashDuration = Duration(milliseconds: 3000);
  static const Duration tapAnimDuration = Duration(milliseconds: 400);
  static const Duration cardAnimDuration = Duration(milliseconds: 600);
}
