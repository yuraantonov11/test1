import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  late AudioPlayer _audioPlayer;

  SoundManager() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playSound(soundAsset) async {
    await _audioPlayer.play(soundAsset);
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
  }
}
