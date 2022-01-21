import 'dart:core';

import 'package:notas/utils/entity.dart';

class Anotacao extends Entity {
  int id;
  String title;
  String body;
  String img;
  String dataTime;

  Anotacao({
    this.id,
    this.title,
    this.body,
    this.dataTime,
  });

  Anotacao.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    img = map['img'];
    dataTime = map['dataTime'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['img'] = this.img;
    data['dataTime'] = this.dataTime;
    return data;
  }

  Anotacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    img = json['img'];
    dataTime = json['dataTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['img'] = this.img;
    data['dateTime'] = this.dataTime;

    return data;
  }

  @override
  String toString() {
    return "Anotacao -> (id: $id, title: $title, body: $body, img $img, dateTime $dataTime)";
  }
}
