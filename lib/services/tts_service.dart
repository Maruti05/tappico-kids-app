import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_kitten_tts/flutter_kitten_tts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  KittenTTS? _kittenTts;
  AudioPlayer? _audioPlayer;
  bool _isKittenAvailable = false;

  final FlutterTts _flutterTts = FlutterTts();
  bool _isFlutterTtsAvailable = false;

  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _soundEnabled = true;
  double _speechRate = AppConstants.defaultVoiceSpeed;
  String _voiceName = AppConstants.defaultVoiceName;
  String _engine = AppConstants.defaultTtsEngine;

  SharedPreferences? _prefs;

  final Queue<String> _queue = Queue();
  bool _isProcessingQueue = false;

  bool get soundEnabled => _soundEnabled;
  double get speechRate => _speechRate;
  String get voiceName => _voiceName;
  String get engine => _engine;
  bool get isKittenAvailable => _isKittenAvailable;
  bool get isSpeaking => _isSpeaking;

  List<String> get availableVoices => AppConstants.availableVoices;

  // ================= INIT =================
  Future<void> init() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();

    _soundEnabled = _prefs?.getBool(AppConstants.soundEnabledKey) ?? true;
    _speechRate = _prefs?.getDouble(AppConstants.voiceSpeedKey) ??
        AppConstants.defaultVoiceSpeed;
    _voiceName =
        _prefs?.getString(AppConstants.voiceNameKey) ?? AppConstants.defaultVoiceName;
    _engine =
        _prefs?.getString(AppConstants.ttsEngineKey) ?? AppConstants.defaultTtsEngine;

    await _initKittenTts();

    await _initFlutterTts();

    _isInitialized = true;
  }

  Future<void> _initKittenTts() async {
    try {
      _kittenTts = KittenTTS();
      _audioPlayer = AudioPlayer();

      _audioPlayer!.onPlayerComplete.listen((_) {
        _isSpeaking = false;
        _processQueue();
      });

      await _kittenTts!.initialize();
      _isKittenAvailable = true;
    } catch (_) {
      _isKittenAvailable = false;
      _kittenTts?.dispose();
      _kittenTts = null;
      _audioPlayer?.dispose();
      _audioPlayer = null;
    }
  }

  Future<void> _initFlutterTts() async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(_mapToFlutterRate(_speechRate));
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

  // ================= SPEED MAPPING =================
  double _mapToKittenSpeed(double appSpeed) {
    return 0.5 + ((appSpeed - 0.2) / 0.7) * 1.5;
  }

  double _mapToFlutterRate(double appSpeed) {
    return appSpeed;
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

      if (_engine == AppConstants.ttsEngineKitten && _isKittenAvailable) {
        await _speakWithKitten(text);
      } else if (_isFlutterTtsAvailable) {
        await _speakWithFlutter(text);
      }

      await _waitForCompletion();
    }

    _isProcessingQueue = false;
  }

  static const _trailingSilence = 4800; // ~200ms at 24kHz natural fade-out
  static const _minAudioSamples = 12000; // ~500ms minimum audible clip

  Future<void> _speakWithKitten(String text) async {
    try {
      final audio = await _kittenTts!.generate(
        text,
        voice: _voiceName,
        speed: _mapToKittenSpeed(_speechRate),
      );

      if (audio.isNotEmpty && _audioPlayer != null) {
        _isSpeaking = true;
        final samples = _padWithTrailingSilence(audio);
        final wavBytes = _float32ListToWav(samples, _kittenTts!.sampleRate);
        await _audioPlayer!.stop();
        await _audioPlayer!.play(BytesSource(wavBytes));
      }
    } catch (_) {
      await _speakWithFlutter(text);
    }
  }

  Float32List _padWithTrailingSilence(Float32List samples) {
    final totalLength = samples.length + _trailingSilence;
    final finalLength = totalLength < _minAudioSamples ? _minAudioSamples : totalLength;
    final padded = Float32List(finalLength);
    padded.setAll(0, samples);
    return padded;
  }

  Future<void> _speakWithFlutter(String text) async {
    try {
      _isSpeaking = true;
      await _flutterTts.setSpeechRate(_mapToFlutterRate(_speechRate));
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

  // ================= WAV CONVERTER =================
  Uint8List _float32ListToWav(Float32List samples, int sampleRate) {
    final numSamples = samples.length;
    final dataSize = numSamples * 4;
    final fileSize = 44 + dataSize;
    final buffer = ByteData(fileSize);

    buffer.setUint8(0, 0x52);
    buffer.setUint8(1, 0x49);
    buffer.setUint8(2, 0x46);
    buffer.setUint8(3, 0x46);
    buffer.setUint32(4, fileSize - 8, Endian.little);
    buffer.setUint8(8, 0x57);
    buffer.setUint8(9, 0x41);
    buffer.setUint8(10, 0x56);
    buffer.setUint8(11, 0x45);

    buffer.setUint8(12, 0x66);
    buffer.setUint8(13, 0x6D);
    buffer.setUint8(14, 0x74);
    buffer.setUint8(15, 0x20);
    buffer.setUint32(16, 16, Endian.little);
    buffer.setUint16(20, 3, Endian.little);
    buffer.setUint16(22, 1, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate * 4, Endian.little);
    buffer.setUint16(32, 4, Endian.little);
    buffer.setUint16(34, 32, Endian.little);

    buffer.setUint8(36, 0x64);
    buffer.setUint8(37, 0x61);
    buffer.setUint8(38, 0x74);
    buffer.setUint8(39, 0x61);
    buffer.setUint32(40, dataSize, Endian.little);

    for (int i = 0; i < numSamples; i++) {
      buffer.setFloat32(44 + i * 4, samples[i], Endian.little);
    }

    return buffer.buffer.asUint8List();
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
      await _audioPlayer?.stop();
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

  Future<void> setVoice(String voiceName) async {
    _voiceName = voiceName;
    await _prefs?.setString(AppConstants.voiceNameKey, voiceName);
  }

  Future<void> setEngine(String engine) async {
    _engine = engine;
    await _prefs?.setString(AppConstants.ttsEngineKey, engine);
  }

  // ================= DISPOSE =================
  void dispose() {
    _audioPlayer?.dispose();
    _kittenTts?.dispose();
    _flutterTts.stop();
  }
}
