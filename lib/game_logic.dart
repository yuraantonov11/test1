import 'package:test1/board.dart';
import 'package:test1/computer.dart';
import 'package:test1/ship.dart';

class GameLogic {
  Board playerBoard = Board();
  Board computerBoard = Board();
  Computer computer = Computer();

  void placeShips(List<Ship> ships) {
    for (Ship ship in ships) {
      bool isVertical = playerBoard.random.nextBool();
      int row, col;
      if (isVertical) {
        row = playerBoard.random.nextInt(10 - ship.length + 1);
        col = playerBoard.random.nextInt(10);
      } else {
        row = playerBoard.random.nextInt(10);
        col = playerBoard.random.nextInt(10 - ship.length + 1);
      }
      bool isValid = playerBoard.isValidPosition(row, col, ship.length, isVertical);
      while (!isValid) {
        isVertical = playerBoard.random.nextBool();
        if (isVertical) {
          row = playerBoard.random.nextInt(10 - ship.length + 1);
          col = playerBoard.random.nextInt(10);
        } else {
          row = playerBoard.random.nextInt(10);
          col = playerBoard.random.nextInt(10 - ship.length + 1);
        }
        isValid = playerBoard.isValidPosition(row, col, ship.length, isVertical);
      }
      ship.setPosition(row, col, isVertical);
      playerBoard.placeShip(ship);
    }
  }

  bool isGameOver() {
    return playerBoard.isAllSunk() || computerBoard.isAllSunk();
  }

  void makePlayerMove(int row, int col) {
    bool isHit = false;
    for (Ship ship in computer.ships) {
      if (ship.isHit(row, col)) {
        computerBoard.grid[row][col] = 'H';
        if (ship.isSunk(computerBoard.grid)) {
          print('You sunk the computer\'s ${ship.name}!');
        } else {
          print('You hit the computer\'s ${ship.name}!');
        }
        isHit = true;
        break;
      }
    }
    if (!isHit) {
      computerBoard.grid[row][col] = 'M';
      print('You missed.');
    }
  }

  void makeComputerMove() {
    computer.makeMove(playerBoard.grid);
  }
}
