import 'dart:async';

import 'package:notas/helpers/database_helper.dart';
import 'package:notas/utils/entity.dart';
import 'package:sqflite/sqflite.dart';

// Data Access Object
abstract class BaseDao<T extends Entity> {
  Future<Database> get db => DatabaseHelper.getInstance().db;
  T fromMap(Map<String, dynamic> map);

  Future<int> save({T entity, String tableName}) async {
    var dbClient = await db;
    var id = await dbClient.insert(tableName, entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('id: $id');
    return id;
  }

  Future<List<T>> query(String sql, [List<dynamic> arguments]) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery(sql, arguments);

    return list.map<T>((json) => fromMap(json)).toList();
  }

  Future<List<T>> findAll(String tableName) async {
    final list = await query('select * from $tableName');

    return list;
  }

  Future<T> findById({int id, String tableName}) async {
    final list = await query('select * from $tableName where id = ?', [id]);
    return list.length > 0 ? list.first : null;
  }

  Future<bool> exists({int id, String tableName}) async {
    T t = await findById(id: id, tableName: tableName);
    var exists = t != false;
    return exists;
  }

  Future<int> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select count(*) from $runZoned');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete({int id, String tableName}) async {
    var dbClient = await db;
    return await dbClient
        .rawDelete('delete from $tableName where id = ?', [id]);
  }

  Future<int> deleteAll({String tableName}) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from $tableName');
  }

  Future<int> update({T entity, String tableName}) async {
    Database dbClient = await db;
    var id = await dbClient.update(tableName, entity.toMap(),
        where: "id = ?",
        whereArgs: [entity],
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('id: $id');
    return id;
  }
}
