import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container linearProgressIndicator() {
  return Container(
      alignment: Alignment.topCenter,
      child: const LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(ColorsJumpin.kPrimaryColor),
      ));
}

Container circularProgressIndicator() {
  return Container(
    alignment: Alignment.center,
    child:
        // Lottie.asset(
        //   'assets/animations/loading-blue-wave-ball.json',
        //   repeat: true,
        //   reverse: true,
        //   animate: true,
        // )
        const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(ColorsJumpin.kPrimaryColor),
    ),
  );
}
