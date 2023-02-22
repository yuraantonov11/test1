import 'package:flutter/material.dart';
import 'tictactoe_game.dart';

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TicTacToeGame(),
    );
  }
}
