import 'dart:async';
import 'package:pocket_recipes/models/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {

  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String _path = await getDatabasesPath() + 'example';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE category_items (id INTEGER PRIMARY KEY NOT NULL, title STRING)');
    await db.execute('CREATE TABLE recipe_items (id INTEGER PRIMARY KEY NOT NULL, title STRING, category STRING)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  // Used for recipe items exclusively
  static Future<List<Map<String, dynamic>>> queryCategory(String table, String category) async {
    return await _db.query(table,
        where: 'category = ?',
        whereArgs: [category]);
  }

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async =>
      await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}