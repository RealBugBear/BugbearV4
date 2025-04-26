// lib/services/sound_packs.dart

import 'package:bugbear_app/services/sound_manager.dart';

/// Ihre “Meme”-Sounds
final SoundPack memepack = SoundPack(
  name: 'memepack',
  assets: {
    SoundType.start: 'sounds/letsego.mp3',
    SoundType.pause: 'sounds/daddychill.mp3',
    SoundType.end:   'sounds/greatsuccess.mp3',
  },
);

/// Ihre neuen WAV-Sounds
final SoundPack classicpack = SoundPack(
  name: 'classicpack',
  assets: {
    SoundType.start: 'sounds/start.wav',
    SoundType.tick:  'sounds/clocktick.wav',
    SoundType.pause: 'sounds/pause.wav',
    SoundType.end:   'sounds/ende.wav',
  },
);
