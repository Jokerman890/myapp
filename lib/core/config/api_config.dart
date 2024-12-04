import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String mistralApiBaseUrl = 'https://api.mistral.ai/v1';
  
  // API-Key aus .env Datei laden
  static String get mistralApiKey => dotenv.env['MISTRAL_API_KEY'] ?? '';
  
  // Endpunkte
  static const String mistralChatEndpoint = '/chat/completions';
  
  // Prompt Templates
  static String getTranslationPrompt({
    required String text,
    required String targetLanguage,
  }) {
    return '''
    Übersetze den folgenden Text in $targetLanguage. 
    Gib nur die Übersetzung zurück, ohne zusätzliche Erklärungen:
    
    $text
    ''';
  }
}
