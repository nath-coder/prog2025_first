import 'package:prog2025_firtst/database/purchase_database.dart';
import 'package:prog2025_firtst/models/purchase_dao.dart';
import 'package:sqflite/sqflite.dart';

class PurchaseDatabaseCRUD {
  final PurchaseDatabase _dbHelper = PurchaseDatabase();

  Future<Database?> get _db async => await _dbHelper.database;

  // INSERT - Crear nueva compra (retorna id generado)
  Future<int> INSERT(PurchaseDao purchase) async {
    final con = await _db;
    return await con!.insert('PURCHASE', purchase.toMap());
  }

  // INSERT CON DETALLES - Transaccional: inserta PURCHASE y varios PURCHASE_DETAIL
  // details: lista de mapas con keys: idProductDetail, quantity, price
  Future<int> INSERT_WITH_DETAILS(PurchaseDao purchase, List<Map<String, dynamic>> details) async {
    final con = await _db;
    if (con == null) throw Exception('Database not initialized');
    return await con.transaction<int>((txn) async {
      final id = await txn.insert('PURCHASE', purchase.toMap());
      for (var d in details) {
        final detailMap = Map<String, dynamic>.from(d);
        detailMap['idPurchase'] = id;
        await txn.insert('PURCHASE_DETAIL', detailMap);
      }
      return id;
    });
  }

  // UPDATE - Actualizar compra existente
  Future<int> UPDATE(PurchaseDao purchase) async {
    final con = await _db;
    return await con!.update('PURCHASE', purchase.toMap(),
        where: 'idPurchase = ?', whereArgs: [purchase.idPurchase]);
  }

  // DELETE - Eliminar compra por ID (cascada eliminará detalle si FK configurado)
  Future<int> DELETE(int idPurchase) async {
    final con = await _db;
    return await con!.delete('PURCHASE', where: 'idPurchase = ?', whereArgs: [idPurchase]);
  }

  // SELECT ALL - Obtener todas las compras (como objetos PurchaseDao)
  Future<List<PurchaseDao>> SELECT() async {
    final con = await _db;
    final res = await con!.query('PURCHASE', orderBy: 'date DESC, idPurchase DESC');
    return res.map((m) => PurchaseDao.fromMap(m)).toList();
  }

  // SELECT BY ID - Obtener compra por ID
  Future<PurchaseDao?> SELECT_BY_ID(int idPurchase) async {
    final con = await _db;
    final res = await con!.query('PURCHASE', where: 'idPurchase = ?', whereArgs: [idPurchase]);
    if (res.isNotEmpty) return PurchaseDao.fromMap(res.first);
    return null;
  }

  // SELECT BY USER - Obtener compras de un usuario
  Future<List<PurchaseDao>> SELECT_BY_USER(String userId) async {
    final con = await _db;
    final res = await con!.query('PURCHASE',
        where: 'userId = ?', whereArgs: [userId], orderBy: 'date DESC, idPurchase DESC');
    return res.map((m) => PurchaseDao.fromMap(m)).toList();
  }

  // SELECT BY USER AND STATE - Compras de un usuario filtradas por estado
  Future<List<PurchaseDao>> SELECT_BY_USER_AND_STATE(String userId, String state) async {
    final con = await _db;
    final res = await con!.query('PURCHASE',
        where: 'userId = ? AND state = ?', whereArgs: [userId, state], orderBy: 'date DESC, idPurchase DESC');
    return res.map((m) => PurchaseDao.fromMap(m)).toList();
  }

  // SELECT BY STATE - Obtener compras por estado
  Future<List<PurchaseDao>> SELECT_BY_STATE(String state) async {
    final con = await _db;
    final res = await con!.query('PURCHASE', where: 'state = ?', whereArgs: [state], orderBy: 'date DESC');
    return res.map((m) => PurchaseDao.fromMap(m)).toList();
  }

  // OBTENER DETALLES DE UNA COMPRA - join con PRODUCT_DETAIL y PRODUCT para info del producto
  // Retorna lista de mapas con keys: idPurchase, idProductDetail, quantity, price, product fields...
  Future<List<Map<String, dynamic>>> SELECT_DETAILS_BY_PURCHASE(int idPurchase) async {
    final con = await _db;
    final sql = '''
      SELECT pd.idPurchase, pd.idProductDetail, pd.quantity AS quantity, pd.price AS price,
             p.idProduct, p.titulo, p.price AS productPrice, p.image,
             pdet.size, pdet.color, pdet.imageDetail, pdet.quantity AS stock
      FROM PURCHASE_DETAIL pd
      LEFT JOIN PRODUCT_DETAIL pdet ON pd.idProductDetail = pdet.idProductDetail
      LEFT JOIN PRODUCT p ON pdet.idProduct = p.idProduct
      WHERE pd.idPurchase = ?
    ''';
    final res = await con!.rawQuery(sql, [idPurchase]);
    return res;
  }

  // COUNT - contar total de compras
  Future<int> COUNT() async {
    final con = await _db;
    final res = await con!.rawQuery('SELECT COUNT(*) FROM PURCHASE');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // COUNT BY STATE
  Future<int> COUNT_BY_STATE(String state) async {
    final con = await _db;
    final res = await con!.rawQuery('SELECT COUNT(*) FROM PURCHASE WHERE state = ?', [state]);
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // UPDATE STATE - Actualizar solo estado
  Future<int> UPDATE_STATE(int idPurchase, String newState) async {
    final con = await _db;
    return await con!.update('PURCHASE', {'state': newState}, where: 'idPurchase = ?', whereArgs: [idPurchase]);
  }

  // GET TOTAL SALES - suma total de todas las compras
  Future<double> GET_TOTAL_SALES() async {
    final con = await _db;
    final res = await con!.rawQuery('SELECT SUM(total) as total FROM PURCHASE');
    final val = res.first['total'];
    if (val == null) return 0.0;
    if (val is int) return val.toDouble();
    return val as double;
  }

  // GET TOTAL SALES BY STATE
  Future<double> GET_TOTAL_SALES_BY_STATE(String state) async {
    final con = await _db;
    final res = await con!.rawQuery('SELECT SUM(total) as total FROM PURCHASE WHERE state = ?', [state]);
    final val = res.first['total'];
    if (val == null) return 0.0;
    if (val is int) return val.toDouble();
    return val as double;
  }

  // UTIL: exists
  Future<bool> EXISTS(int idPurchase) async {
    final con = await _db;
    final res = await con!.query('PURCHASE', where: 'idPurchase = ?', whereArgs: [idPurchase]);
    return res.isNotEmpty;
  }
}