import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bugbear_app/main.dart';  // Import mit RootScreen

void main() {
  testWidgets(
    'RootScreen fallback builder is used',
    (tester) async {
      // Wir injizieren einen Builder, der einfach ein grünes Scaffold rendert,
      // um zu prüfen, dass es korrekt angezeigt wird.
      await tester.pumpWidget(
        RootScreen(
          builder: (_, __) => const Scaffold(backgroundColor: Colors.green),
        ),
      );

      // Verifizieren, dass unser Scaffold auftaucht und die richtige Farbe hat.
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.green);
    },
    skip: true, // ← Test vorübergehend überspringen
  );
}
