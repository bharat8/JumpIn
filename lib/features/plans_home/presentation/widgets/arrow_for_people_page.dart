import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';

class ArrowForPeoplePage extends StatelessWidget {
  const ArrowForPeoplePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, rHomePlaceHolder, (Route<dynamic> route) => false);
          },
          child: Container(
            margin: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded, size: 20),
                Text("Navigate To People's screen", style: TextStyle())
              ],
            ),
          ))
    ]));
  }
}
