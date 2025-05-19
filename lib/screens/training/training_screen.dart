// File: lib/screens/training/training_screen.dart
import 'package:flutter/material.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: const Center(
        child: Text('Training Placeholder'),
      ),
    );
  }
}
