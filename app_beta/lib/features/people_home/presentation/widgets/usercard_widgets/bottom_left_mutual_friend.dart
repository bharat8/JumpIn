import 'dart:convert';

import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class BottomLeftMutualFriend extends StatefulWidget {
  final JumpinUser user;
  BottomLeftMutualFriend({this.user});
  @override
  _BottomLeftMutualFriendState createState() => _BottomLeftMutualFriendState();
}

class _BottomLeftMutualFriendState extends State<BottomLeftMutualFriend> {
  int length = 0;

  @override
  void initState() {
    List list = jsonDecode(sharedPrefs.getMutualFriends);
    print(
        "888888888888888888888888888888888888888888888888888888888888888888888");
    print(list);
    int index = list.indexWhere((element) => element["id"] == widget.user.id);
    if (index == -1) {
      length = 0;
    } else {
      length = list[index]["length"];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenProv = Provider.of<ServiceJumpinPeopleHome>(context);
    return Positioned(
      bottom: 0,
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
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.topLeft,
                child: ImageIcon(
                    AssetImage('assets/images/Home/mutual_friend.png'),
                    size: SizeConfig.blockSizeHorizontal * 9,
                    color: Colors.white.withOpacity(0.9)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '${length}\nMutual Friends',
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: SizeConfig.blockSizeHorizontal * 2.9,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            )
          ]),
        ),
      ),
      // child: Container(
      //   padding: EdgeInsets.all(getScreenSize(context).height * 0.005),
      //   decoration: BoxDecoration(boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey,
      //       offset: Offset(6, 2),
      //       blurRadius: 10,
      //     )
      //   ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      //   child: SizedBox(
      // height: getScreenSize(context).height * 0.15,
      // width: getScreenSize(context).width * 0.26,
      //     child: Container(
      //       // padding: const EdgeInsets.all(5),
      //       decoration: BoxDecoration(
      //           border: Border.all(width: 1.0, color: Colors.black26),
      //           borderRadius: BorderRadius.circular(10)),
      //       child: Column(
      // mainAxisAlignment: MainAxisAlignment.end,
      // children: [
      //   Expanded(
      //     flex: 5,
      //     child: Align(
      //       alignment: Alignment.topLeft,
      //       child: ImageIcon(
      //           AssetImage('assets/images/Home/mutual_friend.png'),
      //           size: SizeConfig.blockSizeHorizontal * 9),
      //     ),
      //   ),
      //   Expanded(
      //     flex: 5,
      //     child: Align(
      //       alignment: Alignment.bottomLeft,
      //       child: AutoSizeText(
      //         '${mutualConnections.length} Mutual Friends',
      //         style: TextStyle(
      //             fontFamily: font2semibold,
      //             fontSize: SizeConfig.blockSizeHorizontal * 3,
      //             fontWeight: FontWeight.w500),
      //         overflow: TextOverflow.ellipsis,
      //         maxLines: 3,
      //       ),
      //     ),
      //   ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ));
    );
  }
}
