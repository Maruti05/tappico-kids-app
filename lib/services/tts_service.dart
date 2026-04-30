import 'dart:async';
import 'dart:collection';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _soundEnabled = true;

  double _speechRate = 0.4;

  SharedPreferences? _prefs;

  // Queue for smooth playback
  final Queue<String> _queue = Queue();
  bool _isProcessingQueue = false;

  bool get soundEnabled => _soundEnabled;
  double get speechRate => _speechRate;
  bool get isSpeaking => _isSpeaking;

  // ================= INIT =================
  Future<void> init() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();

    _soundEnabled = _prefs?.getBool('sound_enabled') ?? true;
    _speechRate   = _prefs?.getDouble('speech_rate') ?? 0.4;

    await _tts.setLanguage('en-US');

    await _setBestVoice();

    await _tts.setPitch(1.2);
    await _tts.setSpeechRate(_speechRate);
    await _tts.setVolume(1.0);

    // Handlers for state tracking
    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      _processQueue();
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });

    _isInitialized = true;
  }

  // ================= VOICE =================
  Future<void> _setBestVoice() async {
    try {
      final voices = await _tts.getVoices;

      if (voices != null && voices is List) {
        final preferred = voices.firstWhere(
          (v) {
            final name = (v['name'] ?? '').toString().toLowerCase();
            final locale = (v['locale'] ?? '').toString();

            return locale == 'en-US' &&
                (name.contains('neural') ||
                 name.contains('female') ||
                 name.contains('child'));
          },
          orElse: () => voices.first,
        );

        await _tts.setVoice(preferred);
      }
    } catch (_) {
      // silent fallback
    }
  }

  // ================= FORMAT =================
  String _format(String text) {
    text = text.trim();

    if (text.length == 1 && RegExp(r'[A-Za-z]').hasMatch(text)) {
      return "$text...";
    }

    if (RegExp(r'^\d$').hasMatch(text)) {
      return "$text...";
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

      await _tts.setSpeechRate(_speechRate);

      await _tts.speak(text);

      // Wait until speaking finishes
      await _waitForCompletion();
    }

    _isProcessingQueue = false;
  }

  Future<void> _waitForCompletion() async {
    final completer = Completer();

    void listener() {
      if (!_isSpeaking && !completer.isCompleted) {
        completer.complete();
      }
    }

    final timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => listener(),
    );

    await completer.future;
    timer.cancel();
  }

  // ================= SPECIAL MODES =================
  Future<void> speakLetterWithWord(String letter, String word) async {
    await speak("$letter... $word");
  }

  Future<void> speakNumber(int number) async {
    await speak("$number");
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
    await _tts.stop();
  }

  // ================= SETTINGS =================
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;

    await _prefs?.setBool('sound_enabled', enabled);

    if (!enabled) await stop();
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;

    await _tts.setSpeechRate(rate);
    await _prefs?.setDouble('speech_rate', rate);
  }

  // ================= DISPOSE =================
  void dispose() {
    _tts.stop();
  }
}