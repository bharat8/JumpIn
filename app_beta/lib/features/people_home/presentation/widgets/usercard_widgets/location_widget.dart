import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    Key key,
    @required this.distance,
  }) : super(key: key);

  final String distance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.height * 0.02,
          height: size.height * 0.02,
          child: Image.asset(
            "assets/images/SideNav/placeholder.png",
          ),
        ),
        Text(distance ?? "N/A",
            textScaleFactor: 1,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 3.7,
                fontWeight: FontWeight.bold))
      ],
    );
  }
}
