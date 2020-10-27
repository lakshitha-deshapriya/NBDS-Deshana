import 'dart:io';

import 'package:dharma_deshana/models/savable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  static DatabaseHandler _databaseHandler;
  static Database _database;

  DatabaseHandler._createInstance();

  factory DatabaseHandler() {
    if (_databaseHandler == null) {
      _databaseHandler = DatabaseHandler._createInstance();
    }
    return _databaseHandler;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'music_player.db';

    var db = await openDatabase(path, version: 1, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE SONGS ( SONG_ID PRIMARY KEY, SONG_IDENTIFIER TEXT, CATEGORY TEXT, SONG_URL TEXT, NAME TEXT, TYPE TEXT, SUB TEXT, COVER_URL TEXT, INSERT_TIME INTEGER )');
    await db.execute(
        'CREATE TABLE CATEGORIES ( CATEGORY_ID PRIMARY KEY, CATEGORY TEXT, CATEGORY_NAME TEXT, IMAGE_URL TEXT )');
  }

  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    Database db = await DatabaseHandler().database;

    return await db.query(tableName);
  }

  Future<int> insert(Savable savable) async {
    Database db = await DatabaseHandler().database;

    return await db.insert(savable.getTableName(), savable.toMap());
  }

  void insertAll(List<Savable> savables) async {
    Database db = await DatabaseHandler().database;
    Batch batch = db.batch();
    for (Savable savable in savables) {
      batch.insert(savable.getTableName(), savable.toMap());
    }
    batch.commit(noResult: true);
  }

  Future<int> update(Savable savable) async {
    var db = await DatabaseHandler().database;
    return await db.update(savable.getTableName(), savable.toMap(),
        where: savable.getArgs(), whereArgs: savable.getArgValues());
  }

  Future<int> delete(Savable savable) async {
    var db = await DatabaseHandler().database;
    return db.delete(savable.getTableName(),
        where: savable.getArgs(), whereArgs: savable.getArgValues());
  }

  Future<int> deleteAll(String tableName) async {
    var db = await DatabaseHandler().database;
    return db.delete(tableName);
  }

  dynamic executeQuery(String sql) async {
    var db = await DatabaseHandler().database;
    return db.rawQuery(sql);
  }
}
