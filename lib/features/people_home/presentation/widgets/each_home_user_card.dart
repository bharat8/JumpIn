import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:JumpIn/core/utils/file_sharing.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/bottom_left_mutual_friend.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/bottom_right_interest.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/center_image.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/jumpin_req_proessing.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/location_widget.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/recommend.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/top_right_work_study.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/topleft_age_gender.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/usernamewidget.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/usercard_widgets/vibe_row_widget.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../screen_people_home.dart';

bool _isReqSent;
bool _isReqReceived;

class EachHomeUserCard extends StatefulWidget {
  const EachHomeUserCard({
    Key key,
    @required this.user,
    @required this.parentContext,
    @required this.requestReceived,
    @required this.vibeWithUser,
  }) : super(key: key);

  final JumpinUser user;
  final BuildContext parentContext;
  final bool requestReceived;
  final double vibeWithUser;

  @override
  _EachHomeUserCardState createState() => _EachHomeUserCardState();
}

class _EachHomeUserCardState extends State<EachHomeUserCard> {
  GlobalKey _globalKey = GlobalKey();
  double dist_double;

  @override
  void initState() {
    super.initState();
    sharedPrefs.myPendingConnectionListasString ??= jsonEncode([]);
  }

  Future<String> calcDistance() async {
    if (await Permission.location.isGranted ||
        await Permission.location.isLimited) {
      dist_double = LocationUtils.getDistance(
              widget.user.geoPoint.latitude.toDouble(),
              widget.user.geoPoint.longitude.toDouble())
          .toDouble();
      if (dist_double == null) {
        return "loading...";
      } else if (dist_double == 0.0) {
        return "N/A";
      } else {
        return "${dist_double.toStringAsFixed(1)} km";
      }
    } else {
      return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenProv = Provider.of<ServiceJumpinPeopleHome>(context);
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: calcDistance(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return circularProgressIndicator();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //username
                                  UserNameWidget(user: widget.user),
                                  //location
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child:
                                        LocationWidget(distance: snapshot.data),
                                  ),
                                ],
                              ),
                            ),
                            //vibe meter
                            VibeRowWidget(
                              user: widget.user,
                              from: "people",
                              vibeWithUser: widget.vibeWithUser,
                            )
                          ]),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text("Tap To Know More",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3))),
                      ),
                      //inner card- container1 for grey shadow background,container2 for stack elements
                      GestureDetector(
                        onTap: () {
                          String userid = widget.user.id;
                          String source = "peopleHome";
                          Navigator.pushNamed(context, rPeopleProfile,
                              arguments: [userid, source]);
                          homeScreenProv.capturePng(widget.user.id, _globalKey);
                        },
                        child: Container(
                          height: getScreenSize(context).height * 0.39,
                          width: getScreenSize(context).width * 0.72,
                          padding: EdgeInsets.all(
                              getScreenSize(context).height * 0.02),
                          decoration: BoxDecoration(
                              color: Colors.cyan[50].withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              TopLeftAgeGender(user: widget.user),
                              TopRightWorkStudy(user: widget.user),
                              BottomRightInterest(user: widget.user),
                              BottomLeftMutualFriend(user: widget.user),
                              CenterImage(user: widget.user),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JumpinReqProcessingCard(
                        user: widget.user, parentContext: widget.parentContext),
                    NeumorphicButton(
                      style: NeumorphicStyle(
                        depth: 10,
                        intensity: 0.7,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(5)),
                        color: Colors.grey[50],
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        homeScreenProv.capturePng(widget.user.id, _globalKey);
                        urlFileShare(
                            context, widget.user.username, widget.user.id);
                      },
                      child: Container(
                          height: size.height * 0.05,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageIcon(
                                    const AssetImage(
                                        'assets/images/Home/refer_icon.png'),
                                    size: size.height * 0.035),
                                Text('Recommend',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontFamily: 'TrebuchetMS',
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.018))
                              ])),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
