// test/widget_basic_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bugbear_app/services/local_storage_service.dart';
import 'package:bugbear_app/main.dart';

void main() {
  testWidgets('App starts without errors', (tester) async {
    final localStorage = LocalStorageService();
    await localStorage.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LocalStorageService>.value(value: localStorage),
          // ... evtl. weitere Provider
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
