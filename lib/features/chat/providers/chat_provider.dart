import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../models/message_role.dart';
import '../services/chat_service.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

final chatHistoryProvider = StateNotifierProvider<ChatHistoryNotifier, List<ChatMessage>>((ref) {
  final service = ref.watch(chatServiceProvider);
  return ChatHistoryNotifier(service);
});

class ChatHistoryNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatService _service;
  
  ChatHistoryNotifier(this._service) : super([]);

  Future<void> sendMessage(String content) async {
    try {
      // Füge die Benutzernachricht zur Historie hinzu
      final userMessage = ChatMessage(
        content: content,
        timestamp: DateTime.now(),
        role: MessageRole.user.toString(),
        isUser: true,
      );
      state = [...state, userMessage];

      // Sende die Nachricht und warte auf Antwort
      final response = await _service.sendMessage(content);
      
      // Füge die Antwortnachricht zur Historie hinzu
      state = [...state, response];
      
    } catch (error) {
      // Füge eine Fehlermeldung zur Historie hinzu
      final errorMessage = ChatMessage(
        content: 'Fehler: $error',
        timestamp: DateTime.now(),
        role: MessageRole.system.toString(),
        isUser: false,
      );
      state = [...state, errorMessage];
    }
  }

  void clearHistory() {
    state = [];
  }

  List<ChatMessage> getHistory() {
    return state;
  }

  bool get isEmpty => state.isEmpty;
  
  int get messageCount => state.length;
  
  ChatMessage? get lastMessage => state.isEmpty ? null : state.last;
  
  bool get isProcessing => state.isNotEmpty && 
      state.last.role == MessageRole.user.toString() &&
      state.length % 2 != 0;
}
