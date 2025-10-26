import 'package:prog2025_firtst/models/category_dao.dart';
import 'package:prog2025_firtst/database/purchase_database.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDatabase {
  final PurchaseDatabase _purchaseDB = PurchaseDatabase();

  // INSERT - Crear nueva categoría
  Future<int> INSERT(CategoryDao category) async {
    var con = await _purchaseDB.database;
    return con!.insert('CATEGORY', category.toMap());
  }

  // UPDATE - Actualizar categoría existente
  Future<int> UPDATE(CategoryDao category) async {
    var con = await _purchaseDB.database;
    return con!.update(
      'CATEGORY', 
      category.toMap(), 
      where: "idCategory = ?", 
      whereArgs: [category.idCategory]
    );
  }

  // DELETE - Eliminar categoría por ID
  Future<int> DELETE(int idCategory) async {
    var con = await _purchaseDB.database;
    return con!.delete(
      'CATEGORY', 
      where: "idCategory = ?", 
      whereArgs: [idCategory]
    );
  }

  // SELECT ALL - Obtener todas las categorías
  Future<List<CategoryDao>> SELECT() async {
    var con = await _purchaseDB.database;
    final res = await con!.query('CATEGORY');
    return res.map((category) => CategoryDao.fromMap(category)).toList();
  }

  // SELECT BY ID - Obtener categoría por ID
  Future<CategoryDao?> SELECT_BY_ID(int idCategory) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'CATEGORY',
      where: "idCategory = ?",
      whereArgs: [idCategory]
    );
    
    if (res.isNotEmpty) {
      return CategoryDao.fromMap(res.first);
    }
    return null;
  }

  // SELECT BY NAME - Buscar categorías por nombre
  Future<List<CategoryDao>> SELECT_BY_NAME(String nameCategory) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'CATEGORY',
      where: "nameCategory LIKE ?",
      whereArgs: ['%$nameCategory%']
    );
    return res.map((category) => CategoryDao.fromMap(category)).toList();
  }

  // COUNT - Contar total de categorías
  Future<int> COUNT() async {
    var con = await _purchaseDB.database;
    final res = await con!.rawQuery('SELECT COUNT(*) FROM CATEGORY');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // EXISTS - Verificar si existe una categoría con ese nombre
  Future<bool> EXISTS(String nameCategory) async {
    var con = await _purchaseDB.database;
    final res = await con!.query(
      'CATEGORY',
      where: "nameCategory = ?",
      whereArgs: [nameCategory]
    );
    return res.isNotEmpty;
  }
}