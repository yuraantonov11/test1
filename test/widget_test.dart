import 'package:flutter_test/flutter_test.dart';
import 'package:test1/screens/tictactoe/tictactoe_game.dart';
import 'package:test1/screens/tictactoe/models/tile_state_enum.dart';

void main() {
  group('TicTacToeGame', () {
    late TicTacToeGame game;

    setUp(() {
      game = TicTacToeGame(playLocal: true);
    });

    test('Winner is determined correctly', () {
      // Test rows
      game.setBoard([
        [TileStateEnum.cross, TileStateEnum.cross, TileStateEnum.cross],
        [TileStateEnum.empty, TileStateEnum.circle, TileStateEnum.circle],
        [TileStateEnum.empty, TileStateEnum.empty, TileStateEnum.circle],
      ]);
      game._TicTacToeGameState()._checkForWinner();
      expect(game._TicTacToeGameState().winner, TileStateEnum.cross);

      // Test columns
      game.setBoard([
        [TileStateEnum.cross, TileStateEnum.empty, TileStateEnum.circle],
        [TileStateEnum.cross, TileStateEnum.circle, TileStateEnum.circle],
        [TileStateEnum.cross, TileStateEnum.empty, TileStateEnum.empty],
      ]);
      game._TicTacToeGameState()._checkForWinner();
      expect(game._TicTacToeGameState().winner, TileStateEnum.cross);

      // Test diagonal
      game.setBoard([
        [TileStateEnum.cross, TileStateEnum.circle, TileStateEnum.empty],
        [TileStateEnum.empty, TileStateEnum.cross, TileStateEnum.circle],
        [TileStateEnum.circle, TileStateEnum.empty, TileStateEnum.cross],
      ]);
      game._TicTacToeGameState()._checkForWinner();
      expect(game._TicTacToeGameState().winner, TileStateEnum.cross);

      // Test tie
      game.setBoard([
        [TileStateEnum.cross, TileStateEnum.circle, TileStateEnum.cross],
        [TileStateEnum.circle, TileStateEnum.cross, TileStateEnum.circle],
        [TileStateEnum.circle, TileStateEnum.cross, TileStateEnum.circle],
      ]);
      game._TicTacToeGameState()._checkForWinner();
      expect(game._TicTacToeGameState().winner, TileStateEnum.empty);
      expect(game._TicTacToeGameState()._message, 'It\'s a tie!');
    });

    test('Reset game works correctly', () {
      game._TicTacToeGameState().board[1][1] = TileStateEnum.cross;
      game._TicTacToeGameState().currentPlayer = TileStateEnum.circle;
      game._TicTacToeGameState()._totalMoves = 4;
      game._TicTacToeGameState().winner = TileStateEnum.cross;
      game._TicTacToeGameState()._message = 'Player 1 wins!';

      game._TicTacToeGameState()._resetGame();

      expect(game._TicTacToeGameState().board, [
        [TileStateEnum.empty, TileStateEnum.empty, TileStateEnum.empty],
        [TileStateEnum.empty, TileStateEnum.empty, TileStateEnum.empty],
        [TileStateEnum.empty, TileStateEnum.empty, TileStateEnum.empty],
      ]);
      expect(game._TicTacToeGameState().currentPlayer, TileStateEnum.circle);
      expect(game._TicTacToeGameState()._totalMoves, 0);
      expect(game._TicTacToeGameState().winner, TileStateEnum.empty);
      expect(game._TicTacToeGameState()._message, '');
    });
  });
}
