import 'package:prog2025_firtst/models/product_dao.dart';
import 'package:prog2025_firtst/database/purchase_database.dart';
import 'package:sqflite/sqflite.dart';

class ProductDatabase {
  final PurchaseDatabase _purchaseDB = PurchaseDatabase();

  // INSERT - Crear nuevo producto
  Future<int> INSERT(ProductDao product) async {
    var con = await _purchaseDB.database;
    return con!.insert('PRODUCT', product.toMap());
  }

  // UPDATE - Actualizar producto existente
  Future<int> UPDATE(ProductDao product) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'PRODUCT', 
      product.toMap(), 
      where: "idProduct = ?", 
      whereArgs: [product.idProduct]
    );
  }

  // DELETE - Eliminar producto por ID
  Future<int> DELETE(int idProduct) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'PRODUCT', 
      where: "idProduct = ?", 
      whereArgs: [idProduct]
    );
  }

  // SELECT ALL - Obtener todos los productos
  Future<List<ProductDao>> SELECT() async {
    var con = await _purchaseDB.database;
    final res = await con!.query('PRODUCT');
    return res.map((product) => ProductDao.fromMap(product)).toList();
  }

  // SELECT BY ID - Obtener producto por ID
  Future<ProductDao?> SELECT_BY_ID(int idProduct) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      where: "idProduct = ?",
      whereArgs: [idProduct]
    );
    
    if (res.isNotEmpty) {
      return ProductDao.fromMap(res.first);
    }
    return null;
  }

  // SELECT BY CATEGORY - Obtener productos por categoría
  Future<List<ProductDao>> SELECT_BY_CATEGORY(int idCategory) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      where: "idCategory = ?",
      whereArgs: [idCategory]
    );
    return res.map((product) => ProductDao.fromMap(product)).toList();
  }

  // SELECT BY TITLE - Buscar productos por título
  Future<List<ProductDao>> SELECT_BY_TITLE(String titulo) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      where: "titulo LIKE ?",
      whereArgs: ['%$titulo%']
    );
    return res.map((product) => ProductDao.fromMap(product)).toList();
  }

  // SELECT BY PRICE RANGE - Productos por rango de precio
  Future<List<ProductDao>> SELECT_BY_PRICE_RANGE(double minPrice, double maxPrice) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      where: "price BETWEEN ? AND ?",
      whereArgs: [minPrice, maxPrice]
    );
    return res.map((product) => ProductDao.fromMap(product)).toList();
  }

  // SELECT BY RATING - Productos por puntuación mínima
  Future<List<ProductDao>> SELECT_BY_RATING(double minRating) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      where: "puntuation >= ?",
      whereArgs: [minRating],
      orderBy: "puntuation DESC"
    );
    return res.map((product) => ProductDao.fromMap(product)).toList();
  }

  // SELECT MOST EXPENSIVE - Productos más caros
  Future<List<ProductDao>> SELECT_MOST_EXPENSIVE(int limit) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      orderBy: "price DESC",
      limit: limit
    );
    return res.map((product) => ProductDao.fromMap(product)).toList();
  }

  // SELECT BEST RATED - Productos mejor puntuados
  Future<List<ProductDao>> SELECT_BEST_RATED(int limit) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      orderBy: "puntuation DESC",
      limit: limit
    );
    return res.map((product) => ProductDao.fromMap(product)).toList();
  }

  // COUNT - Contar total de productos
  Future<int> COUNT() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT COUNT(*) FROM PRODUCT');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // COUNT BY CATEGORY - Contar productos por categoría
  Future<int> COUNT_BY_CATEGORY(int idCategory) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT COUNT(*) FROM PRODUCT WHERE idCategory = ?',
      [idCategory]
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // GET AVERAGE PRICE - Precio promedio de productos
  Future<double> GET_AVERAGE_PRICE() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT AVG(price) FROM PRODUCT');
    return (res.first.values.first as double?) ?? 0.0;
  }

  // GET AVERAGE RATING - Puntuación promedio de productos
  Future<double> GET_AVERAGE_RATING() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT AVG(puntuation) FROM PRODUCT');
    return (res.first.values.first as double?) ?? 0.0;
  }

  // EXISTS - Verificar si existe un producto con ese título
  Future<bool> EXISTS(String titulo) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PRODUCT',
      where: "titulo = ?",
      whereArgs: [titulo]
    );
    return res.isNotEmpty;
  }
}