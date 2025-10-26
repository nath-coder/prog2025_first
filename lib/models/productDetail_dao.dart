class ProductdetailDao {
  int? idProductDetail;
  int? idProduct;
  String? size;
  String? color;
  int? quantity;
  String? imageDetail;

  ProductdetailDao({
    this.idProductDetail,
      this.idProduct,
      this.size,
      this.color,
      this.quantity,
      this.imageDetail});
  factory ProductdetailDao.fromMap(Map<String, dynamic> mapa) {
    return ProductdetailDao(
      idProductDetail: mapa['idProductDetail'],
      idProduct: mapa['idProduct'],
      size: mapa['size'],
      color: mapa['color'],
      quantity: mapa['quantity'],
      imageDetail: mapa['imageDetail'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'idProductDetail': idProductDetail,
      'idProduct': idProduct,
      'size': size,
      'color': color,
      'quantity': quantity,
      'imageDetail': imageDetail,
    };
  }

}