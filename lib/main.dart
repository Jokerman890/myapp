import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/translation/presentation/screens/translation_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polyglotte Translator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const TranslationScreen(),
    );
  }
}
