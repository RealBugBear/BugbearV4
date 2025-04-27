// File: test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bugbear_app/main.dart';
import 'package:bugbear_app/providers/locale_provider.dart';

void main() {
  testWidgets('App boots up and shows MaterialApp', (WidgetTester tester) async {
    // 1. Wrap MyApp in the same provider as in main.dart:
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: const MyApp(),
      ),
    );

    // 2. Wait for any streams/futures (like Firebase auth) to settle:
    await tester.pumpAndSettle();

    // 3. Verify that MaterialApp (your root) is present:
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
