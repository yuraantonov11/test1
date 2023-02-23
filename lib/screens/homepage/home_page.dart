import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../sound_manager.dart';
import '../tictactoe/tictactoe_game.dart';
import '../settings/settings_screen.dart';

class HomePage extends StatefulWidget {
  final Function onPlayClickSound;
  final Function onPlayWinSound;
  final Function onPlayLoseSound;
  final SoundManager soundManager; // Add the SoundManager parameter here

  const HomePage({
    Key? key,
    required this.onPlayClickSound,
    required this.onPlayWinSound,
    required this.onPlayLoseSound,
    required this.soundManager, // Update the constructor to accept a SoundManager
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ...

  void _playClickSound() {
    widget.onPlayClickSound(); // Replace this line
    widget.soundManager.playSound('sounds/click.mp3'); // with this line
  }

  void _playWinSound() {
    widget.onPlayWinSound(); // Replace this line
    widget.soundManager.playSound('sounds/win.mp3'); // with this line
  }

  void _playLoseSound() {
    widget.onPlayLoseSound(); // Replace this line
    widget.soundManager.playSound('sounds/lose.mp3'); // with this line
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

// ...
}

