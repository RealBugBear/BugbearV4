// File: lib/services/sound_manager.dart
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

/// The sound‐assets your packs must provide
enum SoundType { start, tick, pause, end }

/// A simple model for a sound pack
class SoundPack {
  final String name;
  final Map<SoundType, String> assets; // paths relative to assets/

  const SoundPack({
    required this.name,
    required this.assets,
  });
}

/// Singleton to play one-off and looped sounds
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  SoundPack? _currentPack;
  AudioPlayer? _loopPlayer;

  /// Must be called at app start
  Future<void> init({required SoundPack pack}) async {
    setPack(pack);
  }

  /// Switches the active sound pack
  void setPack(SoundPack pack) {
    _currentPack = pack;
  }

  /// Plays a sound exactly once
  Future<void> playOnce(SoundType type) async {
    final path = _currentPack?.assets[type];
    if (path == null) return;
    final player = AudioPlayer();
    await player.play(AssetSource(path));
    await player.dispose();
  }

  /// Starts a looping sound (e.g. ticking)
  Future<void> startLoop(SoundType type) async {
    final path = _currentPack?.assets[type];
    if (path == null) return;
    await stopLoop();
    _loopPlayer = AudioPlayer();
    await _loopPlayer!.setReleaseMode(ReleaseMode.loop);
    await _loopPlayer!.play(AssetSource(path));
  }

  /// Stops the currently looping sound
  Future<void> stopLoop() async {
    if (_loopPlayer != null) {
      await _loopPlayer!.stop();
      await _loopPlayer!.release();
      _loopPlayer = null;
    }
  }
}
