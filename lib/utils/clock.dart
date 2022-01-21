import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer timer;
  DateTime now = DateTime.now();
  DateFormat formattedDate = DateFormat("dd MMM yyy", 'pt');

  DateFormat formattedHour = DateFormat("HH:mm", 'pt');
  String _newFormattedHour = DateFormat("HH:mm", 'pt').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var perviousMinute = DateTime.now().add(Duration(seconds: -1)).minute;
      var currentMinute = DateTime.now().minute;
      if (perviousMinute != currentMinute)
        setState(() {
          _newFormattedHour = DateFormat('HH:mm').format(DateTime.now());
        });
    });
  }

  @override
  void dispose() {
    this.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String newFormattedDate = formattedDate.format(now);

    return Container(
      width: 300,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFedd0c2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _newFormattedHour,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF301d0f),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text("$newFormattedDate",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF1b002e))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
