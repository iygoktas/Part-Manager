import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ListingDatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'assignments.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Assignments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentName TEXT,
            studentSurname TEXT,
            materialName TEXT,
            quantity INTEGER,
            date TEXT
          )
        ''');
      },
    );

    return database;
  }

  Future<void> insertAssignment({
    required String studentName,
    required String studentSurname,
    required String materialName,
    required int quantity,
    required String date,
  }) async {
    final db = await database;
    await db.insert(
      'Assignments',
      {
        'studentName': studentName,
        'studentSurname': studentSurname,
        'materialName': materialName,
        'quantity': quantity,
        'date': date,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAssignments() async {
    final db = await database;
    return await db.query('Assignments');
  }

  Future<void> deleteAssignment(int assignmentId) async {
    final db = await database;
    await db.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [assignmentId],
    );
  }
}
