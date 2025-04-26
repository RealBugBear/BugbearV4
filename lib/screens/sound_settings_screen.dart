import 'package:flutter/material.dart';
import 'package:bugbear_app/services/sound_manager.dart';
import 'package:bugbear_app/services/sound_packs.dart';

class SoundSettingsScreen extends StatelessWidget {
  const SoundSettingsScreen({super.key});
  @override
  Widget build(BuildContext ctx) => Scaffold(
    appBar: AppBar(title: const Text('Sound-Pakete')),
    body: ListView(children: [
      ListTile(
        leading: const Icon(Icons.music_note),
        title: const Text('Memepack'),
        onTap: () {
          SoundManager().setPack(memepack);
          Navigator.of(ctx).pop();
        },
      ),
      ListTile(
        leading: const Icon(Icons.audiotrack),
        title: const Text('Classicpack'),
        onTap: () {
          SoundManager().setPack(classicpack);
          Navigator.of(ctx).pop();
        },
      ),
    ]),
  );
}
