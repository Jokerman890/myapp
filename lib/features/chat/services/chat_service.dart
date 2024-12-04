import 'package:dio/dio.dart';
import '../models/chat_message.dart';
import '../models/message_role.dart';
import '../../../core/config/app_config.dart';

class ChatService {
  final Dio _dio;
  final AppConfig _config;

  ChatService()
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

  Future<ChatMessage> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'mistral-tiny',
          'messages': [
            {
              'role': MessageRole.user.toString(),
              'content': message,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 200,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'];
        return ChatMessage(
          content: content,
          timestamp: DateTime.now(),
          role: MessageRole.assistant.toString(),
          isUser: false,
        );
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to send message: $e');
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
