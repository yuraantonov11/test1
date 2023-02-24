import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/models/tile_state.dart';

class Tile extends StatefulWidget {
  final TileState tileState;
  final Function() onPressed;

  const Tile({
    Key? key,
    required this.tileState,
    required this.onPressed,
  }) : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  String get value {
    switch (widget.tileState) {
      case TileState.circle:
        return 'O';
      case TileState.cross:
        return 'X';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
