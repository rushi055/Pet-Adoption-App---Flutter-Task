import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_app/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Adopt and favorite a pet, verify persistence', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Find the first pet card
    final petCard = find.byType(Card).first;
    expect(petCard, findsOneWidget);
    await tester.tap(petCard);
    await tester.pumpAndSettle();

    // Tap the favorite icon
    final favIcon = find.byIcon(Icons.favorite_border);
    if (favIcon.evaluate().isNotEmpty) {
      await tester.tap(favIcon);
      await tester.pumpAndSettle();
    }

    // Tap the Adopt Me button
    final adoptButton = find.widgetWithText(ElevatedButton, 'Adopt Me');
    if (adoptButton.evaluate().isNotEmpty) {
      await tester.tap(adoptButton);
      await tester.pumpAndSettle();
    }

    // Check for adopted dialog
    expect(find.textContaining("You've now adopted"), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Go back to Home
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Verify pet is marked as adopted and favorited
    expect(find.text('Already Adopted'), findsWidgets);
    expect(find.byIcon(Icons.favorite), findsWidgets);
  });
}
