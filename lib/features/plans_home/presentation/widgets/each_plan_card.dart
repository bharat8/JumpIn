import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/vibe_row_widget.dart';
import 'package:JumpIn/features/plans_home/data/model_plan.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/event_name_n_location.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/innercard1.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/plans_bookmark.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/recommend_plans.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';

class EachPlanCard extends StatelessWidget {
  const EachPlanCard({
    Key key,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, rPlanProfile);
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        height: height * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: offWhite),
        child: Column(
          children: [
            Row(
              children: [
                const EventNameNLocation(),
                //VibeRowWidget(plan: Plan(), from: "plan"),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 3),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("Tap To Know More",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 3))),
            ),
            InnerCardMain(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    color: offWhite,
                    elevation: 10,
                    onPressed: () {},
                    child: Text('Jumpin')),
                RecommendButton(),
                BookMark(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
