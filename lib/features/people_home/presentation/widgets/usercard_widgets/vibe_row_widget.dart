import 'package:JumpIn/core/network/service_people_profile.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/plans_home/data/model_plan.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VibeRowWidget extends StatelessWidget {
  const VibeRowWidget({
    Key key,
    this.from,
    this.user,
    this.plan,
    @required this.vibeWithUser,
  }) : super(key: key);

  final JumpinUser user;
  final String from;
  final Plan plan;
  final double vibeWithUser;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.height * 0.065,
          height: size.height * 0.065,
          child: LiquidCircularProgressIndicator(
            value: vibeWithUser / 100, // Defaults to 0.5.
            valueColor: AlwaysStoppedAnimation(Colors
                .blue[300]), // Defaults to the current Theme's accentColor.
            backgroundColor: Colors
                .white, // Defaults to the current Theme's backgroundColor.
            borderColor: Colors.blue[300],
            borderWidth: 2.0,
            direction: Axis
                .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
            center: Text(
              vibeWithUser.toInt().toString() + "%",
              textScaleFactor: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  " Vibe",
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      color: Colors.black.withOpacity(0.8)),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Meter",
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3.1,
                        color: Colors.black.withOpacity(0.8)),
                  ),
                ))
          ],
        ),
      ],
    );
  }
}
