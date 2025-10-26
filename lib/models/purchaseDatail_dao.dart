class PurchaseDetailDao {

  int? idPurchase;
  int? idProductDetail;
  int? quantity;
  double? price;

  PurchaseDetailDao(
      {
      this.idPurchase,
      this.idProductDetail,
      this.quantity,
      this.price});

  factory PurchaseDetailDao.fromMap(Map<String, dynamic> mapa) {
    return PurchaseDetailDao(
      idPurchase: mapa['idPurchase'],
      idProductDetail: mapa['idProductDetail'],
      quantity: mapa['quantity'],
      price: mapa['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPurchase': idPurchase,
      'idProductDetail': idProductDetail,
      'quantity': quantity,
      'price': price,
    };
  }
}