import 'dart:convert';

import 'package:JumpIn/core/network/service_people_profile.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VibeMeterPeople extends StatefulWidget {
  const VibeMeterPeople({Key key, @required this.userid}) : super(key: key);
  final String userid;

  @override
  _VibeMeterPeopleState createState() => _VibeMeterPeopleState();
}

class _VibeMeterPeopleState extends State<VibeMeterPeople> {
  List vibeForPeople = [];
  double val;
  @override
  initState() {
    vibeForPeople = jsonDecode(sharedPrefs.getVibeWithPeopleList);
    val = vibeForPeople[vibeForPeople.indexWhere(
        (element) => element["peopleId"] == widget.userid)]["peopleVibe"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      child: LiquidCircularProgressIndicator(
        value: val / 100, // Defaults to 0.5.
        valueColor: AlwaysStoppedAnimation(
            Colors.blue[300]), // Defaults to the current Theme's accentColor.
        backgroundColor:
            Colors.white, // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.blue[300],
        borderWidth: 2.0,
        direction: Axis
            .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
        center: Text(
          val.toInt().toString() + "%",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
