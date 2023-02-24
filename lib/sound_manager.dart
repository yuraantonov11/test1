import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  bool _soundEnabled = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  // Add the getter for the soundEnabled property
  bool get soundEnabled => _soundEnabled;


  // Update the playSound method to check if sound is enabled
  Future<void> playSound(String soundPath) async {
    if (_soundEnabled) {
      await _audioPlayer.play(AssetSource(soundPath));
    }
  }

  // Add the toggleSound method
  void toggleSound() {
    _soundEnabled = !soundEnabled;
  }
}

