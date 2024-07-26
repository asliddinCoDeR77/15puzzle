import 'package:get_it/get_it.dart';
import 'package:audioplayers/audioplayers.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(() => AudioPlayer());
  locator.registerSingleton(() => PuzzleService());
}

class PuzzleService {
  List<int> puzzlePieces = List.generate(16, (index) => index);

  void shufflePuzzle() {
    puzzlePieces.shuffle();
    while (!_isSolvable() || isSolved()) {
      puzzlePieces.shuffle();
    }
  }

  bool _isSolvable() {
    int inversions = 0;
    for (int i = 0; i < puzzlePieces.length - 1; i++) {
      for (int j = i + 1; j < puzzlePieces.length; j++) {
        if (puzzlePieces[i] > puzzlePieces[j] && puzzlePieces[j] != 0) {
          inversions++;
        }
      }
    }
    return inversions % 2 == 0;
  }

  bool isSolved() {
    for (int i = 0; i < puzzlePieces.length - 1; i++) {
      if (puzzlePieces[i] != i + 1) return false;
    }
    return true;
  }

  void movePiece(int index) {
    int emptyIndex = puzzlePieces.indexOf(0);
    if (_isMovable(index, emptyIndex)) {
      puzzlePieces[emptyIndex] = puzzlePieces[index];
      puzzlePieces[index] = 0;
    }
  }

  bool _isMovable(int index, int emptyIndex) {
    int row = index ~/ 4;
    int col = index % 4;
    int emptyRow = emptyIndex ~/ 4;
    int emptyCol = emptyIndex % 4;

    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  void setSolvedState() {
    puzzlePieces = List.generate(16, (index) => index);
  }
}
