class ProductDao{
  int? idProduct;
  String? titulo;
  int? idCategory;
  double? puntuation;
  double? price;
  String? image;

  ProductDao({this.idProduct,this.titulo,this.idCategory,this.puntuation,this.price,this.image});

  factory ProductDao.fromMap(Map<String,dynamic> mapa){
    return ProductDao(
      idProduct: mapa['idProduct'],
      titulo: mapa['titulo'],
      idCategory: mapa['idCategory'],
      puntuation: mapa['puntuation'],
      image: mapa['image'],
      price: mapa['price'],
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'idProduct': idProduct,
      'titulo': titulo,
      'idCategory': idCategory,
      'puntuation': puntuation,
      'image': image,
      'price': price,
    };
  }
}