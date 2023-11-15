import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/database/database_service.dart';
import 'package:sqflite_demo/models/product.dart';

class ProductDatabase {
  static const tableName = "products";

  static Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL PRIMARY KEY, 
        "title" TEXT NOT NULL,
        "price" INTEGER NOT NULL,
        "thumbnail" TEXT,
      )""");
  }

  Future<List<Product>?> getProducts() async {
    final database = await DatabaseService().database;
    final queryResult = await database.query(tableName);
    if (queryResult.isEmpty) {
      return null;
    }

    return List.generate(
      queryResult.length,
      (index) => Product.fromSqfliteDatabase(queryResult[index]),
    );
  }

  Future<Product?> getProduct(String id) async {
    final database = await DatabaseService().database;
    final queryResult = await database.query(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    if (queryResult.isEmpty) {
      return null;
    }

    return Product.fromSqfliteDatabase(queryResult.first);
  }

  Future<int> addProduct(Product product) async {
    final database = await DatabaseService().database;
    return await database.rawInsert("""INSERT INTO $tableName
    (title, price, thumbnail) 
    VALUES (?, ?, ?, ?, ?, ?)""",
        [product.title, product.price, product.thumbnail]);

    // return await database.insert(
    //     tableName,
    //     {
    //       'title': product.title,
    //       'price': product.price,
    //       'thumbnail': product.thumbnail
    //     },
    //     conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> updateProduct(Product product) async {
    final database = await DatabaseService().database;
    return await database.rawUpdate("""UPDATE $tableName SET
    title = ?, price = ?, thumbnail = ? 
    WHERE id = ?""",
        [product.title, product.price, product.thumbnail, product.id]);

    // return await database.update(
    //     tableName,
    //     {
    //       'title': product.title,
    //       'price': product.price,
    //       'thumbnail': product.thumbnail
    //     },
    //     where: "id = ?",
    //     whereArgs: [product.id],
    //     conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  Future<int> deleteProduct(String id) async {
    final database = await DatabaseService().database;
    return await database
        .rawDelete("""DELETE FROM $tableName WHERE id = ?""", [id]);
  }
}
