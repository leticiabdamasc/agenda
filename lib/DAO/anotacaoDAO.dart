import 'package:notas/DAO/baseDAO.dart';
import 'package:notas/models/anotacao.dart';

class AnotacaoDAO extends BaseDao<Anotacao> {
  @override
  String get tableName => "anotacao";

  @override
  Anotacao fromMap(Map<String, dynamic> map) {
    return Anotacao.fromMap(map);
  }

  Future<Anotacao> saveAnotacao(Anotacao anotacao) async {
    final dbClient = await db;
    anotacao.id = await dbClient.insert(tableName, anotacao.toMap());
    return anotacao;
  }

  Future<Anotacao> getAnotacao(int id) async {
    final dbClient = await db;
    List<Map> anotacao =
        await dbClient.query(tableName, where: "id = ?", whereArgs: [id]);
    if (anotacao.length > 0) {
      return Anotacao.fromMap(anotacao.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    final dbClient = await db;
    return await dbClient
        .rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
  }

  Future<List<Anotacao>> getAllAnotacao() async {
    final dbClient = await db;
    List list = await dbClient.query(tableName);
    List<Anotacao> listExerc = List();
    for (Map m in list) {
      listExerc.add(Anotacao.fromMap(m));
    }
    print(listExerc);
    return listExerc;
  }

  Future<int> updateAnotacao(Anotacao anotacao) async {
    final dbClient = await db;
    return await dbClient.update(tableName, anotacao.toMap(),
        where: "id = ?", whereArgs: [anotacao.id]);
  }
}
