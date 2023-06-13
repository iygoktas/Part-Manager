import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'retrieved_assignment.dart';

class RetrievedAssignmentDatabaseHelper {
  static const _databaseName = 'retrieved_assignments.db';
  static const _databaseVersion = 1;
  static const _tableName = 'retrieved_assignments';

  static Database? _database;

  RetrievedAssignmentDatabaseHelper._privateConstructor();
  static final RetrievedAssignmentDatabaseHelper instance =
      RetrievedAssignmentDatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      studentName TEXT NOT NULL,
      studentSurname TEXT NOT NULL,
      materialName TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      selectedValue TEXT NOT NULL,
      date TEXT NOT NULL
    )
  ''');
  }

  Future<int> insertRetrievedAssignment(
      RetrievedAssignment retrievedAssignment) async {
    final db = await database;
    return await db.insert(
      _tableName,
      {
        'studentName': retrievedAssignment.studentName,
        'studentSurname': retrievedAssignment.studentSurname,
        'materialName': retrievedAssignment.materialName,
        'quantity': retrievedAssignment.quantity,
        'selectedValue': retrievedAssignment.selectedValue,
        'date': retrievedAssignment.date
      },
    );
  }

  Future<void> deleteRetrievedAssignment(int id) async {
    final db = await instance.database;
    await db.delete('retrieved_assignments', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getRetrievedAssignments() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<int> deleteAllRetrievedAssignments() async {
    final db = await database;
    return await db.delete(_tableName);
  }
}
