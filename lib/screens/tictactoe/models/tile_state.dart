import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/models/tile.dart';

enum TileStateEnum {
  empty,
  cross,
  circle,
}

class TileState extends State<Tile> {
  TileStateEnum _currentState = TileStateEnum.empty;

  void tap() {
    setState(() {
      _currentState = widget.tileState;
    });
  }

  String get value {
    switch (_currentState) {
      case TileStateEnum.circle:
        return 'O';
      case TileStateEnum.cross:
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