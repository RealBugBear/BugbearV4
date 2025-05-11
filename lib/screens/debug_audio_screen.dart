// File: lib/screens/debug_audio_screen.dart

import 'package:flutter/material.dart';
import 'package:bugbear_app/services/sound_manager.dart';

class DebugAudioScreen extends StatelessWidget {
  const DebugAudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔊 Audio Debug')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: SoundType.values.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              child: Text('▶️ Play ${type.name}'),
              onPressed: () => SoundManager().playOnce(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}
