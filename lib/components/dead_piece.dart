import 'package:flutter/material.dart';

import 'package:flutter_chess/components/piece.dart';

class DeadPiece extends StatelessWidget {
  final ChessPiece? piece;
  const DeadPiece({
    Key? key,
    this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      piece!.imagePath!,
      color: piece!.isWhite! ? Colors.grey[400] : Colors.grey[800],
    );
  }
}
