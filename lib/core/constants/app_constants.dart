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
  static const String voiceNameKey = 'voice_name';
  static const String eyeProtectorKey = 'eye_protector';
  static const String ttsEngineKey = 'tts_engine';

  // TTS engine options
  static const String ttsEngineKitten = 'kitten';
  static const String ttsEngineDefault = 'default';
  static const String defaultTtsEngine = ttsEngineDefault;

  // TTS
  static const double defaultVoiceSpeed = 0.5;
  static const double slowVoiceSpeed = 0.35;
  static const double fastVoiceSpeed = 0.7;
  static const String defaultVoiceName = 'Bella';

  static const Map<String, String> voiceGenderMap = {
    'Bella': 'female',
    'Jasper': 'male',
    'Luna': 'female',
    'Bruno': 'male',
    'Rosie': 'female',
    'Hugo': 'male',
    'Kiki': 'female',
    'Leo': 'male',
  };

  static const List<String> availableVoices = [
    'Bella', 'Jasper', 'Luna', 'Bruno',
    'Rosie', 'Hugo', 'Kiki', 'Leo',
  ];

  static List<String> get femaleVoices =>
      availableVoices.where((v) => voiceGenderMap[v] == 'female').toList();

  static List<String> get maleVoices =>
      availableVoices.where((v) => voiceGenderMap[v] == 'male').toList();

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
  static const Duration itemPopupDuration = Duration(milliseconds: 3500);
}
