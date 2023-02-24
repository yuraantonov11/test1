import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/models/tile_state.dart';

class Tile extends StatefulWidget {
  final TileState tileState;
  final Function() onPressed;

  Tile({required this.tileState, required this.onPressed});

  @override
  TileState createState() => TileState();
}
