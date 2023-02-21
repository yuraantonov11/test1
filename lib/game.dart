import 'dart:math';

import 'package:flutter/material.dart';
import 'board.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  late List<List<int>> _playerShips;
  late List<List<int>> _computerShips;
  late List<List<int>> _playerShots;
  late List<List<int>> _computerShots;

  bool _isPlayerTurn = true;

  @override
  void initState() {
    super.initState();
    _playerShips = _generateRandomShips();
    _computerShips = _generateRandomShips();
    _playerShots = [];
    _computerShots = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Board(
          ships: _playerShips,
          shots: _computerShots,
          onShot: _isPlayerTurn ? _onPlayerShot as dynamic : null,
        ),
        SizedBox(height: 16),
        Board(
          ships: _computerShips,
          shots: _playerShots,
          onShot: !_isPlayerTurn ? _onComputerShot as dynamic : null,
        ),
      ],
    );
  }

  void _showGameOverDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text("Game Over"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  bool _onPlayerShot(List<int> position) {
    if (_computerShips.any((ship) => ship.contains(position))) {
      _computerShips.removeWhere((ship) => ship.contains(position));
      _playerShots.add(position);
      if (_computerShips.isEmpty) {
        _showGameOverDialog(context, "Player Wins!");
      } else {
        setState(() {
          _isPlayerTurn = false;
        });
      }
      return true;
    } else {
      _playerShots.add(position);
      setState(() {
        _isPlayerTurn = false;
      });
      _computerTurn();
      return false;
    }
  }

  void _computerTurn() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _onComputerShot();
        _isPlayerTurn = true;
      });
    });
  }

  List<List<int>> _generateRandomShips() {
    final ships = <List<int>>[];
    final random = Random();
    void _addShip(int length) {
      List<int> ship;
      bool overlapsAnotherShip;
      do {
        ship = [random.nextInt(10), random.nextInt(10)];
        final direction = random.nextInt(
            2); // 0: horizontal, 1: vertical
        for (int i = 1; i < length; i++) {
          if (direction == 0) {
            ship.add(ship.last + 1);
          } else {
            ship.add(ship.last + 10);
          }
        }
        overlapsAnotherShip = ships.any((otherShip) =>
            otherShip.any((position) => ship.contains(position)));
      } while (overlapsAnotherShip);
      ships.add(ship);
    }

    // Add one 5-length ship
    _addShip(5);

    // Add two 4-length ships
    for (int i = 0; i < 2; i++) {
      _addShip(4);
    }

// Add three 3-length ships
    for (int i = 0; i < 3; i++) {
      _addShip(3);
    }

// Add four 2-length ships
    for (int i = 0; i < 4; i++) {
      _addShip(2);
    }

    return ships;
  }

  List<int>? _onComputerShot() {
    final random = Random();
    List<int> position;
    do {
      position = [random.nextInt(10), random.nextInt(10)];
    } while (_playerShots.contains(position));
    if (_playerShips.any((ship) => ship.contains(position))) {
      _playerShips.removeWhere((ship) => ship.contains(position));
      _computerShots.add(position);
      if (_playerShips.isEmpty) {
        _showGameOverDialog(context, "Computer Wins!");
      } else {
        setState(() {
          _isPlayerTurn = true;
        });
      }
      return position;
    } else {
      _computerShots.add(position);
      setState(() {
        _isPlayerTurn = true;
      });
      return null;
    }
  }
}