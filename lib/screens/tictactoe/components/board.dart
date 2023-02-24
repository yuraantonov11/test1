import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/components/tile.dart';

import '../models/tile_state_enum.dart';
class Board extends StatefulWidget {
  final TileStateEnum tileStateEnum;
  final Function() onPressed;

  Board({required this.tileStateEnum, required this.onPressed});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  TileStateEnum currentPlayer = TileStateEnum.circle;

  final List<List<TileStateEnum>> _board = List.generate(
    3,
        (i) => List.generate(
      3,
          (j) => Tile(
        tileStateEnum: widget.tileStateEnum, // зміна
        onPressed: () {},
      ),
    ),
  );


  void _onTilePressed(int x, int y) {
    if (_board[x][y] == TileStateEnum.empty) {
      setState(() {
        _board[x][y] = currentPlayer;
        currentPlayer = currentPlayer == TileStateEnum.circle
            ? TileStateEnum.cross
            : TileStateEnum.circle;
      });
    }
  }

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
            .asMap()
            .map(
              (x, row) => MapEntry(
            x,
            Row(
              children: row
                  .asMap()
                  .map(
                    (y, tileStateEnum) => MapEntry(
                  y,
                  Tile(
                    tileStateEnum: tileStateEnum,
                    onPressed: () => _onTilePressed(x, y),
                  ),
                ),
              )
                  .values
                  .toList(),
            ),
          ),
        )
            .values
            .toList(),
      ),
    );
  }
}

