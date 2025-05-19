// File: lib/screens/forum/forum_screen.dart
import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forum')),
      body: const Center(
        child: Text('Forum Placeholder'),
      ),
    );
  }
}