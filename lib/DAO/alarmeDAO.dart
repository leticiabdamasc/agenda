import 'package:notas/DAO/baseDAO.dart';
import 'package:notas/models/alarme.dart';

class AlarmDAO extends BaseDao<Alarm> {
  @override
  String get tableName => "alarm";

  @override
  Alarm fromMap(Map<String, dynamic> map) {
    return Alarm.fromMap(map);
  }

  Future<int> inserir(Alarm alarm) async {
    final dbClient = await db;
    var id = await dbClient.insert(tableName, alarm.toMap());
    return id;
    // print('id: $id');
  }

  Future<List<Alarm>> getAlarms() async {
    List<Alarm> _alarms = [];
    final dbClient = await db;
    var id = await dbClient.query(tableName);
    id.forEach((element) {
      var alarm = Alarm.fromMap(element);
      _alarms.add(alarm);
    });
    return _alarms;
  }

  Future<int> excluir(int id) async {
    final dbClient = await db;
    return await dbClient
        .rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
  }
}
