extension Number on num {
  int get row {
    return this ~/ 8;
  }

  int get col {
    return (this % 8).toInt();
  }
}
