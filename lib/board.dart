import 'package:flutter/material.dart';
import 'package:test1/ship.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<String>> grid = List.generate(10, (_) => List.filled(10, ' '));
  List<Ship> ships = <Ship>[];
  int selectedShipIndex = 0;

  @override
  void initState() {
    super.initState();
    generateShips();
  }

  void generateShips() {
    ships.add(Ship('Aircraft Carrier', 5));
    ships.add(Ship('Battleship', 4));
    ships.add(Ship('Submarine', 3));
    ships.add(Ship('Destroyer', 3));
    ships.add(Ship('Patrol Boat', 2));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20),
          child: const Text(
            'Хід гравця',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                // ...
              });
            },
            child: Container(
              margin: EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: grid.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int row = (index / 10).floor();
                  int col = index % 10;
                  String cellValue = grid[row][col];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(cellValue),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
