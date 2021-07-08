import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';

class TopLeftAgeGender extends StatefulWidget {
  const TopLeftAgeGender({
    Key key,
    @required this.user,
  }) : super(key: key);

  final JumpinUser user;

  @override
  _TopLeftAgeGenderState createState() => _TopLeftAgeGenderState();
}

class _TopLeftAgeGenderState extends State<TopLeftAgeGender> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
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
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Utils.calculateAge(widget.user.dob.toDate())
                                .toString() +
                            " Years",
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.user.gender.toUpperCase(),
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontFamily: font2semibold,
                            fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ImageIcon(
                      widget.user.gender == 'female'
                          ? AssetImage('assets/images/Home/female_black.png')
                          : AssetImage('assets/images/Home/male_blue.png'),
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
      //     child: Padding(
      //       padding: const EdgeInsets.all(1.0),
      //       child: Card(
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10)),
      //         shadowColor: Colors.black,
      //         elevation: 2.0,
      //         child: Container(
      //           padding: const EdgeInsets.all(3),
      //           decoration: BoxDecoration(
      //               border: Border.all(width: 1.0, color: Colors.black26),
      //               borderRadius: BorderRadius.circular(10)),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               Expanded(
      //                 flex: 5,
      //                 child: Column(
      //                   children: [
      //                     Padding(
      //                         padding: const EdgeInsets.all(1),
      //                         child: Align(
      //                           alignment: Alignment.centerLeft,
      //                           child: AutoSizeText(
      //                             Utils.calculateAge(user.dob.toDate())
      //                                     .toString() +
      //                                 " Years",
      //                             style: TextStyle(
      //                                 fontFamily: font2semibold,
      //                                 fontSize:
      //                                     SizeConfig.blockSizeHorizontal * 3,
      //                                 fontWeight: FontWeight.w500),
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 1,
      //                           ),
      //                         )),
      //                     Padding(
      //                         padding: const EdgeInsets.all(1),
      //                         child: Align(
      //                           alignment: Alignment.centerLeft,
      //                           child: AutoSizeText(
      //                             user.gender.toUpperCase(),
      //                             style: TextStyle(
      //                                 fontFamily: font2semibold,
      //                                 fontSize:
      //                                     SizeConfig.blockSizeHorizontal * 3,
      //                                 fontWeight: FontWeight.w500),
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 2,
      //                           ),
      //                         ))
      //                   ],
      //                 ),
      //               ),
      //               //gendericon
      //               Expanded(
      //                 flex: 5,
      //                 child: Align(
      //                     alignment: Alignment.bottomLeft,
      //                     child: ImageIcon(
      //                       user.gender == 'female'
      //                           ? AssetImage(
      //                               'assets/images/Home/female_black.png')
      //                           : AssetImage(
      //                               'assets/images/Home/male_blue.png'),
      //                       size: SizeConfig.blockSizeHorizontal * 9,
      //                       color: Colors.black,
      //                     )),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
