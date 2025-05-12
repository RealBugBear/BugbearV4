// File: lib/services/sound_manager.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// The sound‐assets your packs must provide
enum SoundType { start, tick, pause, end }

/// A simple model for a sound pack
class SoundPack {
  final String name;
  final Map<SoundType, String> assets; // paths relative to flutter asset root

  const SoundPack({
    required this.name,
    required this.assets,
  });
}

/// Singleton to play one-off and looped sounds
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  SoundManager._internal() {
    // Default pack (won't be used if you always init with a pack)
    _currentPack = const SoundPack(
      name: 'default',
      assets: {
        SoundType.start: 'sounds/start.mp3',
        SoundType.tick: 'sounds/clocktick.mp3',
        SoundType.pause: 'sounds/pause.mp3',
        SoundType.end: 'sounds/ende.mp3',
      },
    );
  }

  late SoundPack _currentPack;
  AudioPlayer? _loopPlayer;

  /// Must be called at app start with your chosen pack
  Future<void> init({SoundPack? pack}) async {
    if (pack != null) _currentPack = pack;
    debugPrint('🔈 SoundManager initialized with pack: ${_currentPack.name}');
  }

  /// Switches the active sound pack at runtime
  void setPack(SoundPack pack) {
    _currentPack = pack;
    debugPrint('🔈 Sound pack switched to: ${pack.name}');
  }

  /// Plays a sound exactly once. The player will auto-dispose when done.
  Future<void> playOnce(SoundType type) async {
    final assetPath = _resolvePath(type);
    debugPrint('▶️ playOnce $type → asset: $assetPath');
    final player = AudioPlayer();

    // Dispose when playback completes
    player.onPlayerComplete.listen((_) async {
      debugPrint('✔️ $type completed, disposing player');
      await player.dispose();
    });

    try {
      await player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('⚠️ playOnce failed for $type at $assetPath: $e');
      await player.dispose();
    }
  }

  /// Starts a looping sound (e.g. ticking)
  Future<void> startLoop(SoundType type) async {
    final assetPath = _resolvePath(type);
    debugPrint('🔁 startLoop $type → asset: $assetPath');
    await stopLoop();
    _loopPlayer = AudioPlayer();
    await _loopPlayer!.setReleaseMode(ReleaseMode.loop);
    try {
      await _loopPlayer!.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('⚠️ startLoop failed for $type at $assetPath: $e');
    }
  }

  /// Stops the active looped sound
  Future<void> stopLoop() async {
    if (_loopPlayer != null) {
      debugPrint('⏹️ stopLoop');
      try {
        await _loopPlayer!.stop();
        await _loopPlayer!.release();
      } catch (e) {
        debugPrint('⚠️ stopLoop error: $e');
      }
      _loopPlayer = null;
    }
  }

  /// Helper: convert the logical asset path into what AssetSource needs
  String _resolvePath(SoundType type) {
    final raw = _currentPack.assets[type] ?? '';
    // Strip any accidental “assets/” prefix:
    if (raw.startsWith('assets/')) return raw.substring(7);
    return raw;
  }
}
