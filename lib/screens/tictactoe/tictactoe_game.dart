import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:test1/screens/tictactoe/components/tile.dart';


import '../../app_localizations.dart';
import '../../sound_manager.dart';
import 'models/tile_state_enum.dart';

class TicTacToeGame extends StatefulWidget {
  final BluetoothDevice? server;
  final bool playLocal;

  TicTacToeGame({this.server, this.playLocal = false});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  BluetoothConnection? connection;
  bool connected = false;
  bool server = false;
  TileStateEnum currentPlayer = TileStateEnum.circle;
  TileStateEnum winner = TileStateEnum.empty;
  List<List<TileStateEnum>> board = List.generate(
      3, (i) => List.filled(3, TileStateEnum.empty));
  String _message = '';
  int _totalMoves = 0;
  late ConfettiController _controller;
  late final SoundManager soundManager;

  _TicTacToeGameState() {
    soundManager = SoundManager();
  }

  @override
  void initState() {
    super.initState();
    _connect();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    try {
      BluetoothConnection _connection = await BluetoothConnection.toAddress(widget.server?.address);
      print('Connected to the device');
      setState(() {
        connection = _connection;
        connected = true;
      });
      connection?.input?.listen(_handleIncomingData).onDone(() {
        print('Disconnected by remote request');
        setState(() {
          connection = null;
          connected = false;
        });
      });
    } catch (ex) {
      print('Cannot connect, exception occurred');
      print(ex);
    }
  }

  void _handleIncomingData(List<int> data) {
    int row = data[0];
    int col = data[1];
    TileStateEnum tile = TileStateEnum.values[data[2]];
    setState(() {
      board[row][col] = tile;
      currentPlayer = TileStateEnum.values[data[3]];
    });
    if (winner == TileStateEnum.empty) {
      _checkForWinner();
    }
  }

  Future<void> _sendData(int row, int col, int tile) async {
    try {
      connection?.output.add(Uint8List.fromList(
          utf8.encode('$row,$col,$tile,${currentPlayer.index}\n')));
      await connection?.output.allSent;
    } catch (ex) {
      print('Cannot send data, exception occurred');
      print(ex);
    }
  }

  void _showWinnerDialog(BuildContext context, TileStateEnum winner) {
    String message = '';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetGame();
                  },
                  child: Text(AppLocalizations.of(context).translate('game_new')))
            ],
          );
        });
  }

  void _showCelebrationScreen() {
    _controller.play();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Congratulations!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You won the game!'),
            SizedBox(height: 16),
            ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _controller.stop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _checkForWinner() {
    // Check rows
    for (int row = 0; row < 3; row++) {
      if (board[row][0] != TileStateEnum.empty &&
          board[row][0] == board[row][1] &&
          board[row][1] == board[row][2]) {
        setState(() {
          winner = board[row][0];
        });
        _showWinnerDialog(context, winner);
        _showCelebrationScreen();
        return;
      }
    }

    // Check columns
    for (int col = 0; col < 3; col++) {
      if (board[0][col] != TileStateEnum.empty &&
          board[0][col] == board[1][col] &&
          board[1][col] == board[2][col]) {
        setState(() {
          winner = board[0][col];
        });
        _showWinnerDialog(context, winner);
        _showCelebrationScreen();
        return;
      }
    }

    // Check diagonals
    if (board[0][0] != TileStateEnum.empty &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      setState(() {
        winner = board[0][0];
      });
      _showWinnerDialog(context, winner);
      _showCelebrationScreen();
      return;
    }
    if (board[0][2] != TileStateEnum.empty &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      setState(() {
        winner = board[0][2];
      });
      _showWinnerDialog(context, winner);
      _showCelebrationScreen();
      return;
    }

    // Check for tie
    if (_totalMoves == 9 && winner == TileStateEnum.empty) {
      setState(() {
        _message = 'It\'s a tie!';
      });
      return;
    }
  }


  void _resetGame() {
    setState(() {
      board = List.generate(3, (i) => List.filled(3, TileStateEnum.empty));
      currentPlayer = TileStateEnum.circle;
      winner = TileStateEnum.empty;
      _message = '';
      _totalMoves = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<TileStateEnum, Icon> tileIcons = {
      TileStateEnum.empty: const Icon(Icons.crop_square, size: 60.0),
      TileStateEnum.cross: const Icon(Icons.clear, size: 60.0),
      TileStateEnum.circle: const Icon(Icons.radio_button_unchecked, size: 60.0),
    };
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              _message,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          Expanded(
              child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    final int row = index ~/ 3;
                    final int col = index % 3;
                    return GestureDetector(
                      onTap: () {
                        if(currentPlayer == TileStateEnum.circle) {
                          soundManager.playSound(
                              'sounds/zapsplat_multimedia_button_click_bright_001_92098.mp3');
                        } else {
                          soundManager.playSound(
                              'sounds/zapsplat_multimedia_button_click_bright_002_92099.mp3');
                        }
                        if (board[row][col] == TileStateEnum.empty && winner == TileStateEnum.empty) {
                          setState(() {
                            board[row][col] = currentPlayer;
                            _sendData(row, col, currentPlayer.index);
                            _checkForWinner(); // Call _checkForWinner without checking its return value
                            if (_totalMoves < 9) {
                              currentPlayer = currentPlayer == TileStateEnum.circle ? TileStateEnum.cross : TileStateEnum.circle;
                            }
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.grey[400]!,
                          ),
                        ),
                        child: Center(
                          child: tileIcons[board[row][col]],
                        ),
                      ),
                    );
                  })),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text(AppLocalizations.of(context).translate('game_new')),
          ),
        ],
      ),
    );
  }


}

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
