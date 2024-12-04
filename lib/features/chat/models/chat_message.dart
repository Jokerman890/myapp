class ChatMessage {
  final String content;
  final DateTime timestamp;
  final String role;
  final bool isUser;

  ChatMessage({
    required this.content,
    required this.timestamp,
    required this.role,
    required this.isUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'role': role,
      'isUser': isUser,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      role: json['role'] as String,
      isUser: json['isUser'] as bool,
    );
  }

  ChatMessage copyWith({
    String? content,
    DateTime? timestamp,
    String? role,
    bool? isUser,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      role: role ?? this.role,
      isUser: isUser ?? this.isUser,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(content: $content, timestamp: $timestamp, role: $role, isUser: $isUser)';
  }
}
