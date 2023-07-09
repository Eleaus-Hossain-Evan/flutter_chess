enum ChessPieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final ChessPieceType? type;
  final bool? isWhite;
  final String? imagePath;

  ChessPiece({
    this.type,
    this.isWhite,
    this.imagePath,
  });

  ChessPiece copyWith({
    ChessPieceType? type,
    bool? isWhite,
    String? imagePath,
  }) {
    return ChessPiece(
      type: type ?? this.type,
      isWhite: isWhite ?? this.isWhite,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

extension Piece on ChessPiece {
  ChessPiece white() => copyWith(isWhite: true);
  ChessPiece black() => copyWith(isWhite: false);

  ChessPiece get pawn => copyWith(
        type: ChessPieceType.pawn,
        imagePath: "assets/images/white-pawn.png",
      );
  ChessPiece get rook => copyWith(
        type: ChessPieceType.rook,
        imagePath: "assets/images/white-rook.png",
      );
  ChessPiece get knight => copyWith(
        type: ChessPieceType.knight,
        imagePath: "assets/images/white-knight.png",
      );
  ChessPiece get bishop => copyWith(
        type: ChessPieceType.bishop,
        imagePath: "assets/images/white-bishop.png",
      );
  ChessPiece get queen => copyWith(
        type: ChessPieceType.queen,
        imagePath: "assets/images/white-queen.png",
      );
  ChessPiece get king => copyWith(
        type: ChessPieceType.king,
        imagePath: "assets/images/white-king.png",
      );
}
