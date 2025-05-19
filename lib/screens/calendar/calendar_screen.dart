// File: lib/screens/calendar/calendar_screen.dart
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalender')),
      body: const Center(
        child: Text('Kalender Placeholder'),
      ),
    );
  }
}