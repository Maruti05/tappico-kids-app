import 'dart:async';
import 'dart:collection';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isFlutterTtsAvailable = false;

  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _soundEnabled = true;
  double _speechRate = AppConstants.defaultVoiceSpeed;

  SharedPreferences? _prefs;

  final Queue<String> _queue = Queue();
  bool _isProcessingQueue = false;

  bool get soundEnabled => _soundEnabled;
  double get speechRate => _speechRate;
  bool get isSpeaking => _isSpeaking;

  // ================= INIT =================
  Future<void> init() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();

    _soundEnabled = _prefs?.getBool(AppConstants.soundEnabledKey) ?? true;
    _speechRate = _prefs?.getDouble(AppConstants.voiceSpeedKey) ??
        AppConstants.defaultVoiceSpeed;

    await _initFlutterTts();

    _isInitialized = true;
  }

  Future<void> _initFlutterTts() async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(1.0);

      _flutterTts.setStartHandler(() => _isSpeaking = true);

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _processQueue();
      });

      _flutterTts.setCancelHandler(() => _isSpeaking = false);

      _isFlutterTtsAvailable = true;
    } catch (_) {
      _isFlutterTtsAvailable = false;
    }
  }

  // ================= FORMAT =================
  String _format(String text) {
    text = text.trim();
    if (text.length == 1 && RegExp(r'[A-Za-z]').hasMatch(text)) {
      return '$text...';
    }
    if (RegExp(r'^\d$').hasMatch(text)) {
      return '$text...';
    }
    return text;
  }

  // ================= QUEUE =================
  Future<void> speak(String text) async {
    if (!_soundEnabled || text.trim().isEmpty) return;
    _queue.add(_format(text));
    if (!_isProcessingQueue) {
      _processQueue();
    }
  }

  Future<void> _processQueue() async {
    if (_isProcessingQueue) return;
    _isProcessingQueue = true;

    while (_queue.isNotEmpty) {
      if (!_soundEnabled) break;
      final text = _queue.removeFirst();

      if (_isFlutterTtsAvailable) {
        await _speakWithFlutter(text);
      }

      await _waitForCompletion();
    }

    _isProcessingQueue = false;
  }

  Future<void> _speakWithFlutter(String text) async {
    try {
      _isSpeaking = true;
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.speak(text);
    } catch (_) {
      _isSpeaking = false;
    }
  }

  Future<void> _waitForCompletion() async {
    final completer = Completer();
    void listener() {
      if (!_isSpeaking && !completer.isCompleted) {
        completer.complete();
      }
    }
    final timer = Timer.periodic(const Duration(milliseconds: 50), (_) => listener());
    await completer.future;
    timer.cancel();
  }

  // ================= SPECIAL MODES =================
  Future<void> speakLetterWithWord(String letter, String word) async {
    await speak('$letter... $word');
  }

  Future<void> speakNumber(int number) async {
    await speak('$number');
  }

  Future<void> speakSequence(List<String> items) async {
    for (final item in items) {
      await speak(item);
    }
  }

  // ================= STOP =================
  Future<void> stop() async {
    _queue.clear();
    _isProcessingQueue = false;
    _isSpeaking = false;
    try {
      await _flutterTts.stop();
    } catch (_) {}
  }

  // ================= SETTINGS =================
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _prefs?.setBool(AppConstants.soundEnabledKey, enabled);
    if (!enabled) await stop();
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _prefs?.setDouble(AppConstants.voiceSpeedKey, rate);
  }

  // ================= DISPOSE =================
  void dispose() {
    _flutterTts.stop();
  }
}
