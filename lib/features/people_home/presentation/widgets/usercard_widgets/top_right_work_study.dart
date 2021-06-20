import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/local_service.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TopRightWorkStudy extends StatelessWidget {
  const TopRightWorkStudy({
    Key key,
    @required this.user,
  }) : super(key: key);

  final JumpinUser user;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    decideStudyWork(user.placeOfWork, user.placeOfEdu),
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 2.8,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: ImageIcon(
                      user.placeOfWork.isEmpty
                          ? AssetImage('assets/images/Home/college.png')
                          : AssetImage('assets/images/Home/work.png'),
                      size: SizeConfig.blockSizeHorizontal * 8,
                      color: Colors.white.withOpacity(0.9),
                    )),
              )
            ],
          ),
        ),
      ),
      // child: Container(
      //   decoration: BoxDecoration(boxShadow: [
      //     const BoxShadow(
      //       color: Colors.grey,
      //       offset: Offset(6, 2),
      //       blurRadius: 10,
      //     )
      //   ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      //   child: SizedBox(
      //     height: getScreenSize(context).height * 0.15,
      //     width: getScreenSize(context).width * 0.26,
      //     child: Card(
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(10)),
      //       shadowColor: Colors.black,
      //       elevation: 2.0,
      //       child: Container(
      //         decoration: BoxDecoration(
      //             border: Border.all(width: 1.0, color: Colors.black26),
      //             borderRadius: BorderRadius.circular(10)),
      //         child: Padding(
      //           padding: const EdgeInsets.all(5.0),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Expanded(
      //       flex: 5,
      //       child: Align(
      //         alignment: Alignment.topRight,
      //         child: AutoSizeText(
      //           decideStudyWork(user.placeOfWork, user.placeOfEdu),
      //           style: TextStyle(
      //               fontSize: SizeConfig.blockSizeHorizontal * 3,
      //               fontFamily: font2semibold,
      //               fontWeight: FontWeight.w500),
      //           overflow: TextOverflow.ellipsis,
      //           maxLines: 2,
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       flex: 5,
      //       child: Align(
      //           alignment: Alignment.bottomRight,
      //           child: ImageIcon(
      //               user.placeOfWork.isEmpty
      //                   ? AssetImage(
      //                       'assets/images/Home/college.png')
      //                   : AssetImage('assets/images/Home/work.png'),
      //               size: SizeConfig.blockSizeHorizontal * 9)),
      //     )
      //   ],
      // ),
      //         ),
      //       ),
      //     ),
      //   ),
      // )
    );
  }
}
