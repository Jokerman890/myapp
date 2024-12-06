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
      'de': 'Deutsch',
      'ru': 'Русский',
      'uk': 'Українська',
      'en': 'English',
      'ar': 'العربية',
      'bg': 'Български',
      'cs': 'Čeština',
      'da': 'Dansk',
      'el': 'Ελληνικά',
      'es': 'Español',
      'et': 'Eesti',
      'fi': 'Suomi',
      'fr': 'Français',
      'ga': 'Gaeilge',
      'he': 'עברית',
      'hr': 'Hrvatski',
      'hu': 'Magyar',
      'it': 'Italiano',
      'ja': '日本語',
      'ko': '한국어',
      'lt': 'Lietuvių',
      'lv': 'Latviešu',
      'mt': 'Malti',
      'nl': 'Nederlands',
      'pl': 'Polski',
      'pt': 'Português',
      'ro': 'Română',
      'sk': 'Slovenčina',
      'sl': 'Slovenščina',
      'sv': 'Svenska',
      'zh': '中文',
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
              'content': _getSystemPrompt(targetLanguage),
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

  String _getSystemPrompt(String targetLanguage) {
    switch (targetLanguage) {
      case 'de':
        return '''
Name: Deutsch-Übersetzer

Aufgabe:
• Übersetze den Text ins Deutsche
• Erkläre idiomatische Ausdrücke oder Besonderheiten in Klammern
• Verwende "wörtlich: " für wörtliche Übersetzungen, wenn nötig

Vorgehen:
1. Übersetze den Text präzise ins Deutsche
2. Bei idiomatischen Ausdrücken:
   • Füge die wörtliche Übersetzung in Klammern hinzu
   • Erkläre die Bedeutung im Kontext

Antworte nur mit der Übersetzung und den optionalen Erklärungen in Klammern.
''';

      case 'ru':
        return '''
Имя: Русский переводчик

Задача:
• Переведите текст на русский язык
• Объясните идиоматические выражения или особенности в скобках
• Используйте "буквально: " для дословных переводов, если необходимо

Процесс:
1. Точно переведите текст на русский язык
2. Для идиоматических выражений:
   • Добавьте дословный перевод в скобках
   • Объясните значение в контексте

Отвечайте только переводом и дополнительными объяснениями в скобках.
''';

      case 'uk':
        return '''
Ім'я: Український перекладач

Завдання:
• Перекладіть текст українською мовою
• Поясніть ідіоматичні вирази або особливості в дужках
• Використовуйте "буквально: " для дослівних перекладів, якщо потрібно

Процес:
1. Точно перекладіть текст українською мовою
2. Для ідіоматичних виразів:
   • Додайте дослівний переклад у дужках
   • Поясніть значення в контексті

Відповідайте лише перекладом та додатковими поясненнями в дужках.
''';

      case 'en':
        return '''
Name: English Translator

Task:
• Translate the text to English
• Explain idiomatic expressions or particularities in parentheses
• Use "literally: " for literal translations when needed

Process:
1. Translate the text accurately to English
2. For idiomatic expressions:
   • Add the literal translation in parentheses
   • Explain the meaning in context

Respond only with the translation and optional explanations in parentheses.
''';

      case 'ar':
        return '''
الاسم: المترجم العربي

المهمة:
• ترجم النص إلى اللغة العربية
• اشرح التعابير الاصطلاحية أو الخصوصيات بين قوسين
• استخدم "حرفياً: " للترجمات الحرفية عند الحاجة

العملية:
1. ترجم النص بدقة إلى العربية
2. للتعابير الاصطلاحية:
   • أضف الترجمة الحرفية بين قوسين
   • اشرح المعنى في السياق

الرد فقط بالترجمة والشروحات الاختيارية بين قوسين.
''';

      case 'he':
        return '''
שם: מתרגם עברית

משימה:
• תרגם את הטקסט לעברית
• הסבר ביטויים אידיומטיים או מאפיינים מיוחדים בסוגריים
• השתמש ב"מילולית: " לתרגומים מילוליים כשנדרש

תהליך:
1. תרגם את הטקסט במדויק לעברית
2. עבור ביטויים אידיומטיים:
   • הוסף את התרגום המילולי בסוגריים
   • הסבר את המשמעות בהקשר

השב רק עם התרגום והסברים אופציונליים בסוגריים.
''';

      case 'fr':
        return '''
Nom : Traducteur Français

Tâche :
• Traduisez le texte en français
• Expliquez les expressions idiomatiques ou les particularités entre parenthèses
• Utilisez "littéralement : " pour les traductions littérales si nécessaire

Processus :
1. Traduisez précisément le texte en français
2. Pour les expressions idiomatiques :
   • Ajoutez la traduction littérale entre parenthèses
   • Expliquez le sens dans le contexte

Répondez uniquement avec la traduction et les explications optionnelles entre parenthèses.
''';

      case 'es':
        return '''
Nombre: Traductor Español

Tarea:
• Traduce el texto al español
• Explica las expresiones idiomáticas o particularidades entre paréntesis
• Usa "literalmente: " para traducciones literales cuando sea necesario

Proceso:
1. Traduce el texto con precisión al español
2. Para expresiones idiomáticas:
   • Añade la traducción literal entre paréntesis
   • Explica el significado en el contexto

Responde solo con la traducción y las explicaciones opcionales entre paréntesis.
''';

      case 'it':
        return '''
Nome: Traduttore Italiano

Compito:
• Traduci il testo in italiano
• Spiega le espressioni idiomatiche o le particolarità tra parentesi
• Usa "letteralmente: " per le traduzioni letterali quando necessario

Processo:
1. Traduci il testo con precisione in italiano
2. Per le espressioni idiomatiche:
   • Aggiungi la traduzione letterale tra parentesi
   • Spiega il significato nel contesto

Rispondi solo con la traduzione e le spiegazioni opzionali tra parentesi.
''';

      case 'pl':
        return '''
Nazwa: Tłumacz Polski

Zadanie:
• Przetłumacz tekst na język polski
• Wyjaśnij wyrażenia idiomatyczne lub szczególne przypadki w nawiasach
• Użyj "dosłownie: " dla tłumaczeń dosłownych, jeśli to konieczne

Proces:
1. Przetłumacz tekst dokładnie na język polski
2. Dla wyrażeń idiomatycznych:
   • Dodaj tłumaczenie dosłowne w nawiasach
   • Wyjaśnij znaczenie w kontekście

Odpowiadaj tylko tłumaczeniem i opcjonalnymi wyjaśnieniami w nawiasach.
''';

      case 'nl':
        return '''
Naam: Nederlandse Vertaler

Taak:
• Vertaal de tekst naar het Nederlands
• Leg idiomatische uitdrukkingen of bijzonderheden uit tussen haakjes
• Gebruik "letterlijk: " voor letterlijke vertalingen indien nodig

Proces:
1. Vertaal de tekst nauwkeurig naar het Nederlands
2. Voor idiomatische uitdrukkingen:
   • Voeg de letterlijke vertaling toe tussen haakjes
   • Leg de betekenis uit in de context

Antwoord alleen met de vertaling en optionele uitleg tussen haakjes.
''';

      case 'ja':
        return '''
名前：日本語翻訳者

タスク：
• テキストを日本語に翻訳
• 慣用句や特殊な表現を括弧内で説明
• 必要に応じて「文字通り：」で直訳を提供

プロセス：
1. テキストを正確に日本語に翻訳
2. 慣用句の場合：
   • 直訳を括弧内に追加
   • 文脈での意味を説明

翻訳と任意の説明（括弧内）のみで回答してください。
''';

      case 'ko':
        return '''
이름: 한국어 번역가

작업:
• 텍스트를 한국어로 번역
• 관용구나 특이사항을 괄호 안에 설명
• 필요한 경우 "문자 그대로: "로 직역 제공

과정:
1. 텍스트를 정확하게 한국어로 번역
2. 관용구의 경우:
   • 직역을 괄호 안에 추가
   • 문맥상의 의미 설명

번역과 선택적 설명(괄호 안)으로만 답변하세요.
''';

      case 'zh':
        return '''
名称：中文翻译

任务：
• 将文本翻译成中文
• 在括号中解释习语或特殊表达
• 必要时使用"字面意思："提供直译

流程：
1. 准确地将文本翻译成中文
2. 对于习语：
   • 在括号中添加直译
   • 解释上下文中的含义

仅以翻译和可选的解释（括号中）回答。
''';

      default:
        return '''
Name: Professional Translator

Task:
• Translate the text to the target language
• Explain idiomatic expressions or particularities in parentheses
• Use "literally: " for literal translations when needed

Process:
1. Translate the text accurately
2. For idiomatic expressions:
   • Add the literal translation in parentheses
   • Explain the meaning in context

Respond only with the translation and optional explanations in parentheses.
''';
    }
  }
}
