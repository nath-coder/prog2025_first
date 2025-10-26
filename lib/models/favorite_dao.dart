class FavoriteDao { 
  int? idFavorite;
  int? idProduct;
  String? userId;

  FavoriteDao({this.idFavorite, this.idProduct, this.userId});

  factory FavoriteDao.fromMap(Map<String, dynamic> mapa) {
    return FavoriteDao(
      idFavorite: mapa['idFavorite'],
      idProduct: mapa['idProduct'],
      userId: mapa['userId'],
    );
  }
 
  Map<String, dynamic> toMap() {
    return {
      'idFavorite': idFavorite,
      'idProduct': idProduct, 
      'userId': userId,
    };
  }
}