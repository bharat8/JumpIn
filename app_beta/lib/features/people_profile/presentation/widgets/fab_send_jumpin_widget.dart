import 'package:JumpIn/core/utils/file_sharing.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_notifications/domain/notification_service.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../domain/people_profile_controller.dart';

class FABSendJumpin extends StatefulWidget {
  final String source;
  const FABSendJumpin({Key key, this.source}) : super(key: key);
  @override
  _FABSendJumpinState createState() => _FABSendJumpinState();
}

class _FABSendJumpinState extends State<FABSendJumpin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final prov = Provider.of<ServicePeopleProfileController>(context);
    final controller = Provider.of<ServiceJumpinPeopleHome>(context);
    return prov.getLoadingStatus == false
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Container(
              width: getScreenSize(context).width,
              height: SizeConfig.blockSizeVertical * 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (sharedPrefs.userid != prov.user.id)
                    Container(
                        width: getScreenSize(context).width * 0.38,
                        child: controller.currentUserRequestingUserids
                                    .contains(prov.user.id) ==
                                false
                            ? widget.source == "connection"
                                ? NeumorphicButton(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    style: NeumorphicStyle(
                                      depth: 10,
                                      intensity: 0.5,
                                      border: NeumorphicBorder(
                                          width: 1,
                                          color: Colors.black.withOpacity(0.6)),
                                      boxShape: NeumorphicBoxShape.stadium(),
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PeopleConversationScreen(
                                            connectionUser: prov.connectionUser,
                                            navigatorRoute: widget.source,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Icon(Icons.near_me_sharp,
                                              size: SizeConfig
                                                      .blockSizeHorizontal *
                                                  5,
                                              color:
                                                  Colors.blue.withOpacity(0.8)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text('Message',
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      3.3,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                                      .withOpacity(0.8))),
                                        )
                                      ],
                                    ))
                                : controller.jumpinReqProcessing == false
                                    ? NeumorphicButton(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        style: NeumorphicStyle(
                                          depth: controller.listOfAllReqUserSent
                                                  .contains(
                                                      prov.connectionUser.id)
                                              ? -10
                                              : 10,
                                          intensity: 0.8,
                                          surfaceIntensity: controller
                                                  .listOfAllReqUserSent
                                                  .contains(
                                                      prov.connectionUser.id)
                                              ? 0.9
                                              : 0.1,
                                          border: controller
                                                  .listOfAllReqUserSent
                                                  .contains(
                                                      prov.connectionUser.id)
                                              ? NeumorphicBorder.none()
                                              : NeumorphicBorder(
                                                  width: 1,
                                                  color: Colors.black
                                                      .withOpacity(0.6)),
                                          boxShape:
                                              NeumorphicBoxShape.stadium(),
                                          shape: NeumorphicShape.convex,
                                          color: controller.listOfAllReqUserSent
                                                  .contains(
                                                      prov.connectionUser.id)
                                              ? Colors.blue.withOpacity(0.8)
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          prov.acceptCancelJumpinRequest(
                                              controller, context);
                                        },
                                        child: Row(
                                          children: [
                                            ImageIcon(
                                                const AssetImage(
                                                    'assets/images/Onboarding/logo_final.png'),
                                                size: SizeConfig
                                                        .blockSizeHorizontal *
                                                    8,
                                                color: controller
                                                        .listOfAllReqUserSent
                                                        .contains(prov
                                                            .connectionUser.id)
                                                    ? Colors.white
                                                    : Colors.black
                                                        .withOpacity(0.8)),
                                            Text('JumpIn',
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .blockSizeHorizontal *
                                                        3.3,
                                                    fontWeight: FontWeight.w500,
                                                    color: controller
                                                            .listOfAllReqUserSent
                                                            .contains(prov
                                                                .connectionUser
                                                                .id)
                                                        ? Colors.white
                                                        : Colors.black
                                                            .withOpacity(0.8)))
                                          ],
                                        ))
                                    : Center(
                                        child: SpinKitThreeBounce(
                                        color: Colors.blue[300],
                                        size: SizeConfig.blockSizeVertical * 3,
                                      ))
                            : (controller.getLoadingStatusAfterAcceptReject ==
                                    false
                                ? (controller.getAcceptedList
                                        .contains(prov.user.id)
                                    ? NeumorphicButton(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        style: NeumorphicStyle(
                                          depth: 10,
                                          intensity: 0.5,
                                          border: NeumorphicBorder(
                                              width: 1,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          boxShape:
                                              NeumorphicBoxShape.stadium(),
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          ConnectionUser cu = ConnectionUser(
                                              id: prov.user.id,
                                              username: prov.user.username,
                                              fullname: prov.user.fullname,
                                              timestamp: Timestamp.now(),
                                              avatarImageUrl:
                                                  prov.user.photoUrl);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PeopleConversationScreen(
                                                connectionUser: cu,
                                                navigatorRoute: "connection",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Icon(Icons.near_me_sharp,
                                                  size: SizeConfig
                                                          .blockSizeHorizontal *
                                                      5,
                                                  color: Colors.blue
                                                      .withOpacity(0.8)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text('Message',
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .blockSizeHorizontal *
                                                          3.3,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black
                                                          .withOpacity(0.8))),
                                            )
                                          ],
                                        ))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                            InkWell(
                                                onTap: () async {
                                                  controller
                                                          .setLoadingStatusAfterAcceptReject =
                                                      true;
                                                  ConnectionUser cu =
                                                      ConnectionUser(
                                                          id: prov.user.id,
                                                          username: prov
                                                              .user.username,
                                                          fullname: prov
                                                              .user.fullname,
                                                          timestamp:
                                                              Timestamp.now(),
                                                          avatarImageUrl: prov
                                                              .user.photoUrl);
                                                  await NotificationService
                                                      .acceptJumpinRequestFromNotification(
                                                          cu, context);
                                                  controller.addAccepted(
                                                      prov.user.id);
                                                  controller
                                                          .setLoadingStatusAfterAcceptReject =
                                                      false;
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(Icons.check,
                                                        color: Colors.white,
                                                        size: SizeConfig
                                                                .blockSizeHorizontal *
                                                            4),
                                                  ),
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  controller
                                                          .setLoadingStatusAfterAcceptReject =
                                                      true;
                                                  ConnectionUser cu =
                                                      ConnectionUser(
                                                          id: prov.user.id,
                                                          username: prov
                                                              .user.username,
                                                          fullname: prov
                                                              .user.fullname,
                                                          timestamp:
                                                              Timestamp.now(),
                                                          avatarImageUrl: prov
                                                              .user.photoUrl);
                                                  await NotificationService
                                                      .rejectJumpinRequestFromNotification(
                                                          cu, context);
                                                  controller.removeCurrentReqId(
                                                      prov.user.id);
                                                  controller
                                                          .setLoadingStatusAfterAcceptReject =
                                                      false;
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(Icons.close,
                                                        color: Colors.white,
                                                        size: SizeConfig
                                                                .blockSizeHorizontal *
                                                            4),
                                                  ),
                                                )),
                                          ]))
                                : Center(
                                    child: SpinKitThreeBounce(
                                    color: Colors.blue[300],
                                    size: SizeConfig.blockSizeVertical * 3,
                                  )))),
                  Container(
                    width: getScreenSize(context).width * 0.45,
                    child: NeumorphicButton(
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        style: NeumorphicStyle(
                          depth: 10,
                          intensity: 0.5,
                          border: NeumorphicBorder(
                              width: 1, color: Colors.black.withOpacity(0.6)),
                          boxShape: NeumorphicBoxShape.stadium(),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          urlFileShare(
                              context, prov.user.username, prov.user.id);
                        },
                        child: Row(
                          children: [
                            ImageIcon(
                                const AssetImage(
                                    'assets/images/Home/refer_icon.png'),
                                size: SizeConfig.blockSizeHorizontal * 8,
                                color: Colors.black.withOpacity(0.8)),
                            Text('Recommend',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3.3,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.8)))
                          ],
                        )),
                  ),
                  if (sharedPrefs.userid != prov.user.id)
                    Container(
                      width: getScreenSize(context).width * 0.17,
                      child: NeumorphicButton(
                        style: NeumorphicStyle(
                          depth: prov.getBookmarksStatus == true ? -10 : 10,
                          intensity: 0.8,
                          border: prov.getBookmarksStatus == false
                              ? NeumorphicBorder(
                                  width: 1,
                                  color: Colors.black.withOpacity(0.9))
                              : NeumorphicBorder.none(),
                          boxShape: NeumorphicBoxShape.circle(),
                          surfaceIntensity: 0.4,
                          shape: NeumorphicShape.convex,
                          color: prov.getBookmarksStatus == true
                              ? Colors.blue.withOpacity(0.7)
                              : Colors.white,
                        ),
                        onPressed: () {
                          prov.addRemoveBookmarks(prov.user, context);
                        },
                        padding:
                            EdgeInsets.all(getScreenSize(context).width * 0.04),
                        child: NeumorphicIcon(
                          Icons.bookmark_border,
                          style: NeumorphicStyle(
                              color: prov.getBookmarksStatus == true
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        : Center(
            child: circularProgressIndicator(),
          );
  }
}
