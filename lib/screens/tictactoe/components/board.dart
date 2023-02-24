import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/models/tile.dart';
import 'package:test1/screens/tictactoe/models/tile_state.dart';

class Board extends StatefulWidget {
  final TileState tileState;
  final Function() onPressed;

  Board({required this.tileState, required this.onPressed});
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<List<Tile>> _board = [
    [Tile(tileState: TileState.empty, onPressed: () {}), Tile(tileState: TileState.empty, onPressed: () {}), Tile(tileState: TileState.empty, onPressed: () {})],
    [Tile(tileState: TileState.empty, onPressed: () {}), Tile(tileState: TileState.empty, onPressed: () {}), Tile(tileState: TileState.empty, onPressed: () {})],
    [Tile(tileState: TileState.empty, onPressed: () {}), Tile(tileState: TileState.empty, onPressed: () {}), Tile(tileState: TileState.empty, onPressed: () {})],
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: _board
            .map((row) => Row(
          children: row.map((tile) => _buildTile(tile)).toList(),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildTile(Tile tile) {
    String value = '';
    switch (tile.tileState) {
      case TileState.circle:
        value = 'O';
        break;
      case TileState.cross:
        value = 'X';
        break;
      default:
        value = '';
        break;
    }
    return Expanded(
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(child: Text(value)),
        ),
      ),
    );
  }
}

