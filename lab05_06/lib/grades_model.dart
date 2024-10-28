import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'grade.dart';

// A model class for managing grades in the SQLite database.
class GradesModel {
  static Database? _database;

  // Gets the database instance, initializing it if necessary.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initializes the database.
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'grades.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE grades(id INTEGER PRIMARY KEY, sid TEXT, grade TEXT)',
        );
      },
      version: 1,
    );
  }

  // Retrieves all grades from the database.
  Future<List<Grade>> getAllGrades() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('grades');
    return List.generate(maps.length, (i) {
      return Grade.fromMap(maps[i]);
    });
  }

  // Inserts a new grade into the database.
  Future<void> insertGrade(Grade grade) async {
    final db = await database;
    await db.insert(
      'grades',
      grade.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Updates an existing grade in the database.
  Future<void> updateGrade(Grade grade) async {
    final db = await database;
    await db.update(
      'grades',
      grade.toMap(),
      where: 'id = ?',
      whereArgs: [grade.id],
    );
  }

  // Deletes a grade from the database by ID.
  Future<void> deleteGradeById(int id) async {
    final db = await database;
    await db.delete(
      'grades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}