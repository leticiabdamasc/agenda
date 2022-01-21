import 'package:notas/utils/entity.dart';

class Alarm extends Entity {
  int id;
  String title;
  DateTime alarmDateTime;

  int gradientColorIndex;

  Alarm({this.id, this.title, this.alarmDateTime, this.gradientColorIndex});

  factory Alarm.fromMap(Map<String, dynamic> json) => Alarm(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        gradientColorIndex: json["gradientColorIndex"],
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "gradientColorIndex": gradientColorIndex,
      };
}
