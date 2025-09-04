import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

// NOTE: Currently using flutter_tts for basic TTS functionality
// TODO: Add ElevenLabs TTS integration for higher quality voice synthesis
// - Add ElevenLabs API integration
// - Implement voice selection from ElevenLabs voice library
// - Add fallback to flutter_tts when offline or API unavailable
// - Consider caching frequently used phrases with ElevenLabs voices

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _flutterTts.setSharedInstance(true);
      }

      _flutterTts.setStartHandler(() {
        if (kDebugMode) print("TTS Started");
      });

      _flutterTts.setCompletionHandler(() {
        if (kDebugMode) print("TTS Completed");
      });

      _flutterTts.setErrorHandler((message) {
        if (kDebugMode) print("TTS Error: $message");
      });

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) print("TTS Initialization Error: $e");
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (text.trim().isEmpty) return;

    try {
      await stop();
      await _flutterTts.speak(text);
    } catch (e) {
      if (kDebugMode) print("TTS Speak Error: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      if (kDebugMode) print("TTS Stop Error: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      if (kDebugMode) print("TTS Pause Error: $e");
    }
  }

  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      if (kDebugMode) print("TTS Set Speech Rate Error: $e");
    }
  }

  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      if (kDebugMode) print("TTS Set Pitch Error: $e");
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      if (kDebugMode) print("TTS Set Volume Error: $e");
    }
  }

  Future<List<String>> getAvailableLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return List<String>.from(languages);
    } catch (e) {
      if (kDebugMode) print("TTS Get Languages Error: $e");
      return ['en-US'];
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      await _flutterTts.setLanguage(language);
    } catch (e) {
      if (kDebugMode) print("TTS Set Language Error: $e");
    }
  }
}