import 'package:flutter/material.dart';
import 'package:flutter_chess/components/piece.dart';
import 'package:flutter_chess/components/square.dart';

import 'helper/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //create a piece
  final ChessPiece myPawn = ChessPiece(
    type: ChessPieceType.pawn,
    isWhite: false,
    imagePath: "assets/images/white-pawn.png",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 64,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          return Square(
            isWhite: isWhite(index),
            piece: myPawn,
          );
        },
      ),
    );
  }
}
