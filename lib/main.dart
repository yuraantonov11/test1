import 'package:battleship_game/board.dart';
import 'package:battleship_game/game_logic.dart';
import 'package:battleship_game/ship.dart';
import 'package:flutter/material.dart';

void main() {
  List<Ship> ships = [
    Ship(name: 'Aircraft Carrier', length: 5),
    Ship(name: 'Battleship', length: 4),
    Ship(name: 'Submarine', length: 3),
    Ship(name: 'Destroyer', length: 3),
    Ship(name: 'Patrol Boat', length: 2),
  ];

  GameLogic game = GameLogic();
  game.placeShips(ships);

  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final GameLogic game;

  MyApp(this.game);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battleship Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Battleship Game', game: game),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.game}) : super(key: key);
  final String title;
  final GameLogic game;

  @override
  _MyHomePageState createState() => _MyHomePageState(game);
}

class _MyHomePageState extends State<MyHomePage> {
  GameLogic game;
  Board playerBoard;
  Board computerBoard;

  _MyHomePageState(this.game);

  @override
  void initState() {
    super.initState();
    playerBoard = game.playerBoard;
    computerBoard = game.computerBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Your Board',
            style: Theme.of(context).textTheme.headline5,
          ),
          BoardWidget(board: playerBoard, isPlayer: true),
          SizedBox(height: 30),
          Text(
            'Computer Board',
            style: Theme.of(context).textTheme.headline5,
          ),
          BoardWidget(board: computerBoard, isPlayer: false),
        ],
      ),
    );
  }
}

class BoardWidget extends StatefulWidget {
  final Board board;
  final bool isPlayer;

  BoardWidget({this.
