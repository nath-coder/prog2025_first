class PurchaseDao { 
  int? idPurchase;
  String? state;
  String? userId;
  String? date; 
  double? total;

  PurchaseDao({this.idPurchase, this.state, this.userId, this.date, this.total});

  factory PurchaseDao.fromMap(Map<String, dynamic> mapa) {
    return PurchaseDao(
      idPurchase: mapa['idPurchase'],
      state: mapa['state'],
      userId: mapa['userId'],
      date: mapa['date'],
      total: mapa['total'], 
    ); 
  }

  Map<String, dynamic> toMap() {
    return {
      'idPurchase': idPurchase,
      'state': state,
      'userId': userId,
      'date': date,
      'total': total,
    };
  }
}