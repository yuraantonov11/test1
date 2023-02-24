import 'package:flutter_test/flutter_test.dart';
import 'package:test1/main.dart';
import 'package:test1/screens/tictactoe/models/tile_state.dart';
import 'package:test1/screens/tictactoe/tictactoe_game.dart';

void main() {
  group('TicTacToeGame', () {
    late TicTacToeGame game;

    setUp(() {
      game = TicTacToeGame(playLocal: true);
    });

    test('Winner is determined correctly', () {
      // Test rows
      game.board = [
        [TileState.cross, TileState.cross, TileState.cross],
        [TileState.empty, TileState.circle, TileState.circle],
        [TileState.empty, TileState.empty, TileState.circle],
      ];
      game._checkForWinner();
      expect(game.winner, TileState.cross);

      // Test columns
      game.board = [
        [TileState.cross, TileState.empty, TileState.circle],
        [TileState.cross, TileState.circle, TileState.circle],
        [TileState.cross, TileState.empty, TileState.empty],
      ];
      game._checkForWinner();
      expect(game.winner, TileState.cross);

      // Test diagonal
      game.board = [
        [TileState.cross, TileState.circle, TileState.empty],
        [TileState.empty, TileState.cross, TileState.circle],
        [TileState.circle, TileState.empty, TileState.cross],
      ];
      game._checkForWinner();
      expect(game.winner, TileState.cross);

      // Test tie
      game.board = [
        [TileState.cross, TileState.circle, TileState.cross],
        [TileState.circle, TileState.cross, TileState.circle],
        [TileState.circle, TileState.cross, TileState.circle],
      ];
      game._checkForWinner();
      expect(game.winner, TileState.empty);
      expect(game._message, 'It\'s a tie!');
    });

    test('Reset game works correctly', () {
      game.board[1][1] = TileState.cross;
      game.currentPlayer = TileState.circle;
      game._totalMoves = 4;
      game.winner = TileState.cross;
      game._message = 'Player 1 wins!';

      game._resetGame();

      expect(game.board, [
        [TileState.empty, TileState.empty, TileState.empty],
        [TileState.empty, TileState.empty, TileState.empty],
        [TileState.empty, TileState.empty, TileState.empty],
      ]);
      expect(game.currentPlayer, TileState.circle);
      expect(game._totalMoves, 0);
      expect(game.winner, TileState.empty);
      expect(game._message, '');
    });
  });
}
