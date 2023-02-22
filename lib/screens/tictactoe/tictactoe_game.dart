import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:test1/screens/tictactoe/models/tile_state.dart';

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
  TileState currentPlayer = TileState.circle;
  TileState winner = TileState.empty;
  List<List<TileState>> board = List.generate(
      3, (i) => List.filled(3, TileState.empty));
  String _message = '';
  int _totalMoves = 0;

  @override
  void initState() {
    super.initState();
    _connect();
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
    TileState tile = TileState.values[data[2]];
    setState(() {
      board[row][col] = tile;
      currentPlayer = TileState.values[data[3]];
    });
    if (winner == TileState.empty) {
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

  void _showWinnerDialog(TileState winner) {
    String message = '';
    switch (winner) {
      case TileState.circle:
        message = 'Circle wins!';
        break;
      case TileState.cross:
        message = 'Cross wins!';
        break;
      default:
        break;
    }
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
                  child: const Text('New Game'))
            ],
          );
        });
  }

  void _checkForWinner() {
    // Check rows
    for (int row = 0; row < 3; row++) {
      if (board[row][0] != TileState.empty &&
          board[row][0] == board[row][1] &&
          board[row][1] == board[row][2]) {
        setState(() {
          winner = board[row][0];
        });
        _showWinnerDialog(winner);
        return;
      }
    }

    // Check columns
    for (int col = 0; col < 3; col++) {
      if (board[0][col] != TileState.empty &&
          board[0][col] == board[1][col] &&
          board[1][col] == board[2][col]) {
        setState(() {
          winner = board[0][col];
        });
        _showWinnerDialog(winner);
        return;
      }
    }

    // Check diagonals
    if (board[0][0] != TileState.empty &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      setState(() {
        winner = board[0][0];
      });
      _showWinnerDialog(winner);
      return;
    }
    if (board[0][2] != TileState.empty &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      setState(() {
        winner = board[0][2];
      });
      _showWinnerDialog(winner);
      return;
    }

    // Check for tie
    if (_totalMoves == 9 && winner == TileState.empty) {
      setState(() {
        _message = 'It\'s a tie!';
      });
      return;
    }
  }


  void _resetGame() {
    setState(() {
      board = List.generate(3, (i) => List.filled(3, TileState.empty));
      currentPlayer = TileState.circle;
      winner = TileState.empty;
      _message = '';
      _totalMoves = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<TileState, Icon> tileIcons = {
      TileState.empty: const Icon(Icons.crop_square, size: 60.0),
      TileState.cross: const Icon(Icons.clear, size: 60.0),
      TileState.circle: const Icon(Icons.radio_button_unchecked, size: 60.0),
    };
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              '$_message',
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
                        if (board[row][col] == TileState.empty && winner == TileState.empty) {
                          setState(() {
                            board[row][col] = currentPlayer;
                            _sendData(row, col, currentPlayer.index);
                            _checkForWinner(); // Call _checkForWinner without checking its return value
                            if (_totalMoves < 9) {
                              currentPlayer = currentPlayer == TileState.circle ? TileState.cross : TileState.circle;
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
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }


}


