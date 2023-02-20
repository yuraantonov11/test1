import 'dart:math';

import 'package:test1/ship.dart';

class Computer {
  late List<List<String>> grid;
  late List<Ship> ships;
  Random random = Random();

  Computer() {
    grid = List.generate(10, (_) => List.generate(10, (_) => ' '));
    ships = [
      Ship('Carrier', 5),
      Ship('Battleship', 4),
      Ship('Cruiser', 3),
      Ship('Submarine', 3),
      Ship('Destroyer', 2),
    ];
    for (Ship ship in ships) {
      bool isVertical = random.nextBool();
      int row, col;
      if (isVertical) {
        row = random.nextInt(10 - ship.length + 1);
        col = random.nextInt(10);
      } else {
        row = random.nextInt(10);
        col = random.nextInt(10 - ship.length + 1);
      }
      ship.setPosition(row, col, isVertical);
    }
  }

  void makeMove(List<List<String>> playerGrid) {
    int row, col;
    do {
      row = random.nextInt(10);
      col = random.nextInt(10);
    } while (playerGrid[row][col] != ' ');
    bool isHit = false;
    for (Ship ship in ships) {
      if (ship.isHit(row, col)) {
        playerGrid[row][col] = 'H';
        if (ship.isSunk(playerGrid)) {
          print('The computer sunk your ${ship.name}!');
        } else {
          print('The computer hit your ${ship.name}!');
        }
        isHit = true;
        break;
      }
    }
    if (!isHit) {
      playerGrid[row][col] = 'M';
      print('The computer missed.');
    }
  }
}
