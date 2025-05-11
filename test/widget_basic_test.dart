// test/widget_basic_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bugbear_app/main.dart';  // or widgets/materialapp.dart, depending on where you import RootScreen

void main() {
  testWidgets('RootScreen fallback builder is used', (tester) async {
    // We inject a builder that simply returns a colored Scaffold so we can verify it appears.
    await tester.pumpWidget(
      RootScreen(
        builder: (_, __) => const Scaffold(backgroundColor: Colors.green),
      ),
    );

    // Verify our injected Scaffold shows up.
    expect(find.byType(Scaffold), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, Colors.green);
  });
}
