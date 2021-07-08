import 'package:JumpIn/features/plans_home/presentation/widgets/each_plan_card.dart';
import 'package:flutter/material.dart';

class ListPlansCards extends StatelessWidget {
  const ListPlansCards({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.03),
      height: height * 0.5,
      width: width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          EachPlanCard(width: width, height: height),
          EachPlanCard(width: width, height: height),
          EachPlanCard(width: width, height: height)
        ],
      ),
    );
  }
}
