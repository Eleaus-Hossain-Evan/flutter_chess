enum ChessPieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final String imagePath;

  ChessPiece({
    required this.type,
    required this.isWhite,
    required this.imagePath,
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
