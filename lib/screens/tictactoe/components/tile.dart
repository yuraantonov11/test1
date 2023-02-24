import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/models/tile_state_enum.dart';

class Tile extends StatefulWidget {
  final TileStateEnum tileStateEnum;
  final Function() onPressed;

  Tile({required this.tileStateEnum, required this.onPressed});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  late TileStateEnum _currentState;

  @override
  void initState() {
    super.initState();
    _currentState = TileStateEnum.empty;
  }

  void tap() {
    if (_currentState == TileStateEnum.empty) {
      setState(() {
        _currentState = widget.tileStateEnum;
      });
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
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
          _currentState.value,
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
