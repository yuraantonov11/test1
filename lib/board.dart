import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  final List<List<int>> ships;
  final List<List<int>> shots;
  final Function(List<int>) onShot;

  Board({required this.ships, required this.shots, required this.onShot});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        final x = index % 10;
        final y = index ~/ 10;
        final hasShip = widget.ships.any((ship) => ship.contains(index));
        final hasShot = widget.shots.contains([x, y]);

        return GestureDetector(
          onTap: () {
            if (!hasShot) {
              widget.onShot([x, y]);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: hasShot ? Colors.blue : null,
            ),
            child: Center(
              child: hasShip ? Icon(Icons.brightness_1) : null,
            ),
          ),
        );
      },
    );
  }
}
