import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalSqflite{

  String tableName;
  String columnTitle;
  String columnDes;
  String dbName;

  Database _db;
  Database get db => _db;
  set db(newDB) => throw "ERR !";

  LocalSqflite({@required this.dbName, @required this.tableName, @required this.columnTitle, @required this.columnDes})
    : assert(dbName != null), assert(tableName != null), assert(columnTitle != null), assert(columnDes != null){
       Future.microtask(() async => await init());
      }

  Future<void> init() async{
    String _databasesPath = await getDatabasesPath();
    String _path = join(_databasesPath, '${this.dbName}.db');
    _db = await openDatabase(_path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE ${this.tableName} (id INTEGER PRIMARY KEY, ${this.columnTitle} TEXT, ${this.columnDes} TEXT)');
    });
    return;
  }

  Future<List<Map<String, dynamic>>> dbDataGet() async => await _db?.rawQuery('SELECT * FROM ${this.tableName} LIMIT 100') ?? null;
  Future<int> createTransitionData({@required String cTitle, @required String cDes}) async => _db?.transaction((txn) async{
    String _intsetSql = 'INSERT INTO ${this.tableName}(${this.columnTitle},${this.columnDes}) VALUES(?,?)';
    return await txn.rawInsert(_intsetSql,[cTitle, cDes]);
  }) ?? null;
  Future updateData({@required int id, @required String cTitle, @required String cDes}) async => await _db?.rawUpdate(
    'UPDATE ${this.tableName} SET ${this.columnTitle} = ?, ${this.columnDes} = ? WHERE id = ?',
    [cTitle, cDes, id]
  );
  Future<int> delData({@required int id}) async => await _db?.rawDelete('DELETE FROM ${this.tableName} WHERE id = ?', [id]) ?? null;
}