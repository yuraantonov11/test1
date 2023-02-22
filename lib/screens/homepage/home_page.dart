import 'package:flutter/material.dart';
import '../tictactoe/tictactoe_game.dart';
import '../settings/settings_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: TicTacToeGame(),
    );
  }
}
