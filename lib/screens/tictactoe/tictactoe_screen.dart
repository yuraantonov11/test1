import 'package:flutter/material.dart';
import 'package:test1/screens/tictactoe/components/board.dart';

class TicTacToeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Board(
              tileStateEnum: TileStateEnum.empty,
              onPressed: () {},
            ),

          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Tic Tac Toe'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
