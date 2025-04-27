import 'package:audioplayers/audioplayers.dart';

/// Definiert alle möglichen Sound-Typen.
enum SoundType {
  start,
  tick,
  pause,
  end,
  // Weitere Typen je nach Bedarf
}

/// Eine Sound-Paket-Konfiguration.
class SoundPack {
  final String name;
  final Map<SoundType, String> assets;

  SoundPack({required this.name, required this.assets});
}

/// Zentraler Dienst zur Verwaltung und Abspielung von Sounds.
class SoundManager {
  // Singleton-Instanz
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  /// Aktuelles Sound-Paket.
  late SoundPack _currentPack;

  /// Player für One-Shot-Sounds.
  final AudioPlayer _oneShotPlayer = AudioPlayer();

  /// Map für Loop-Sounds, die gestoppt werden können.
  final Map<SoundType, AudioPlayer> _loopPlayers = {};

  /// Standard-Sound-Paket.
  final SoundPack defaultPack = SoundPack(
    name: 'default',
    assets: {
      SoundType.start: 'sounds/start.wav',
      SoundType.tick: 'sounds/clocktick.wav',
      SoundType.pause: 'sounds/pause.wav',
      SoundType.end: 'sounds/ende.wav',
    },
  );

  /// Initialisierung: lädt das Standard- oder ein angegebenes Paket.
  Future<void> init({SoundPack? pack}) async {
    _currentPack = pack ?? defaultPack;
    // Preload aller Assets
    for (final path in _currentPack.assets.values) {
      await _oneShotPlayer.setSource(AssetSource(path));
      await _oneShotPlayer.pause();
    }
  }

  /// Spielt einen Sound einmalig ab.
  Future<void> playOnce(SoundType type, {double volume = 1.0}) async {
    final asset = _currentPack.assets[type];
    if (asset == null) return;
    await _oneShotPlayer.stop();
    await _oneShotPlayer.setVolume(volume);
    await _oneShotPlayer.setSource(AssetSource(asset));
    await _oneShotPlayer.resume();
  }

  /// Startet einen Loop-Sound (z. B. für Tick-Töne).
  Future<void> startLoop(SoundType type, {double volume = 1.0}) async {
    if (_loopPlayers.containsKey(type)) return;
    final path = _currentPack.assets[type];
    if (path == null) return;

    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(volume);
    await player.setSource(AssetSource(path));
    await player.resume();

    _loopPlayers[type] = player;
  }

  /// Stoppt einen zuvor gestarteten Loop-Sound.
  Future<void> stopLoop(SoundType type) async {
    final player = _loopPlayers.remove(type);
    if (player != null) {
      await player.stop();
      player.dispose();
    }
  }

  /// Wechselt zu einem anderen Sound-Paket zur Laufzeit.
  void setPack(SoundPack pack) {
    _currentPack = pack;
  }
}
