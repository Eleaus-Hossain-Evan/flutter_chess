import 'package:flutter/material.dart';
import 'package:flutter_chess/components/piece.dart';
import 'package:flutter_chess/components/square.dart';
import 'package:flutter_chess/helper/extensions.dart';
import 'package:flutter_chess/values/colors.dart';

import 'helper/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // A 2-dimensional list representing the chessboard,
  // with each element being a ChessPiece object
  late List<List<ChessPiece?>> board;

  // The currently selected piece on the board,
  // if no piece is selected, this is null..
  ChessPiece? selectedPiece;

  // the row index of the selected piece
  // Default value -1, meaning no piece is currently selected
  int selectedRow = -1;

  // the col index of the selected piece
  // Default value -1, meaning no piece is currently selected
  int selectedCol = -1;

  @override
  void initState() {
    super.initState();

    _initializeBoard();
  }

  //INITIALIZE BOARD
  void _initializeBoard() {
    // initialize board with null value, that means no chess pieces on the board..

    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    // Place pawns
    for (var i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece().pawn.black();
      newBoard[6][i] = ChessPiece().pawn.white();
    }

    // Place rooks
    newBoard[0][0] = ChessPiece().rook.black();
    newBoard[0][7] = ChessPiece().rook.black();
    newBoard[7][0] = ChessPiece().rook.white();
    newBoard[7][7] = ChessPiece().rook.white();

    //Place knights
    newBoard[0][1] = ChessPiece().knight.black();
    newBoard[0][6] = ChessPiece().knight.black();
    newBoard[7][1] = ChessPiece().knight.white();
    newBoard[7][6] = ChessPiece().knight.white();

    // Place bishops
    newBoard[0][2] = ChessPiece().bishop.black();
    newBoard[0][5] = ChessPiece().bishop.black();
    newBoard[7][2] = ChessPiece().bishop.white();
    newBoard[7][5] = ChessPiece().bishop.white();

    // Place queens
    newBoard[0][3] = ChessPiece().queen.black();
    newBoard[7][4] = ChessPiece().queen.white();

    // Place kings
    newBoard[0][4] = ChessPiece().king.black();
    newBoard[7][3] = ChessPiece().king.white();

    board = newBoard;
  }


  //  USER SELECTED A PIECE
  void pieceSelected(){
    // if no piece is selected, then select the piece
    if(selectedPiece == null){
      selectedPiece = board[selectedRow][selectedCol];
    }
    // if a piece is already selected, then move the piece
    else{
      // if the selected piece is same as the piece to be moved, then deselect the piece
      if(selectedPiece == board[selectedRow][selectedCol]){
        selectedPiece = null;
      }
      // if the selected piece is not same as the piece to be moved, then move the piece
      else{
        // if the move is valid, then move the piece
        if(selectedPiece!.isValidMove(selectedRow, selectedCol)){
          board[selectedRow][selectedCol] = selectedPiece;
          board[selectedPiece!.row][selectedPiece!.col] = null;
          selectedPiece!.row = selectedRow;
          selectedPiece!.col = selectedCol;
        }
        // if the move is not valid, then deselect the piece
        else{
          selectedPiece = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GridView.builder(
        itemCount: 64,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          return Square(
            isWhite: isWhite(index),
            piece: board[index.row][index.col],
            isSelected: ,
          );
        },
      ),
    );
  }
}
