import 'package:prog2025_firtst/models/productDetail_dao.dart';
import 'package:prog2025_firtst/database/purchase_database.dart';
import 'package:sqflite/sqflite.dart';

class ProductDetailDatabase {
  final PurchaseDatabase _purchaseDB = PurchaseDatabase();

  // INSERT - Crear nuevo detalle de producto
  Future<int> INSERT(ProductdetailDao productDetail) async {
    var con = await _purchaseDB.database;
    return con!.insert('PRODUCT_DETAIL', productDetail.toMap());
  }

  // UPDATE - Actualizar detalle de producto existente
  Future<int> UPDATE(ProductdetailDao productDetail, int idProductDetail) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'PRODUCT_DETAIL', 
      productDetail.toMap(), 
      where: "idProductDetail = ?", 
      whereArgs: [idProductDetail]
    );
  }

  // DELETE - Eliminar detalle de producto por ID
  Future<int> DELETE(int idProductDetail) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'PRODUCT_DETAIL', 
      where: "idProductDetail = ?", 
      whereArgs: [idProductDetail]
    );
  }

  // DELETE BY PRODUCT - Eliminar todos los detalles de un producto
  Future<int> DELETE_BY_PRODUCT(int idProduct) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'PRODUCT_DETAIL', 
      where: "idProduct = ?", 
      whereArgs: [idProduct]
    );
  }

  // SELECT ALL - Obtener todos los detalles de productos
  Future<List<ProductdetailDao>> SELECT() async {
    var con = await _purchaseDB.database;
    final res = await con!.query('PRODUCT_DETAIL');
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }

  // SELECT BY ID - Obtener detalle por ID
  Future<ProductdetailDao?> SELECT_BY_ID(int idProductDetail) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "idProductDetail = ?",
      whereArgs: [idProductDetail]
    );
    
    if (res.isNotEmpty) {
      return ProductdetailDao.fromMap(res.first);
    }
    return null;
  }

  // SELECT BY PRODUCT - Obtener todos los detalles de un producto
  Future<List<ProductdetailDao>> SELECT_BY_PRODUCT(int idProduct) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "idProduct = ?",
      whereArgs: [idProduct]
    );
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }
  Future<int> DECREMENT_STOCK(int idProductDetail, int quantity) async {
    var con = await _purchaseDB.database;
    return con!.rawUpdate(
      'UPDATE PRODUCT_DETAIL SET quantity = quantity - ? WHERE idProductDetail = ?',
      [quantity, idProductDetail]
    );
  }
  // SELECT BY COLOR - Obtener detalles por color
  Future<List<ProductdetailDao>> SELECT_BY_COLOR(String color) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "color = ?",
      whereArgs: [color]
    );
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }

  // SELECT BY SIZE - Obtener detalles por talla
  Future<List<ProductdetailDao>> SELECT_BY_SIZE(String size) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "size = ?",
      whereArgs: [size]
    );
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }

  // SELECT BY PRODUCT AND COLOR - Obtener detalles específicos
  Future<List<ProductdetailDao>> SELECT_BY_PRODUCT_AND_COLOR(int idProduct, String color) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "idProduct = ? AND color = ?",
      whereArgs: [idProduct, color]
    );
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }

  // SELECT BY PRODUCT AND SIZE - Obtener detalles por producto y talla
  Future<List<ProductdetailDao>> SELECT_BY_PRODUCT_AND_SIZE(int idProduct, String size) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "idProduct = ? AND size = ?",
      whereArgs: [idProduct, size]
    );
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }

  // SELECT BY STOCK RANGE - Obtener detalles por rango de stock
  Future<List<ProductdetailDao>> SELECT_BY_STOCK_RANGE(int minStock, int maxStock) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "stock BETWEEN ? AND ?",
      whereArgs: [minStock, maxStock]
    );
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }

  // SELECT LOW STOCK - Obtener productos con poco stock
  Future<List<ProductdetailDao>> SELECT_LOW_STOCK(int stockLimit) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "stock <= ?",
      whereArgs: [stockLimit],
      orderBy: "stock ASC"
    );
    return res.map((detail) => ProductdetailDao.fromMap(detail)).toList();
  }

  // UPDATE STOCK - Actualizar solo el stock
  Future<int> UPDATE_STOCK(int idProductDetail, int newStock) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'PRODUCT_DETAIL',
      {'stock': newStock},
      where: "idProductDetail = ?",
      whereArgs: [idProductDetail]
    );
  }

  // GET TOTAL STOCK BY PRODUCT - Stock total de un producto
  Future<int> GET_TOTAL_STOCK_BY_PRODUCT(int idProduct) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT SUM(stock) FROM PRODUCT_DETAIL WHERE idProduct = ?',
      [idProduct]
    );
    return (res.first.values.first as int?) ?? 0;
  }

  // COUNT - Contar total de detalles
  Future<int> COUNT() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT COUNT(*) FROM PRODUCT_DETAIL');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // COUNT BY PRODUCT - Contar variaciones de un producto
  Future<int> COUNT_BY_PRODUCT(int idProduct) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT COUNT(*) FROM PRODUCT_DETAIL WHERE idProduct = ?',
      [idProduct]
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // GET COLORS BY PRODUCT - Obtener colores disponibles de un producto
  Future<List<String>> GET_COLORS_BY_PRODUCT(int idProduct) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT DISTINCT color FROM PRODUCT_DETAIL WHERE idProduct = ?',
      [idProduct]
    );
    return res.map((row) => row['color'] as String).toList();
  }

  // GET SIZES BY PRODUCT - Obtener tallas disponibles de un producto
  Future<List<String>> GET_SIZES_BY_PRODUCT(int idProduct) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT DISTINCT size FROM PRODUCT_DETAIL WHERE idProduct = ?',
      [idProduct]
    );
    return res.map((row) => row['size'] as String).toList();
  }

  // EXISTS - Verificar si existe una combinación específica
  Future<bool> EXISTS(int idProduct, String color, String size) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT_DETAIL',
      where: "idProduct = ? AND color = ? AND size = ?",
      whereArgs: [idProduct, color, size]
    );
    return res.isNotEmpty;
  }

}