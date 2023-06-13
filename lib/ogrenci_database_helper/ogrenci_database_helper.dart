// ignore_for_file: depend_on_referenced_packages

import 'package:parcacii/ogrenci_database_helper/database_helper.dart';
import 'package:parcacii/ogrenci_database_helper/ogrenci.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  static Future<Database>? _database;
  static const String _databaseName = 'student_database.db';
  static const String _ogrenciTableName = 'ogrenci';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $_ogrenciTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ad TEXT,
            soyad TEXT,
            numara TEXT,
            sinif TEXT,
            sube TEXT,
            assigned_material TEXT
          )
          ''',
        );
      },
      version: 1,
    );

    return _database!;
  }

  static Future<int> createUser(Ogrenci user) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(_ogrenciTableName, user.toMap());
  }

  static Future<List<Ogrenci>> getUsers() async {
    //await Future.delayed(const Duration(seconds: 3));
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> list = await db.query(_ogrenciTableName);

    return List.generate(list.length, (index) {
      return Ogrenci.fromMap(list[index]);
    });
  }

  static Future<int> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    return db.delete(_ogrenciTableName, where: 'id=?', whereArgs: [id]);
  }

  static Future<void> assignMaterial(
      int studentId, String materialName, int quantity) async {
    final db = await database;
    const table = 'ogrenci';
    await db.update(
      table,
      {'assigned_material': '$materialName ($quantity pieces)'},
      where: 'id = ?',
      whereArgs: [studentId],
    );
  }

  Future<void> insertAssignment({
    required int studentId,
    required int materialId,
    required int quantity,
  }) async {
    final db = await database;
    await db.insert(
      'assignments',
      {
        'student_id': studentId,
        'material_id': materialId,
        'quantity': quantity,
      },
    );
  }
}
