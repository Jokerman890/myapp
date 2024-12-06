import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/widgets/animated_background.dart';
import 'package:myapp/core/widgets/futuristic_button.dart';
import 'package:myapp/core/widgets/futuristic_icon_button.dart';
import 'package:myapp/core/widgets/futuristic_input.dart';
import 'package:myapp/core/widgets/glass_container.dart';
import 'package:myapp/core/theme/app_colors.dart';
import '../../providers/translation_provider.dart';

class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key});

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'de';
  final _scrollController = ScrollController();
  bool _isMicActive = false;
  bool _isCameraActive = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _translate() {
    if (_textController.text.trim().isEmpty) return;

    ref.read(translationStateProvider.notifier).translate(
          text: _textController.text,
          targetLanguage: _selectedLanguage,
        );
  }

  @override
  Widget build(BuildContext context) {
    final translation = ref.watch(translationStateProvider);
    final supportedLanguages = ref.watch(supportedLanguagesProvider);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/ppolylogo.jpg',
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      GlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Text zum Übersetzen',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                const Spacer(),
                                FuturisticIconButton(
                                  icon: Icons.mic,
                                  onPressed: () {
                                    setState(() {
                                      _isMicActive = !_isMicActive;
                                      if (_isMicActive) _isCameraActive = false;
                                    });
                                  },
                                  isActive: _isMicActive,
                                  tooltip: 'Spracheingabe',
                                  size: 40,
                                ),
                                const SizedBox(width: 8),
                                FuturisticIconButton(
                                  icon: Icons.camera_alt,
                                  onPressed: () {
                                    setState(() {
                                      _isCameraActive = !_isCameraActive;
                                      if (_isCameraActive) _isMicActive = false;
                                    });
                                  },
                                  isActive: _isCameraActive,
                                  tooltip: 'Kamera-Übersetzung',
                                  size: 40,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FuturisticInput(
                              controller: _textController,
                              maxLines: 4,
                              hintText: 'Geben Sie hier Ihren Text ein...',
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Zielsprache:',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FuturisticLanguageSelector(
                                    selectedLanguage: _selectedLanguage,
                                    languages: supportedLanguages,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => _selectedLanguage = value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FuturisticButton(
                        onPressed: _translate,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.translate,
                              color: AppColors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Übersetzen',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: GlassContainer(
                    child: translation.when(
                      data: (data) {
                        if (data == null) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.translate,
                                  size: 48,
                                  color: AppColors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Ihre Übersetzung erscheint hier',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.translatedText,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.white,
                                  height: 1.5,
                                ),
                              ),
                              if (data.originalText != data.translatedText) ...[
                                const SizedBox(height: 16),
                                Text(
                                  '${_getExplanationInTargetLanguage(_selectedLanguage)}${data.originalText}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.white.withOpacity(0.6),
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.turquoise),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.withOpacity(0.8),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Fehler: $error',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.red.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getExplanationInTargetLanguage(String targetLanguage) {
    switch (targetLanguage) {
      case 'de':
        return 'Wörtlich: ';
      case 'en':
        return 'Literally: ';
      case 'fr':
        return 'Littéralement : ';
      case 'es':
        return 'Literalmente: ';
      case 'it':
        return 'Letteralmente: ';
      case 'pt':
        return 'Literalmente: ';
      case 'nl':
        return 'Letterlijk: ';
      case 'pl':
        return 'Dosłownie: ';
      case 'ru':
        return 'Буквально: ';
      case 'uk':
        return 'Буквально: ';
      case 'ja':
        return '文字通り：';
      case 'ko':
        return '문자 그대로: ';
      case 'zh':
        return '字面意思：';
      default:
        return 'Wörtlich: ';
    }
  }
}
