import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  String get apiKey {
    final key = dotenv.env['MISTRAL_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('API key not found in environment variables');
    }
    return key;
  }

  String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'https://api.mistral.ai/v1';
  }

  int get maxTextLength {
    return int.tryParse(dotenv.env['MAX_TEXT_LENGTH'] ?? '5000') ?? 5000;
  }

  Duration get cacheDuration {
    final minutes = int.tryParse(dotenv.env['CACHE_DURATION_MINUTES'] ?? '60') ?? 60;
    return Duration(minutes: minutes);
  }

  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
}
