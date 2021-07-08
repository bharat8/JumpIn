import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BottomRightInterest extends StatelessWidget {
  const BottomRightInterest({
    Key key,
    @required this.user,
  }) : super(key: key);

  final JumpinUser user;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0,
        bottom: 0,
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: -10,
            surfaceIntensity: 0.5,
            lightSource: LightSource.top,
            intensity: 1,
            color: Colors.cyan[800],
          ),
          child: Container(
            height: getScreenSize(context).height * 0.15,
            width: getScreenSize(context).width * 0.26,
            padding: EdgeInsets.all(getScreenSize(context).height * 0.015),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: ImageIcon(
                          const AssetImage(
                              'assets/images/Home/interest_home.png'),
                          size: SizeConfig.blockSizeHorizontal * 8,
                          color: Colors.white.withOpacity(0.9),
                        )),
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                          user.interestList[0].toString() +
                              '\n' +
                              user.interestList[1].toString(),
                          textScaleFactor: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ]),
          ),
        )
        // child: Container(
        //   decoration: BoxDecoration(boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey,
        //       offset: Offset(6, 2),
        //       blurRadius: 10,
        //     )
        //   ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        //   child: SizedBox(
        //     height: getScreenSize(context).height * 0.15,
        //     width: getScreenSize(context).width * 0.26,
        //     child: Card(
        //       shape:
        //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //       shadowColor: Colors.black,
        //       elevation: 2.0,
        //       child: Container(
        //         padding: const EdgeInsets.all(5),
        //         decoration: BoxDecoration(
        //             border: Border.all(width: 1.0, color: Colors.black26),
        //             borderRadius: BorderRadius.circular(10)),
        // child: Column(
        //   children: [
        //     Expanded(
        //       flex: 5,
        //       child: Align(
        //           alignment: Alignment.topRight,
        //           child: ImageIcon(
        //               const AssetImage(
        //                   'assets/images/Home/interest_home.png'),
        //               size: SizeConfig.blockSizeHorizontal * 9)),
        //     ),
        //     Expanded(
        //       flex: 5,
        //       child: Align(
        //           alignment: Alignment.bottomRight,
        //           child: Text(
        //               user.interestList[0].toString() +
        //                   ',' +
        //                   user.interestList[1].toString(),
        //               style: TextStyle(
        //                   fontSize: SizeConfig.blockSizeHorizontal * 2.5,
        //                   fontFamily: font2semibold,
        //                   fontWeight: FontWeight.w500))),
        //     ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
