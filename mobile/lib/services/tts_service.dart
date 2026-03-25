import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';

/// خدمة تحويل النص إلى كلام باستخدام Google Cloud Text-to-Speech
class TtsService {
  // Singleton
  TtsService._internal();
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  static const String _apiKey = 'AIzaSyDM7Q-NlvIzNPwPsayytmihg3XZ4tHzW9I';
  static const String _apiUrl =
      'https://texttospeech.googleapis.com/v1/text:synthesize';

  final Dio _dio = Dio();
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// نطق النص بصوت عربي
  Future<void> speak(String text) async {
    try {
      final response = await _dio.post(
        '$_apiUrl?key=$_apiKey',
        data: {
          'input': {'text': text},
          'voice': {
            'languageCode': 'ar-XA',
            'name': 'ar-XA-Standard-A',
          },
          'audioConfig': {
            'audioEncoding': 'MP3',
          },
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final String audioContent = response.data['audioContent'];
      final Uint8List audioBytes = base64Decode(audioContent);

      // حفظ الملف بامتداد .mp3 حتى يتعرف عليه المشغل
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3');
      await tempFile.writeAsBytes(audioBytes);

      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(tempFile.path));

      // حذف الملف بعد التشغيل
      _audioPlayer.onPlayerComplete.listen((_) {
        tempFile.delete().catchError((_) => tempFile);
      });
    } catch (e) {
      debugPrintTts('TTS error: $e');
    }
  }

  /// إيقاف الصوت
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (_) {}
  }
}

/// طباعة خطأ فقط في وضع التطوير
void debugPrintTts(String message) {
  assert(() {
    // ignore: avoid_print
    print(message);
    return true;
  }());
}
