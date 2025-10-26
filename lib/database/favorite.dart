import 'package:prog2025_firtst/models/favorite_dao.dart';
import 'package:prog2025_firtst/database/purchase_database.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDatabase {
  final PurchaseDatabase _purchaseDB = PurchaseDatabase();

  // INSERT - Agregar producto a favoritos
  Future<int> INSERT(FavoriteDao favorite) async {
    var con = await _purchaseDB.database;
    return con!.insert('FAVORITE', favorite.toMap());
  }

  // INSERT BY PRODUCT ID - Agregar favorito solo con idProduct
  Future<int> INSERT_BY_PRODUCT_ID(int idProduct, String userId) async {
    var con = await _purchaseDB.database;
    return con!.insert('FAVORITE', {
      'idProduct': idProduct,
      'userId': userId
    });
  }

  // DELETE - Eliminar favorito por ID
  Future<int> DELETE(int idFavorite) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'FAVORITE',
      where: "idFavorite = ? ",
      whereArgs: [idFavorite]
    );
  }

  // DELETE BY PRODUCT - Eliminar favorito por producto
  Future<int> DELETE_BY_PRODUCT(int idProduct,String userId) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'FAVORITE',
      where: "idProduct = ? and userId = ?",
      whereArgs: [idProduct,userId]
    );
  }

   // SELECT FAVORITES BY USER - Obtener filas de FAVORITE de un usuario
  Future<List<FavoriteDao>> SELECT_BY_USER(String userId) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'FAVORITE',
      where: "userId = ?",
      whereArgs: [userId],
      orderBy: "idFavorite DESC"
    );
    return res.map((fav) => FavoriteDao.fromMap(fav)).toList();
  }

  // SELECT FAVORITE PRODUCTS BY USER - Productos favoritos con detalle para un usuario
  Future<List<Map<String, dynamic>>> SELECT_FAVORITE_PRODUCTS_BY_USER(String userId) async {
    var con = await _purchaseDB.database;
    return await con!.rawQuery('''
      SELECT f.*, p.titulo, p.price, p.puntuation, p.image, c.nameCategory
      FROM FAVORITE f
      INNER JOIN PRODUCT p ON f.idProduct = p.idProduct
      INNER JOIN CATEGORY c ON p.idCategory = c.idCategory
      WHERE f.userId = ?
      ORDER BY f.idFavorite DESC
    ''', [userId]);
  }

  // SELECT FAVORITE PRODUCTS BY USER AND CATEGORY
  Future<List<Map<String, dynamic>>> SELECT_FAVORITE_PRODUCTS_BY_USER_AND_CATEGORY(String userId, int idCategory) async {
    var con = await _purchaseDB.database;
    return await con!.rawQuery('''
      SELECT f.*, p.titulo, p.price, p.puntuation, p.image, c.nameCategory
      FROM FAVORITE f
      INNER JOIN PRODUCT p ON f.idProduct = p.idProduct
      INNER JOIN CATEGORY c ON p.idCategory = c.idCategory
      WHERE f.userId = ? AND p.idCategory = ?
      ORDER BY f.idFavorite DESC
    ''', [userId, idCategory]);
  }

  // COUNT BY USER - Contar favoritos de un usuario
  Future<int> COUNT_BY_USER(String userId) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT COUNT(*) FROM FAVORITE WHERE userId = ?', [userId]);
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // IS FAVORITE BY USER - Verificar favorito de producto para un usuario
  Future<bool> IS_FAVORITE_BY_USER(int idProduct, String userId) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'FAVORITE',
      where: "idProduct = ? AND userId = ?",
      whereArgs: [idProduct, userId]
    );
    return res.isNotEmpty;
  }

  // GET TOTAL VALUE FAVORITES BY USER - Suma de precios de favoritos de un usuario
  Future<double> GET_TOTAL_VALUE_FAVORITES_BY_USER(String userId) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('''
      SELECT SUM(p.price) as total
      FROM FAVORITE f
      INNER JOIN PRODUCT p ON f.idProduct = p.idProduct
      WHERE f.userId = ?
    ''', [userId]);
    final val = res.first['total'];
    if (val == null) return 0.0;
    if (val is int) return val.toDouble();
    return val as double;
  }

}