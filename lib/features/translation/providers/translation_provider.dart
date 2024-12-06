import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/translation.dart';
import '../services/translation_service.dart';

final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService();
});

final translationStateProvider =
    StateNotifierProvider<TranslationNotifier, AsyncValue<Translation?>>((ref) {
  final service = ref.watch(translationServiceProvider);
  return TranslationNotifier(service);
});

final primaryLanguagesProvider = Provider<List<String>>((ref) {
  return [
    'de',
    'en',
    'fr',
    'es',
    'it',
    'uk',
  ];
});

final supportedLanguagesProvider = Provider<Map<String, String>>((ref) {
  return {
    'de': 'Deutsch',
    'en': 'Englisch',
    'fr': 'Französisch',
    'es': 'Spanisch',
    'it': 'Italienisch',
    'pt': 'Portugiesisch',
    'nl': 'Niederländisch',
    'pl': 'Polnisch',
    'ru': 'Russisch',
    'uk': 'Ukrainisch',
    'ja': 'Japanisch',
    'ko': 'Koreanisch',
    'zh': 'Chinesisch',
  };
});

class TranslationNotifier extends StateNotifier<AsyncValue<Translation?>> {
  final TranslationService _service;

  TranslationNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> translate({
    required String text,
    required String targetLanguage,
  }) async {
    try {
      state = const AsyncValue.loading();

      final translation = await _service.translate(
        text: text,
        targetLanguage: targetLanguage,
      );

      state = AsyncValue.data(translation);

      // Cache die Übersetzung
      await _cacheTranslation(translation);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _cacheTranslation(Translation translation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${translation.originalText}_${translation.targetLanguage}';
      await prefs.setString(key, translation.toJson().toString());
    } catch (e) {
      // Behandle Cache-Fehler still
      print('Fehler beim Caching der Übersetzung: $e');
    }
  }

  Future<Translation?> getCachedTranslation({
    required String text,
    required String targetLanguage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${text}_$targetLanguage';
      final cached = prefs.getString(key);

      if (cached != null) {
        return Translation.fromJson(
          Map<String, dynamic>.from(cached as Map),
        );
      }
    } catch (e) {
      // Behandle Cache-Abruf-Fehler still
      print('Fehler beim Abrufen der gecachten Übersetzung: $e');
    }
    return null;
  }
}
