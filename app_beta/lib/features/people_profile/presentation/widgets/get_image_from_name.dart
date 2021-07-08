import 'dart:math';

import 'package:flutter/material.dart';

class GetImageFromName extends StatefulWidget {
  final String name;

  const GetImageFromName({Key key, this.name}) : super(key: key);

  @override
  _GetImageFromNameState createState() => _GetImageFromNameState();
}

class _GetImageFromNameState extends State<GetImageFromName> {
  List<MaterialColor> randomColors = [
    Colors.amber,
    Colors.blue,
    Colors.blueGrey,
    Colors.brown,
    Colors.cyan,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.green,
    Colors.indigo,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.lime,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.yellow
  ];

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.height * 0.12,
      height: size.height * 0.12,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          color: randomColors[random.nextInt(18)]),
      child: Center(
          child: Text(
        widget.name[0],
        style: TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.03,
            fontWeight: FontWeight.w800),
      )),
    );
  }
}
