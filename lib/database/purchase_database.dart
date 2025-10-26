import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PurchaseDatabase {
  static final namedb = "PURCHASEDB";
  static final versionDB = 1;
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, namedb);
    return openDatabase(pathDB, version: versionDB, onCreate: createTables);
  }

  FutureOr<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE CATEGORY (
        idCategory INTEGER PRIMARY KEY,
        nameCategory VARCHAR(50)
      );
    ''');

    await db.execute('''
      CREATE TABLE PRODUCT (
        idProduct INTEGER PRIMARY KEY,
        titulo VARCHAR(100),
        idCategory INTEGER,
        puntuation DOUBLE,
        price DOUBLE,
        image VARCHAR(200),
        CONSTRAINT fk_product_category
          FOREIGN KEY (idCategory)
          REFERENCES CATEGORY(idCategory)
          ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE PRODUCT_DETAIL (
        idProductDetail INTEGER PRIMARY KEY,
        idProduct INTEGER,
        quantity INTEGER,
        color VARCHAR(20),
        size VARCHAR(10),
        imageDetail VARCHAR(200),
        CONSTRAINT fk_detail_product
          FOREIGN KEY (idProduct)
          REFERENCES PRODUCT(idProduct)
          ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE PURCHASE (
        idPurchase INTEGER PRIMARY KEY,
        userId text,
        date CHAR(10),
        total DOUBLE,
        state VARCHAR(20)
      );
    ''');

    await db.execute('''
      CREATE TABLE PURCHASE_DETAIL (
        idPurchase INTEGER,
        idProductDetail INTEGER,
        quantity INTEGER,
        price DOUBLE,
        CONSTRAINT fk_detail_purchase
          FOREIGN KEY (idPurchase)
          REFERENCES PURCHASE(idPurchase)
          ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT fk_detail_product_detail
          FOREIGN KEY (idProductDetail)
          REFERENCES PRODUCT_DETAIL(idProductDetail)
          ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (idPurchase, idProductDetail)
      );
    ''');

    await db.execute('''
      CREATE TABLE FAVORITE (
        idFavorite INTEGER PRIMARY KEY,
        idProduct INTEGER,
        userId text,
        CONSTRAINT fk_favorite_product
          FOREIGN KEY (idProduct)
          REFERENCES PRODUCT(idProduct)
          ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE POINTS (
        
        idPoints INTEGER PRIMARY KEY,
        type VARCHAR(50),
        ammount DOUBLE,
        date CHAR(10),
        description VARCHAR(200),
        userId text
      );
    ''');
  }
}
