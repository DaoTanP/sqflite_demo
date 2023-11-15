import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_demo/database/product_database.dart';

class DatabaseService {
  Database? _database;
  final int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final path = await dbPath;
    Database db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: createDatabase,
      singleInstance: true,
    );

    return db;
  }

  Future<String> get dbPath async {
    const dbName = "product.db";
    final path = await getDatabasesPath();
    return join(path, dbName);
  }

  Future<void> createDatabase(Database database, int version) async {
    ProductDatabase.createTable(database);
  }
}
