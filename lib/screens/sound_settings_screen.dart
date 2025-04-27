// File: lib/screens/sound_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:bugbear_app/services/sound_manager.dart';
import 'package:bugbear_app/services/sound_packs.dart';
import 'package:bugbear_app/generated/l10n.dart';

class SoundSettingsScreen extends StatelessWidget {
  const SoundSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).soundSettingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(S.of(context).memepack),
            onTap: () {
              SoundManager().setPack(memepack);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.audiotrack),
            title: Text(S.of(context).classicpack),
            onTap: () {
              SoundManager().setPack(classicpack);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
