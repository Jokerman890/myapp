class Translation {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final DateTime timestamp;

  Translation({
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      originalText: json['originalText'] as String,
      translatedText: json['translatedText'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() {
    return 'Translation(originalText: $originalText, translatedText: $translatedText, '
        'sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, '
        'timestamp: $timestamp)';
  }
}
