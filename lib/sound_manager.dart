import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  late AudioPlayer _audioPlayer;

  SoundManager() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playSound(String soundAsset) async {
    int result = await _audioPlayer.play(soundAsset, isLocal: true);
    if (result != 1) {
      print("Error playing sound");
    }
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
  }
}
