import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  bool _soundEnabled = true;
  final AudioCache _audioCache = AudioCache();

  // Add the getter for the soundEnabled property
  bool get soundEnabled => _soundEnabled;


  // Update the playSound method to check if sound is enabled
  Future<void> playSound(String soundPath) async {
    if (_soundEnabled) {
      // await _audioCache(soundPath);
    }
  }

  // Add the toggleSound method
  void toggleSound() {
    _soundEnabled = !soundEnabled;
  }
}

