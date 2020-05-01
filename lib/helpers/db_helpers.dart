import 'dart:core';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'dhikr.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }
  
   static void _createDb(Database db) {
       db.execute(
        'CREATE TABLE dhikr_list(title TEXT,id TEXT PRIMARY KEY,date TEXT,time TEXT,count INTEGER)');
  }
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
  db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table,String id) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
 
  static Future<List<Map<String, dynamic>>> getData(String table) async {
  final db = await DBHelper.database();
  return db.query(table);
  }

}
