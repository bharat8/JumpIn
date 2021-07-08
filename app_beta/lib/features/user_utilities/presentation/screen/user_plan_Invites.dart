import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:flutter/material.dart';

class MyPlanInvites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: JumpinAppBar(context, 'Plan Invites'),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          "Coming very soon...",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: height * 0.023,
              fontWeight: FontWeight.w700),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.05, horizontal: width * 0.1),
          margin: EdgeInsets.symmetric(horizontal: width * 0.1),
          decoration: BoxDecoration(color: Colors.deepPurple[100], boxShadow: [
            BoxShadow(
                color: Colors.deepPurple[100],
                blurRadius: 20,
                offset: Offset(0, 3),
                spreadRadius: 2)
          ]),
          child: Text(
            "Join plans nearby for activities you love!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: height * 0.023,
              color: Colors.deepPurple[700],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.05, horizontal: width * 0.1),
          margin: EdgeInsets.symmetric(
              vertical: height * 0.025, horizontal: width * 0.1),
          decoration: BoxDecoration(color: Colors.cyan[200], boxShadow: [
            BoxShadow(
                color: Colors.cyan[200],
                blurRadius: 20,
                offset: Offset(0, 3),
                spreadRadius: 2)
          ]),
          child: Text(
            "Easily organise plans with friends by letting everyone vote!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: height * 0.023,
                color: Colors.cyan[800]),
          ),
        ),
      ]),
    );
  }
}
