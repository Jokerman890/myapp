import 'package:dio/dio.dart';
import '../models/translation.dart';
import '../../../core/config/app_config.dart';

class TranslationService {
  final Dio _dio;
  final AppConfig _config;

  TranslationService()
      : _config = AppConfig(),
        _dio = Dio(BaseOptions(
          baseUrl: AppConfig().baseUrl,
          headers: {
            'Authorization': 'Bearer ${AppConfig().apiKey}',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ));

  Future<Translation> translate({
    required String text,
    required String targetLanguage,
  }) async {
    if (text.isEmpty) {
      throw ArgumentError('Text cannot be empty');
    }

    if (text.length > _config.maxTextLength) {
      throw ArgumentError(
          'Text length exceeds maximum of ${_config.maxTextLength} characters');
    }

    final supportedLanguages = {
      'en': 'English',
      'de': 'German',
      'fr': 'French',
      'es': 'Spanish',
      'it': 'Italian',
      'pt': 'Portuguese',
      'nl': 'Dutch',
      'pl': 'Polish',
      'ru': 'Russian',
      'ja': 'Japanese',
      'ko': 'Korean',
      'zh': 'Chinese',
    };

    if (!supportedLanguages.containsKey(targetLanguage.toLowerCase())) {
      throw ArgumentError('Unsupported target language: $targetLanguage');
    }

    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'mistral-tiny',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a professional translator. Translate the following text to ${supportedLanguages[targetLanguage]}. Only respond with the translation, nothing else.',
            },
            {
              'role': 'user',
              'content': text,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 2000,
        },
      );

      if (response.statusCode == 200) {
        final translatedText = response.data['choices'][0]['message']['content'] as String;
        return Translation(
          originalText: text,
          translatedText: translatedText.trim(),
          sourceLanguage: 'auto',
          targetLanguage: targetLanguage.toLowerCase(),
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('Translation failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['error'] ?? 'Unknown error';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.connectionError:
        return Exception('Connection error. Please check your internet connection.');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
