import 'package:prog2025_firtst/models/points_dao.dart';
import 'package:prog2025_firtst/database/purchase_database.dart';
import 'package:sqflite/sqflite.dart';

class PointsDatabase {
  final PurchaseDatabase _purchaseDB = PurchaseDatabase();

  // INSERT - Crear nuevo registro de puntos
  Future<int> INSERT(PointsDao points) async {
    var con = await _purchaseDB.database;
    return con!.insert('POINTS', points.toMap());
  }

  // INSERT POINTS - Agregar puntos con parámetros
  Future<int> INSERT_POINTS(String type, double amount, String date, String description) async {
    var con = await _purchaseDB.database;
    return con!.insert('POINTS', {
      'type': type,
      'ammount': amount, // Nota: en la BD está como 'ammount' (con doble m)
      'date': date,
      'description': description,
    });
  }

  // UPDATE - Actualizar registro de puntos existente
  Future<int> UPDATE(PointsDao points) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'POINTS', 
      points.toMap(), 
      where: "idPoints = ?", 
      whereArgs: [points.idPoints]
    );
  }

  // DELETE - Eliminar registro de puntos por ID
  Future<int> DELETE(int idPoints) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'POINTS', 
      where: "idPoints = ?", 
      whereArgs: [idPoints]
    );
  }

  // DELETE OLD - Eliminar registros antiguos
  Future<int> DELETE_OLD(String beforeDate) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'POINTS', 
      where: "date < ?", 
      whereArgs: [beforeDate]
    );
  }

  // SELECT ALL - Obtener todos los registros de puntos
  Future<List<PointsDao>> SELECT() async {
    var con = await _purchaseDB.database;
    final res = await con!.query('POINTS', orderBy: 'date DESC, idPoints DESC');
    return res.map((points) => PointsDao.fromMap(points)).toList();
  }

  // SELECT BY ID - Obtener registro por ID
  Future<PointsDao?> SELECT_BY_ID(int idPoints) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'POINTS',
      where: "idPoints = ?",
      whereArgs: [idPoints]
    );
    
    if (res.isNotEmpty) {
      return PointsDao.fromMap(res.first);
    }
    return null;
  }

  // SELECT BY TYPE - Obtener registros por tipo
  Future<List<PointsDao>> SELECT_BY_TYPE(String type) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'POINTS',
      where: "type = ?",
      whereArgs: [type],
      orderBy: 'date DESC'
    );
    return res.map((points) => PointsDao.fromMap(points)).toList();
  }

  // SELECT BY DATE - Obtener registros por fecha
  Future<List<PointsDao>> SELECT_BY_DATE(String date) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'POINTS',
      where: "date = ?",
      whereArgs: [date],
      orderBy: 'idPoints DESC'
    );
    return res.map((points) => PointsDao.fromMap(points)).toList();
  }

  // SELECT BY DATE RANGE - Obtener registros por rango de fechas
  Future<List<PointsDao>> SELECT_BY_DATE_RANGE(String startDate, String endDate) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'POINTS',
      where: "date BETWEEN ? AND ?",
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC'
    );
    return res.map((points) => PointsDao.fromMap(points)).toList();
  }

  // SELECT EARNED POINTS - Obtener solo puntos ganados (amount > 0)
  Future<List<PointsDao>> SELECT_EARNED_POINTS() async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'POINTS',
      where: "ammount > 0",
      orderBy: 'date DESC'
    );
    return res.map((points) => PointsDao.fromMap(points)).toList();
  }

  // SELECT SPENT POINTS - Obtener solo puntos gastados (amount < 0)
  Future<List<PointsDao>> SELECT_SPENT_POINTS() async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'POINTS',
      where: "ammount < 0",
      orderBy: 'date DESC'
    );
    return res.map((points) => PointsDao.fromMap(points)).toList();
  }

  // SELECT RECENT - Obtener registros más recientes
  Future<List<PointsDao>> SELECT_RECENT(int limit) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'POINTS',
      orderBy: 'date DESC, idPoints DESC',
      limit: limit
    );
    return res.map((points) => PointsDao.fromMap(points)).toList();
  }

  // GET TOTAL BALANCE - Obtener balance total de puntos
  Future<double> GET_TOTAL_BALANCE() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT SUM(ammount) FROM POINTS');
    return (res.first.values.first as double?) ?? 0.0;
  }

  // GET TOTAL EARNED - Obtener total de puntos ganados
  Future<double> GET_TOTAL_EARNED() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT SUM(ammount) FROM POINTS WHERE ammount > 0');
    return (res.first.values.first as double?) ?? 0.0;
  }

  // GET TOTAL SPENT - Obtener total de puntos gastados
  Future<double> GET_TOTAL_SPENT() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT SUM(ammount) FROM POINTS WHERE ammount < 0');
    return (res.first.values.first as double?) ?? 0.0;
  }

  // GET BALANCE BY TYPE - Obtener balance por tipo
  Future<double> GET_BALANCE_BY_TYPE(String type) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT SUM(ammount) FROM POINTS WHERE type = ?',
      [type]
    );
    return (res.first.values.first as double?) ?? 0.0;
  }

  // GET BALANCE BY DATE RANGE - Balance por rango de fechas
  Future<double> GET_BALANCE_BY_DATE_RANGE(String startDate, String endDate) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT SUM(ammount) FROM POINTS WHERE date BETWEEN ? AND ?',
      [startDate, endDate]
    );
    return (res.first.values.first as double?) ?? 0.0;
  }

  // GET POINTS SUMMARY - Resumen de puntos
  Future<Map<String, dynamic>?> GET_POINTS_SUMMARY() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('''
      SELECT 
        COUNT(*) as totalTransactions,
        SUM(ammount) as totalBalance,
        SUM(CASE WHEN ammount > 0 THEN ammount ELSE 0 END) as totalEarned,
        SUM(CASE WHEN ammount < 0 THEN ammount ELSE 0 END) as totalSpent,
        AVG(ammount) as averageTransaction
      FROM POINTS
    ''');
    
    return res.isNotEmpty ? res.first : null;
  }

  // GET POINTS BY TYPE SUMMARY - Resumen por tipo
  Future<List<Map<String, dynamic>>> GET_POINTS_BY_TYPE_SUMMARY() async {
    var con = await _purchaseDB.database;
    return await con!.rawQuery('''
      SELECT 
        type,
        COUNT(*) as transactionCount,
        SUM(ammount) as totalAmount,
        AVG(ammount) as averageAmount
      FROM POINTS
      GROUP BY type
      ORDER BY totalAmount DESC
    ''');
  }

  // COUNT - Contar total de registros
  Future<int> COUNT() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT COUNT(*) FROM POINTS');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // COUNT BY TYPE - Contar registros por tipo
  Future<int> COUNT_BY_TYPE(String type) async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery(
      'SELECT COUNT(*) FROM POINTS WHERE type = ?',
      [type]
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // ADD PURCHASE POINTS - Agregar puntos por compra
  Future<int> ADD_PURCHASE_POINTS(double purchaseAmount, String date) async {
    double points = purchaseAmount * 0.1; // 10% de la compra en puntos
    return await INSERT_POINTS(
      'COMPRA', 
      points, 
      date, 
      'Puntos ganados por compra de \$${purchaseAmount.toStringAsFixed(2)}'
    );
  }

  // REDEEM POINTS - Redimir puntos
  Future<int> REDEEM_POINTS(double pointsToRedeem, String date, String description) async {
    return await INSERT_POINTS(
      'CANJE', 
      -pointsToRedeem, // Negativo porque se gastan
      date, 
      description
    );
  }

  // CAN REDEEM - Verificar si se pueden redimir puntos
  Future<bool> CAN_REDEEM(double pointsToRedeem) async {
    double currentBalance = await GET_TOTAL_BALANCE();
    return currentBalance >= pointsToRedeem;
  }
}