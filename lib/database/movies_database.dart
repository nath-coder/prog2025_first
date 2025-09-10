import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MoviesDatabase {
  static final namedb="MOVIESDB";
  static final versionDB=1; //esto se debe de modificar si esta en producción y si esta cambio de desarrollo si hay cambio en el BD o eliminar cache 

  static Database? _database; //varible que puede ser nula y privada (_)

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, namedb); //"${folder.path}/nombreBD"
    return openDatabase(pathDB, version: versionDB,onCreate: createTables);

  }
  
  // Database initialization and CRUD operations will be defined here

  FutureOr<void> createTables(Database db, int version) {
     String query='''
        CREATE TABLE tblMovies(
          idMovie INTEGER PRIMARY KEY,
          nameMovie varchar(50),
          time char(3),
          dateRelese char(10)
        )
      ''';
      db.execute(query);
  }
}