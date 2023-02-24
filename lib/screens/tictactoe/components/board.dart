import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/components/tile.dart';

import '../models/tile_state_enum.dart';

class Board extends StatefulWidget {
  final Function() onPressed;

  Board({required this.onPressed});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<Tile>> _board = List.generate(3, (i) => List.generate(3, (j) => Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {})))


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
            .map((i, row) => MapEntry(
            i,
            Row(
                children: row
                    .asMap()
                    .map((j, tile) => MapEntry(i * 3 + j, _buildTile(i, j)))
                    .values
                    .toList())))
            .values
            .toList(),
      ),
    );
  }

  Widget _buildTile(int x, int y) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _board[x][y].tap();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(child: Text(_board[x][y].value)),
        ),
      ),
    );
  }
}
