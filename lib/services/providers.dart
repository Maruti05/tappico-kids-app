// lib/services/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import 'tts_service.dart';

// TTS service provider
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Sound enabled notifier
class SoundNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(ttsServiceProvider).soundEnabled;
  }

  Future<void> toggle() async {
    final newValue = !state;
    await ref.read(ttsServiceProvider).setSoundEnabled(newValue);
    state = newValue;
  }

  Future<void> set(bool value) async {
    await ref.read(ttsServiceProvider).setSoundEnabled(value);
    state = value;
  }
}

final soundProvider = NotifierProvider<SoundNotifier, bool>(SoundNotifier.new);

// Speech rate notifier
class SpeechRateNotifier extends Notifier<double> {
  @override
  double build() {
    return ref.watch(ttsServiceProvider).speechRate;
  }

  Future<void> set(double rate) async {
    await ref.read(ttsServiceProvider).setSpeechRate(rate);
    state = rate;
  }
}

final speechRateProvider = NotifierProvider<SpeechRateNotifier, double>(SpeechRateNotifier.new);

// Currently tapped item (for animation)
class TappedItemNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? item) => state = item;
}
final tappedItemProvider = NotifierProvider<TappedItemNotifier, String?>(TappedItemNotifier.new);

// Auto play state
class AutoPlayNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool val) => state = val;
  void toggle() => state = !state;
}
final autoPlayProvider = NotifierProvider<AutoPlayNotifier, bool>(AutoPlayNotifier.new);

// Eye protector (blue light filter)
class EyeProtectorNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(AppConstants.eyeProtectorKey) ?? false;
  }

  Future<void> toggle() async {
    final newValue = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.eyeProtectorKey, newValue);
    state = newValue;
  }

  Future<void> set(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.eyeProtectorKey, value);
    state = value;
  }
}
final eyeProtectorProvider = NotifierProvider<EyeProtectorNotifier, bool>(EyeProtectorNotifier.new);

// App version from package info
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version}+${info.buildNumber}';
});
