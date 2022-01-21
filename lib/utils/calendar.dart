import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var _calendarController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Calendario",
          style: TextStyle(
              color: Color(0xFFa98f78),
              fontWeight: FontWeight.w400,
              fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
      body: body(),
    );
  }

  body() {
    return TableCalendar(
        locale: 'pt_BR', calendarController: _calendarController);
  }
}
