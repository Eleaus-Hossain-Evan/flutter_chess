import 'package:flutter/material.dart';
import 'package:flutter_chess/components/piece.dart';
import 'package:flutter_chess/components/square.dart';
import 'package:flutter_chess/values/colors.dart';

import 'components/dead_piece.dart';
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

  //  A list of valid moves for thr currently selected piece
  //  each move is represented as a list of two elements: row amd col..
  List<List<int>> validMoves = [];

  //  List of white killed pieces...
  List<ChessPiece> whitePiecesTaken = [];

  //  List of black killed pieces...
  List<ChessPiece> blackPiecesTaken = [];

  //  A Boolean to  indicate whose turn it is
  bool isWhiteTurn = true;

  //  initial position of the king (keep track of it easier later to see if the king is in check)
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;
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
    newBoard[7][3] = ChessPiece().queen.white();

    // Place kings
    newBoard[0][4] = ChessPiece().king.black();
    newBoard[7][4] = ChessPiece().king.white();

    board = newBoard;
  }

  //  USER SELECTED A PIECE
  void pieceSelected(int row, int col) {
    setState(() {
      //  No piece has been selected yet, this is thw first selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      // if there is a pice already selected, but use can select another piece of their own
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      // if there is a piece selected and user tap on a square that is a valid move,
      //piece move to there
      else if (selectedPiece != null &&
          validMoves.any((e) => e[0] == row && e[1] == col)) {
        movePiece(row, col);
      } else {
        selectedPiece = null;
        selectedRow = -1;
        selectedCol = -1;
      }

      //  if a piece is selected calculate its valid moves
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  //  CALCULATE ROW VALID MOVES
  List<List<int>> calculateRowValidMoves(
    int row,
    int col,
    ChessPiece? piece,
  ) {
    List<List<int>> candidateMoves = [];

    // if the piece is a null then the valid moves will be empty...
    if (piece == null) {
      return [];
    }

    // different direction based on their color
    int direction = piece.isWhite! ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        //  pawn can move forward if the square is not occupied
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        //  pawn can move 2 square forward if they are at their initial position

        if ((row == 1 && !piece.isWhite!) || (row == 6 && piece.isWhite!)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        //  pawn can kill diagonally

        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;
      case ChessPieceType.rook:

        // horizontal and vertical direction..
        var directions = [
          [-1, 0], //going up
          [1, 0], //going down
          [0, -1], //going left
          [0, 1], //going right
        ];

        // Loop through the whole board
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break; // going outside of the board...
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // kill move
              }
              break; // blocked by own piece...
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:

        //  all eight possible L shape the knight can move...
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];

          if (!isInBoard(newRow, newCol)) {
            continue; // going outside of the board...
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // kill move
            }
            continue; // blocked by own piece...
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        // all diagonal moves of bishop

        var directions = [
          [-1, -1], // up left direction
          [-1, 1], // up right direction
          [1, -1], // down left direction
          [1, 1], // down right direction
        ];

        // Loop through the whole board
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break; // going outside of the board...
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // kill move
              }
              break; // blocked by own piece...
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.queen:

        // for queen all eight directions: up, down, left, right and 4 diagonals
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], // up left direction
          [-1, 1], // up right direction
          [1, -1], // down left direction
          [1, 1], // down right direction
        ];

        // Loop through the whole board
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break; // going outside of the board...
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // kill move
              }
              break; // blocked by own piece...
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.king:

        // for king all eight directions: up, down, left, right and 4 diagonals
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], // up left direction
          [-1, 1], // up right direction
          [1, -1], // down left direction
          [1, 1], // down right direction
        ];

        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];

          if (!isInBoard(newRow, newCol)) {
            continue; // going outside of the board...
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); // kill move
            }
            continue; // blocked by own piece...
          }
          candidateMoves.add([newRow, newCol]);
        }

        break;
      default:
    }

    return candidateMoves;
  }

  //  CALCULATE REAL VALID MOVES
  List<List<int>> calculateRealValidMoves(
    int row,
    int col,
    ChessPiece? piece,
    bool checkSimulation,
  ) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRowValidMoves(row, col, piece);

    //  after generating all candidate moves, filter out any that would result in a check

    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        //  this wil simulate the future move to see if it's safe
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }

    return realValidMoves;
  }

  //  MOVE PIECE
  void movePiece(int newRow, int newCol) {
    //if the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
      //  add the capture piece to the appropriate list
      var capturePiece = board[newRow][newCol];
      if (capturePiece!.isWhite!) {
        whitePiecesTaken.add(capturePiece);
      } else {
        blackPiecesTaken.add(capturePiece);
      }
    }

    //  check if the piece being moved is a king
    if (selectedPiece!.type == ChessPieceType.king) {
      //  update the appropriate king position
      if (selectedPiece!.isWhite!) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    //  move the piece and clear the old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //  checking if any kings are under attack
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    // clear the selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    //  check if it's checkmate
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("CHECK MATE"),
          actions: [
            // play again button
            TextButton(
              onPressed: resetGame,
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
    }

    // change turn
    isWhiteTurn = !isWhiteTurn;
  }

  //  IS KING IN CHECK
  bool isKingInCheck(bool isWhiteKing) {
    //   get the position of the king
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    // check if any enemy piece can attack the king
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        //  skip the empty square and piece of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //  check if the king's position is in this piece's valid moves
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }

    return false;
  }

  //  SIMULATED MOVE IS SAFE (DOESN'T PUT YOUR OWN KING UNDEF ATTACK)
  bool simulatedMoveIsSafe(
    ChessPiece piece,
    int startRow,
    int startCol,
    int endRow,
    int endCol,
  ) {
    // save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    // if the piece is the king, save it's current position and update to the new one
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite! ? whiteKingPosition : blackKingPosition;

      //  update the king position
      if (piece.isWhite!) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    // simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    // check if our own king is under attack
    bool kingInCheck = isKingInCheck(piece.isWhite!);

    //restore board to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    //  if the piece is king, restore it original position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite!) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }

    // if king is in check = true, means it's not a safe move. safe move = false..
    return !kingInCheck;
  }

  // IS IT CHECK MATE ?
  bool isCheckMate(bool isWhiteKing) {
    //  if the king is not in check, then it's not checkmate
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }

    // if there is at least one legal move for any of the player's piece, then it's not checkmate
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        // skip empty square and the piece of the other color
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], true);

        //if this piece has any valid move, then it's not checkmate
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }

    //if none of above conditions are met, then there are no legal moves left to make
    // and the king is in check, so it's checkmate

    return true;
  }

  //   RESET GAME
  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();

    checkStatus = false;

    isWhiteTurn = true;

    whitePiecesTaken.clear();
    blackPiecesTaken.clear();

    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // WHITE PIECES TAKEN LIST
          Expanded(
            child: GridView.builder(
              itemCount: whitePiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) =>
                  DeadPiece(piece: whitePiecesTaken[index]),
            ),
          ),

          // CHECK STATUS

          Text(checkStatus ? "CHECK" : ''),

          // CHESS BOARD
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 64,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                int row =
                    index ~/ 8; // this gives us the integer division ie, row
                int col = index % 8; // this gives us the remainder ie, col

                // Check tif this square is selected..
                final isSelected = selectedRow == row && selectedCol == col;

                //  Check if this square is a valid move..
                bool isValidMove = false;
                for (var position in validMoves) {
                  if (position[0] == row && position[1] == col) {
                    isValidMove = true;
                  }
                }

                return Square(
                  isWhite: isWhite(index),
                  piece: board[row][col],
                  isSelected: isSelected,
                  isValidMove: isValidMove,
                  onTap: () => pieceSelected(row, col),
                );
              },
            ),
          ),

          //  BLACK PIECES TAKEN LIST
          Expanded(
            child: GridView.builder(
              itemCount: blackPiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                piece: blackPiecesTaken[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
