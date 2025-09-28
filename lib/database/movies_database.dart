import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:prog2025_firtst/models/movie_dao.dart';
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
    return openDatabase(pathDB, version: versionDB,onCreate: createTables); // si se cambian las version se ejecuta el onCreate.

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

  Future<int> INSERT(String table, Map<String, dynamic> data) async{
    var con = await database;
     return con!.insert(table, data); // el ! es para decir que no es nulo
  }
  Future<int> UPDATE(String table, Map<String, dynamic> data) async{
    var con = await database;
    return con!.update(table, data, where: "idMovie = ?",whereArgs: [data["idMovie"]]); // consultas parametrizadas
  }
  Future<int> DELETE(String table, int id) async{
    var con = await database;
    return con!.delete(table, where: "idMovie = ?", whereArgs: [id]);
  }
  Future<List<MovieDao>> SELECT() async {
    var con = await database;
    final res=await con!.query("tblMovies");
    //debo de traer cada mapa de la lista y convertirlo a un objeto de tipo MovieDao
    //se necesita un cilclo. El map es una funcion de List que ejecuta una funcion por cada elemento de la 
    //movie lo que esta dentro del map es una funcion anonima
    // to list convierte el iterable a una lista
    return res.map((movie) => MovieDao.fromMap(movie),).toList();
  }
}