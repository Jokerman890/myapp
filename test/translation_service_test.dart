import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/features/translation/services/translation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await dotenv.load(fileName: '.env');
  });

  group('TranslationService', () {
    test('should translate text successfully', () async {
      final service = TranslationService();
      
      final result = await service.translate(
        text: 'Hello',
        targetLanguage: 'de',
      );
      
      expect(result.translatedText, isNotEmpty);
      expect(result.sourceLanguage, isNotNull);
      expect(result.targetLanguage, equals('de'));
    });

    test('should handle empty text', () async {
      final service = TranslationService();
      
      expect(
        () => service.translate(
          text: '',
          targetLanguage: 'de',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should handle invalid target language', () async {
      final service = TranslationService();
      
      expect(
        () => service.translate(
          text: 'Hello',
          targetLanguage: 'invalid',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
