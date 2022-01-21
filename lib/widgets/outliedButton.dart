import 'dart:ui';

import 'package:flutter/material.dart';

class WidgOutlinedButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: outlinedButtom(),
    );
  }

  outlinedButtom() {
    return OutlinedButton(
      onPressed: () {},
      child: Text("title"),
    );
  }
}
