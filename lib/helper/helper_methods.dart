bool isWhite(int index) {
  int x = index ~/ 8; // this gives us the integer division ie, row
  int y = index % 8; // this gives us the remainder ie, col

  //alternate color for each square
  final isWhite = (x + y) % 2 == 0;
  return isWhite;
}

bool isInBoard(int row, int col) {
  return row >= 0 && row <= 7 && col >= 0 && col <= 7;
}
