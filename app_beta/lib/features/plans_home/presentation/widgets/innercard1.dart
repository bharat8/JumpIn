import 'package:JumpIn/features/plans_home/presentation/widgets/bottomleft_peoplejoining.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/bottomright_spotleft.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/planimage.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/topleft_eventstartdate.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/topright_plantimings.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

double _height = 0.0;
double _width = 0.0;

class InnerCardMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _height = getScreenSize(context).height;
    _width = getScreenSize(context).width;
    return Container(
        height: getScreenSize(context).height * 0.39,
        width: getScreenSize(context).width * 0.72,
        decoration: BoxDecoration(
            color: ColorsJumpin.innerCardBackgroundGrey,
            borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: getScreenSize(context).height * 0.34,
          width: getScreenSize(context).width * 0.7,
          margin: const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
          decoration: BoxDecoration(
              color: ColorsJumpin.innerCardBackgroundGrey,
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              TopRightPlanTimings(
                planStartime: DateTime.now(),
                planEndTime: DateTime.now(),
              ),
              const SizedBox(height: 5),
              TopLeftEventStartDate(
                planStartMonth: 'June'.toUpperCase(),
                planStartdayOfMonth: 24,
                planStartyear: 2020,
              ),
              const BottomRightSpotLeft(
                totalSpot: 10,
                spotLeft: 2,
                iconImageURL: 'assets/images/Home/peopleBookedSpot.png',
              ),
              const BottomLeftPeopleAlsoJoining(
                  peoplejoining: ['Mudit', 'Shubham'],
                  icon: ImageIcon(
                      AssetImage('assets/images/Home/mutual_friend.png'))),
              const HomepagePlanImage()
            ],
          ),
        ));
  }
}
