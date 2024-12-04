import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('TranslationScreen zeigt alle UI-Elemente', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TranslationScreen(),
        ),
      ),
    );

    // Überprüfe, ob alle wichtigen UI-Elemente vorhanden sind
    expect(find.text('Polyglotte Translator'), findsOneWidget);
    expect(find.text('Text zum Übersetzen'), findsOneWidget);
    expect(find.text('Zielsprache'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Kann Text eingeben und Sprache auswählen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TranslationScreen(),
        ),
      ),
    );

    // Text eingeben
    await tester.enterText(find.byType(TextField), 'Hallo Welt');
    expect(find.text('Hallo Welt'), findsOneWidget);

    // Dropdown öffnen
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Erste Sprache sollte sichtbar sein
    expect(find.text('Englisch'), findsOneWidget);
  });

  testWidgets('Zeigt Ladezustand beim Übersetzen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TranslationScreen(),
        ),
      ),
    );

    // Text eingeben
    await tester.enterText(find.byType(TextField), 'Hallo Welt');

    // Übersetzungs-Button klicken
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Überprüfe, ob der Ladeindikator angezeigt wird
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
