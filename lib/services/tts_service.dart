// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final _tts = FlutterTts();

  Future<void> init({double rate = 0.5, double pitch = 1.0}) async {
    await _tts.setLanguage('en-GB');
    await _tts.setSpeechRate(rate); // flutter_tts normalizes per platform
    await _tts.setPitch(pitch);
    await _tts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
