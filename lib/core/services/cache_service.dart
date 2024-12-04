class CacheEntry<T> {
  final T data;
  final DateTime timestamp;

  CacheEntry(this.data, this.timestamp);

  bool isValid(Duration duration) {
    return DateTime.now().difference(timestamp) < duration;
  }
}

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final Map<String, CacheEntry<String>> _translationCache = {};

  String? getTranslation(String key) {
    final entry = _translationCache[key];
    if (entry != null && entry.isValid(const Duration(minutes: 60))) {
      return entry.data;
    }
    return null;
  }

  void cacheTranslation(String key, String translation) {
    _translationCache[key] = CacheEntry(translation, DateTime.now());
  }

  void clearCache() {
    _translationCache.clear();
  }

  String generateCacheKey(String text, String targetLanguage) {
    return '$text:$targetLanguage';
  }
}
