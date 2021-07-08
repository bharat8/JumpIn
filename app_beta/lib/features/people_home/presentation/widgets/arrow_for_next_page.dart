import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';

class ArrowForNextPage extends StatelessWidget {
  const ArrowForNextPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Align(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, rPlanHome, (Route<dynamic> route) => false);
          },
          child: Container(
            child: Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded,
                    size: SizeConfig.blockSizeHorizontal * 5),
                Text("Navigate To Plan's Screen",
                    style:
                        TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5))
              ],
            ),
          ))
    ]));
  }
}
