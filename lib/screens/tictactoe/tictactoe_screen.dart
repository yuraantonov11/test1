import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:test1/screens/tictactoe/components/board.dart';
import 'package:test1/screens/tictactoe/tictactoe_game.dart';

import 'models/tile_state_enum.dart';

class TicTacToeScreen extends StatelessWidget {
  final BluetoothDevice? server;

  TicTacToeScreen({this.server});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TicTacToeGame(server: server, playLocal: false),
      ),
    );
  }
}
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Tic Tac Toe'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
