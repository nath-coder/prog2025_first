class CategoryDao{
  int? idCategory;
  String? nameCategory;

  CategoryDao({this.idCategory,this.nameCategory});

  factory CategoryDao.fromMap(Map<String,dynamic> mapa){
    return CategoryDao(
      idCategory: mapa['idCategory'],
      nameCategory: mapa['nameCategory'],
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'idCategory': idCategory,
      'nameCategory': nameCategory,
    };
  }
}