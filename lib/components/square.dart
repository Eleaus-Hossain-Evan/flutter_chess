import 'package:flutter/material.dart';

import 'package:flutter_chess/components/piece.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  const Square({
    Key? key,
    required this.isWhite,
    this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isWhite ? Colors.grey[200] : Colors.grey[500],
      ),
      child: piece != null
          ? Image.asset(
              piece!.imagePath,
              color: piece!.isWhite ? Colors.white : Colors.black,
            )
          : null,
    );
  }
}
