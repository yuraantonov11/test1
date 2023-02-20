class Ship {
  String name;
  late int length;
  late int row;
  late int col;
  late bool isVertical;

  Ship(this.name, this.length);

  void setPosition(int row, int col, bool isVertical) {
    this.row = row;
    this.col = col;
    this.isVertical = isVertical;
  }

  bool isSunk(List<List<String>> grid) {
    for (int i = 0; i < length; i++) {
      if (isVertical) {
        if (grid[row + i][col] != 'H') {
          return false;
        }
      } else {
        if (grid[row][col + i] != 'H') {
          return false;
        }
      }
    }
    return true;
  }

  bool isHit(int row, int col) {
    if (isVertical) {
      return this.row <= row && row < this.row + length && this.col == col;
    } else {
      return this.row == row && this.col <= col && col < this.col + length;
    }
  }
}
