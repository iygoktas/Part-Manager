// ignore_for_file: depend_on_referenced_packages

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'ogrenci.db';
  static const _databaseVersion = 1;
  static const _ogrenciTableName = 'ogrenci';

  static Database? _database;

  DatabaseHelper._internal();
  static final DatabaseHelper databaseHelper = DatabaseHelper._internal();

  static DatabaseHelper get instance => databaseHelper;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialDatabase();
    return _database!;
  }

  Future<Database> _initialDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS ogrenci(id INTEGER PRIMARY KEY AUTOINCREMENT, ad Text not null,soyad text not null,numara text not null, sinif text not null, sube text not null)''');
  }
}
