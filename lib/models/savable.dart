import 'package:dharma_deshana/handler/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class Savable {
  String getTableName() {
    return "";
  }

  String getArgs() {
    return "";
  }

  List<dynamic> getArgValues() {
    return [];
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>();
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await DatabaseHandler().database;

    return await db.query(getTableName());
  }

  Future<int> insert() async {
    Database db = await DatabaseHandler().database;

    return await db.insert(getTableName(), this.toMap());
  }

  Future<int> update() async {
    var db = await DatabaseHandler().database;
    return await db.update(getTableName(), this.toMap(),
        where: getArgs(), whereArgs: getArgValues());
  }

  Future<int> delete() async {
    var db = await DatabaseHandler().database;
    return db.delete(getTableName(),
        where: getArgs(), whereArgs: getArgValues());
  }

  Future<List<Map<String, dynamic>>> executeQuery(String sql) async {
    var db = await DatabaseHandler().database;
    return db.rawQuery(sql);
  }
}
