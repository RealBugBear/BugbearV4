// File: test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dummy test: MaterialApp renders a simple widget', (WidgetTester tester) async {
    // Pump a minimal widget tree without Firebase or your app logic
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Hello, Bugbear!')),
        ),
      ),
    );

    // Let the frame settle
    await tester.pumpAndSettle();

    // Verify our dummy text appears
    expect(find.text('Hello, Bugbear!'), findsOneWidget);
  });
}
