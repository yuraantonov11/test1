import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/components/tile.dart';

class Board extends StatefulWidget {
  final TileStateEnum tileStateEnum;
  final Function() onPressed;

  Board({required this.tileStateEnum, required this.onPressed});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<List<Tile>> _board = [
    [Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {}), Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {}), Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {})],
    [Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {}), Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {}), Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {})],
    [Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {}), Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {}), Tile(tileStateEnum: TileStateEnum.empty, onPressed: () {})],
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
          children: row
              .map((tile) => _buildTile(tile))
              .toList(growable: false),
        ))
            .toList(growable: false),
      ),
    );
  }

  Widget _buildTile(Tile tile) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            tile.tap();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(child: Text(tile.tileStateEnum.value)),
        ),
      ),
    );
  }
}

