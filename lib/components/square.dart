import 'package:flutter/material.dart';

import 'package:flutter_chess/components/piece.dart';

import '../values/colors.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final Function() onTap;
  const Square({
    Key? key,
    required this.isWhite,
    this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if selected , square color is green
    // otherwise, it's color would be black or white..

    Color? squareColor = isSelected
        ? Colors.green
        : isValidMove
            ? Colors.green[300]
            : isWhite
                ? foregroundColor
                : backgroundColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: squareColor,
        ),
        child: piece != null
            ? Image.asset(
                piece!.imagePath!,
                color: piece!.isWhite! ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
