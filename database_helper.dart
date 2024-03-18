import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'journal.db');
    return openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journal_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry TEXT,
        mood TEXT,
        date TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return await db.insert('journal_entries', entry);
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await database;
    return await db.query('journal_entries');
  }
}
