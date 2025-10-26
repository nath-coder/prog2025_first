import 'package:prog2025_firtst/database/purchase_database.dart';
import 'package:sqflite/sqflite.dart';

class PurchaseDetailDatabase {
  final PurchaseDatabase _purchaseDB = PurchaseDatabase();

  // INSERT - Crear nuevo detalle de compra
  Future<int> INSERT(int idPurchase, int idProductDetail, int quantity, double price) async {
    var con = await _purchaseDB.database;
    return con!.insert('PURCHASE_DETAIL', {
      'idPurchase': idPurchase,
      'idProductDetail': idProductDetail,
      'quantity': quantity,
      'price': price,
    });
  }

  // UPDATE - Actualizar detalle de compra existente
  Future<int> UPDATE(int idPurchase, int idProductDetail, int quantity, double price) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'PURCHASE_DETAIL',
      {
        'quantity': quantity,
        'price': price,
      },
      where: "idPurchase = ? AND idProductDetail = ?",
      whereArgs: [idPurchase, idProductDetail]
    );
  }

  // DELETE - Eliminar detalle específico
  Future<int> DELETE(int idPurchase, int idProductDetail) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'PURCHASE_DETAIL',
      where: "idPurchase = ? AND idProductDetail = ?",
      whereArgs: [idPurchase, idProductDetail]
    );
  }

  // DELETE BY PURCHASE - Eliminar todos los detalles de una compra
  Future<int> DELETE_BY_PURCHASE(int idPurchase) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'PURCHASE_DETAIL',
      where: "idPurchase = ?",
      whereArgs: [idPurchase]
    );
  }

  // DELETE BY PRODUCT DETAIL - Eliminar todas las compras de un producto específico
  Future<int> DELETE_BY_PRODUCT_DETAIL(int idProductDetail) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'PURCHASE_DETAIL',
      where: "idProductDetail = ?",
      whereArgs: [idProductDetail]
    );
  }

  // SELECT ALL - Obtener todos los detalles de compra
  Future<List<Map<String, dynamic>>> SELECT() async {
    var con = await _purchaseDB.database;
    return await con!.query('PURCHASE_DETAIL');
  }

  // SELECT BY PURCHASE - Obtener todos los detalles de una compra
  Future<List<Map<String, dynamic>>> SELECT_BY_PURCHASE(int idPurchase) async {
    var con = await _purchaseDB.database;
    return await con!.query(
      'PURCHASE_DETAIL',
      where: "idPurchase = ?",
      whereArgs: [idPurchase]
    );
  }

  // SELECT BY PRODUCT DETAIL - Obtener todas las compras de un producto
  Future<List<Map<String, dynamic>>> SELECT_BY_PRODUCT_DETAIL(int idProductDetail) async {
    var con = await _purchaseDB.database;
    return await con!.query(
      'PURCHASE_DETAIL',
      where: "idProductDetail = ?",
      whereArgs: [idProductDetail]
    );
  }

  // SELECT WITH PRODUCT INFO - Obtener detalles con información del producto
  Future<List<Map<String, dynamic>>> SELECT_WITH_PRODUCT_INFO(int idPurchase) async {
    var con = await _purchaseDB.database;
    return await con!.rawQuery('''
      SELECT pd.*, pr.titulo, pr.image, det.color, det.size,pr.idCategory,det.quantity AS stock
      FROM PURCHASE_DETAIL pd
      INNER JOIN PRODUCT_DETAIL det ON pd.idProductDetail = det.idProductDetail
      INNER JOIN PRODUCT pr ON det.idProduct = pr.idProduct
      WHERE pd.idPurchase = ?
    ''', [idPurchase]);
  }

  // SELECT PURCHASE SUMMARY - Resumen de una compra
  Future<Map<String, dynamic>?> SELECT_PURCHASE_SUMMARY(int idPurchase) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('''
      SELECT 
        COUNT(*) as totalItems,
        SUM(quantity) as totalQuantity,
        SUM(quantity * price) as totalAmount
      FROM PURCHASE_DETAIL 
      WHERE idPurchase = ?
    ''', [idPurchase]);
    
    return res.isNotEmpty ? res.first : null;
  }

  // SELECT TOP PRODUCTS - Productos más vendidos
  Future<List<Map<String, dynamic>>> SELECT_TOP_PRODUCTS(int limit) async {
    var con = await _purchaseDB.database;
    return await con!.rawQuery('''
      SELECT 
        det.idProduct,
        pr.titulo,
        SUM(pd.quantity) as totalSold,
        SUM(pd.quantity * pd.price) as totalRevenue
      FROM PURCHASE_DETAIL pd
      INNER JOIN PRODUCT_DETAIL det ON pd.idProductDetail = det.idProductDetail
      INNER JOIN PRODUCT pr ON det.idProduct = pr.idProduct
      GROUP BY det.idProduct, pr.titulo
      ORDER BY totalSold DESC
      LIMIT ?
    ''', [limit]);
  }

  // UPDATE QUANTITY - Actualizar solo la cantidad
  Future<int> UPDATE_QUANTITY(int idPurchase, int idProductDetail, int newQuantity) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'PURCHASE_DETAIL',
      {'quantity': newQuantity},
      where: "idPurchase = ? AND idProductDetail = ?",
      whereArgs: [idPurchase, idProductDetail]
    );
  }

  // UPDATE PRICE - Actualizar solo el precio
  Future<int> UPDATE_PRICE(int idPurchase, int idProductDetail, double newPrice) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'PURCHASE_DETAIL',
      {'price': newPrice},
      where: "idPurchase = ? AND idProductDetail = ?",
      whereArgs: [idPurchase, idProductDetail]
    );
  }

  // COUNT ITEMS IN PURCHASE - Contar elementos en una compra
  Future<int> COUNT_ITEMS_IN_PURCHASE(int idPurchase) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT COUNT(*) FROM PURCHASE_DETAIL WHERE idPurchase = ?',
      [idPurchase]
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // GET TOTAL QUANTITY - Cantidad total de productos en una compra
  Future<int> GET_TOTAL_QUANTITY(int idPurchase) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT SUM(quantity) FROM PURCHASE_DETAIL WHERE idPurchase = ?',
      [idPurchase]
    );
    return (res.first.values.first as int?) ?? 0;
  }

  // GET SUBTOTAL - Subtotal de una compra
  Future<double> GET_SUBTOTAL(int idPurchase) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT SUM(quantity * price) FROM PURCHASE_DETAIL WHERE idPurchase = ?',
      [idPurchase]
    );
    return (res.first.values.first as double?) ?? 0.0;
  }

  // GET PRODUCT SALES - Ventas totales de un producto
  Future<Map<String, dynamic>?> GET_PRODUCT_SALES(int idProductDetail) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('''
      SELECT 
        COUNT(*) as timesSold,
        SUM(quantity) as totalQuantitySold,
        SUM(quantity * price) as totalRevenue,
        AVG(price) as averagePrice
      FROM PURCHASE_DETAIL 
      WHERE idProductDetail = ?
    ''', [idProductDetail]);
    
    return res.isNotEmpty ? res.first : null;
  }

  // EXISTS - Verificar si existe un detalle específico
  Future<bool> EXISTS(int idPurchase, int idProductDetail) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'PURCHASE_DETAIL',
      where: "idPurchase = ? AND idProductDetail = ?",
      whereArgs: [idPurchase, idProductDetail]
    );
    return res.isNotEmpty;
  }

  // GET SALES BY DATE RANGE - Ventas por rango de fechas
  Future<List<Map<String, dynamic>>> GET_SALES_BY_DATE_RANGE(String startDate, String endDate) async {
    var con = await _purchaseDB.database;
    return await con!.rawQuery('''
      SELECT 
        pd.*,
        p.date,
        pr.titulo
      FROM PURCHASE_DETAIL pd
      INNER JOIN PURCHASE p ON pd.idPurchase = p.idPurchase
      INNER JOIN PRODUCT_DETAIL det ON pd.idProductDetail = det.idProductDetail
      INNER JOIN PRODUCT pr ON det.idProduct = pr.idProduct
      WHERE p.date BETWEEN ? AND ?
      ORDER BY p.date DESC
    ''', [startDate, endDate]);
  }
}