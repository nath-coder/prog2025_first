class PointsDao { 
  int? idPoints;
  String? type;
  double? ammount;
  String? date;
  String? description;  
  String? userId;

  PointsDao({this.idPoints, this.type, this.ammount, this.date, this.description, this.userId});
  factory PointsDao.fromMap(Map<String, dynamic> mapa) {
    return PointsDao(
      idPoints: mapa['idPoints'],
      type: mapa['type'],
      ammount: mapa['amount'],
      date: mapa['date'],
      description: mapa['description'],
      userId: mapa['userId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'idPoints': idPoints,
      'type': type,
      'ammount': ammount,
      'date': date,
      'description': description,
      'userId': userId,
    };
  }
}