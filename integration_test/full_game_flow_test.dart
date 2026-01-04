import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mafia_game/main_host.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full Game Flow: Lobby -> Setup -> Game', (WidgetTester tester) async {
    // 1. Launch the app
    await tester.pumpWidget(
      const ProviderScope(
        child: MafiaHostApp(),
      ),
    );

    // 2. Verify we are at the Lobby Screen
    await tester.pumpAndSettle();
    expect(find.text('MAFIA GAME'), findsOneWidget);
    
    // Find Setup button
    final setupButtonFinder = find.widgetWithText(ElevatedButton, 'SETUP GAME');
    expect(setupButtonFinder, findsOneWidget);

    // Ensure the button is in view before tapping. 
    // We specify the scrollable to avoid "Too many elements" error.
    await tester.scrollUntilVisible(
        setupButtonFinder, 
        200, 
        scrollable: find.byType(Scrollable).first
    );
    await tester.pumpAndSettle();

    // 3. Navigate to Setup Screen
    await tester.tap(setupButtonFinder);
    await tester.pumpAndSettle();

    // 4. Verify we are on the Setup Screen
    expect(find.text('GAME SETUP'), findsOneWidget);
    expect(find.text('DISTRIBUTE ROLES'), findsOneWidget);

    // Navigation to Setup Screen successful!
  });
}
