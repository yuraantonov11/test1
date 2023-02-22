import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


void main() {
  runApp(MyApp());
  getDevices();
}

// Get the list of available Bluetooth devices
List<BluetoothDevice> devices = [];
Future<void> getDevices() async {
  try {
    devices = await FlutterBluetoothSerial.instance.getBondedDevices();
  } catch (ex) {
    print('Cannot get bonded devices, exception occurred');
    print(ex);
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: devices.isNotEmpty ? TicTacToeGame(server: devices.first) : TicTacToeGame(),

    );
  }
}


enum TileState {
  empty,
  cross,
  circle,
}



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
      BluetoothConnection _connection = await BluetoothConnection.toAddress(
          widget.server?.address);
      print('Connected to the device');

      setState(() {
        connection = _connection;
        connected = true;
        server = false;
      });

      connection?.input?.listen(_handleIncomingData).onDone(() {
        print('Disconnected by remote request');
        setState(() {
          connection = null;
          connected = false;
          server = false;
        });
      });
    } catch (ex) {
      print('Cannot connect, exception occured');
      print(ex);
    }
  }

  void _handleIncomingData(List<int> data) {
    String incoming = String.fromCharCodes(data).trim();
    List<String> parts = incoming.split(',');

    int row = int.parse(parts[0]);
    int col = int.parse(parts[1]);

    setState(() {
      board[row][col] = TileState.values[int.parse(parts[2])];
      currentPlayer = TileState.values[int.parse(parts[3])];
    });

    if (winner != TileState.empty) {
      setState(() {
        _message = '${winner.toString().split('.').last} won!';
      });
      return;
    }
  }

  Future<void> _sendData(int row, int col, int tile) async {
    try {
      connection?.output.add(Uint8List.fromList(utf8.encode('$row,$col,$tile,${currentPlayer.index}\n')));
      await connection?.output.allSent;
    } catch (ex) {
      print('Cannot send data, exception occurred');
      print(ex);
    }
  }

  void _checkForWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] &&
          board[i][0] != TileState.empty) {
        setState(() {
          winner = board[i][0];
        });
        _showWinnerDialog(winner);
        return;
      }
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] &&
          board[0][i] != TileState.empty) {
        setState(() {
          winner = board[0][i];
        });
        _showWinnerDialog(winner);
        return;
      }
    }

    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] &&
        board[0][0] != TileState.empty) {
      setState(() {
        winner = currentPlayer;
      });
      _showWinnerDialog(winner);
      return;
    }

    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] &&
        board[0][2] != TileState.empty) {
      setState(() {
        winner = currentPlayer;
      });
      _showWinnerDialog(winner);
      return;
    }

    if (_totalMoves == 9) {
      setState(() {
        _message = 'It\'s a tie!';
      });
      return;
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
      appBar: AppBar(
        title: const Text('Хрестики Нулики'),
      ),
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

