import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database _database;
  String _dbName = "restofood.db";

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/${_dbName}";
    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }

  void _createDB(Database db, int newVersion) async {
    await db
        .execute('''CREATE TABLE foods (id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT, description TEXT, full_description TEXT, price INTEGER, image TEXT)''');
  }
}
