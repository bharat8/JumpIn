import 'package:flutter/material.dart';

import 'package:JumpIn/core/constants/constants.dart';

class HandleLandscapeChange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsJumpin.kPrimaryColor,
      body: Center(
        child: Text("Rotate Your Screen to be in Potrait Mode",
            style: TextStyle(
              fontFamily: font1,
              fontSize: 20,
              color: Colors.white,
            )),
      ),
    );
  }
}
