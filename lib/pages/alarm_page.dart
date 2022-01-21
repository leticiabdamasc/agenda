import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:notas/DAO/alarmeDAO.dart';
import 'package:notas/models/alarme.dart';
import 'package:notas/pages/data.dart';
import 'package:notas/helpers/notifications_helper.dart';

import '../main.dart';

class Alarmpage extends StatefulWidget {
  @override
  _AlarmpageState createState() => _AlarmpageState();
}

class _AlarmpageState extends State<Alarmpage> {
  DateTime _alarmTime;
  String _alarmTimeString;
  AlarmDAO alarmDAO = AlarmDAO();
  Future<List<Alarm>> _alarms;
  List<Alarm> _currentAlarms;

  TextEditingController _titleTextFieldController = TextEditingController();

  @override
  void initState() {
    _alarmTime = DateTime.now();
    fetchDados();
    super.initState();
  }

  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFFFFAFA),
        title: Text(
          "Lembrete",
          style: TextStyle(
              color: Color(0xFFa98f78),
              fontSize: 22,
              fontWeight: FontWeight.w400),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Color(0xFFa98f78),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: body(),
    );
  }

  body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<Alarm>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data.map<Widget>((alarm) {
                      var alarmTime =
                          DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                      return Container(
                        margin: EdgeInsets.only(bottom: 30),
                        padding: EdgeInsets.all(20),
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFFdcbeb4), Color(0xFFdcbeb4)]),
                          color: Color(0xFFa98f78),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          /* boxShadow: [
                              BoxShadow(
                                color: Color(0xFFdcbeb4),
                                blurRadius: 8,
                                spreadRadius: 4,
                                offset: Offset(4, 4),
                              )
                            ] */
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  alarm.title,
                                  style: TextStyle(
                                      color: Color(0xFF321804),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  alarmTime,
                                  style: TextStyle(
                                      color: Color(0xFF321804),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    color: Color(0xFF321804),
                                    onPressed: () {
                                      delete(alarm.id);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (_currentAlarms.length < 5)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFFa98f78),
                            borderRadius: BorderRadius.all(
                              Radius.circular(24),
                            ),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              _alarmTimeString =
                                  DateFormat('HH:mm').format(DateTime.now());
                              showModalBottomSheet(
                                useRootNavigator: true,
                                context: context,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return Container(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          children: [
                                            FlatButton(
                                              onPressed: () async {
                                                var selectedTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );
                                                if (selectedTime != null) {
                                                  final now = DateTime.now();
                                                  var selectedDateTime =
                                                      DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          selectedTime.hour,
                                                          selectedTime.minute);
                                                  _alarmTime = selectedDateTime;
                                                  setModalState(() {
                                                    _alarmTimeString =
                                                        DateFormat('HH:mm')
                                                            .format(
                                                                selectedDateTime);
                                                  });
                                                }
                                              },
                                              child: Text(
                                                _alarmTimeString,
                                                style: TextStyle(fontSize: 32),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text('Titulo'),
                                              trailing:
                                                  Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Adiocinar um titulo"),
                                                        content: TextField(
                                                          controller:
                                                              _titleTextFieldController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                ("Digite o titlo"),
                                                          ),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            onPressed: () {
                                                              _titleTextFieldController
                                                                  .text;
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("Salvar"),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Cancelar",
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                            ),
                                            FloatingActionButton.extended(
                                              backgroundColor:
                                                  Color(0xFFa98f78),
                                              onPressed: onSaveAlarm,
                                              icon: Icon(Icons.alarm),
                                              label: Text('Salvar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.add, color: Colors.white, size: 50),
                                SizedBox(height: 8),
                                Text('Adicionar lembrete',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Text('São permitidos apenas 5 alarmes!'),
                        )
                    ]).toList(),
                  );
                }
                return Center(
                  child: Text(
                    'Carregando...',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  fetchDados() {
    _alarms = alarmDAO.getAlarms();
    if (mounted) setState(() {});
    print("inicializado");
  }

  void onSaveAlarm() {
    DateTime scheduleAlarmDateTime;
    if (_alarmTime.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime.add(Duration(days: 1));

    var alarm = Alarm(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms.length,
      title: _titleTextFieldController
          .text, //<------------------------------------------
    );
    alarmDAO.inserir(alarm);
    scheduleNotification(scheduleAlarmDateTime, alarm);
    Navigator.pop(context);
    fetchDados();
  }

  Future<void> scheduleNotification(
      DateTime scheduledNotificationDateTime, Alarm alarm) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'id',
      'title',
      'body',
      icon: 'app_icon',
      importance: Importance.Max,
      priority: Priority.Max,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        DateTime.now().hashCode,
        'Lembrete',
        alarm.title,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  void delete(int id) {
    alarmDAO.excluir(id);
    fetchDados();
  }

  Future<Alarm> _showDialog(BuildContext context, Alarm alarm) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adiocnar um titulo"),
            content: TextField(
              onChanged: (text) {},
              controller: _titleTextFieldController,
              decoration: InputDecoration(
                hintText: ("Digite o titlo"),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  _titleTextFieldController.text = alarm.title;
                },
                child: Text("Salvar"),
              ),
              FlatButton(
                onPressed: () {},
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }

  Future<void> turnOffNotificationById(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      num id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
