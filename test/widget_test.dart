// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:matheasy_sn/main.dart';
import 'package:matheasy_sn/app/di/injector.dart' as di;

void main() {
  // Initialisation des mocks
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Réinitialise le service locator avant chaque test
    await di.sl.reset();
    // Configure les dépendances pour l'environnement de test
    await di.init();
  });

  testWidgets('App starts and displays splash screen', (WidgetTester tester) async {
    // Construit l'application et déclenche un frame.
    await tester.pumpWidget(const MathEasyApp());

    // Attend que les animations du splash screen se terminent
    await tester.pumpAndSettle();

    // Vérifie que le SplashScreen est bien affiché au début.
    // On peut vérifier la présence d'un texte spécifique du splash screen.
    expect(find.text('MathEasy SN'), findsOneWidget);
  });
}
