import 'package:JumpIn/core/utils/home_placeholder_provider.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_notifications/domain/notification_service.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class JumpinReqProcessingCard extends StatelessWidget {
  const JumpinReqProcessingCard({
    @required this.parentContext,
    @required this.user,
    Key key,
  }) : super(key: key);

  final BuildContext parentContext;
  final JumpinUser user;

  @override
  Widget build(BuildContext context) {
    //if the list is not initialized or null ,intialize with empty string list
    final controller = Provider.of<ServiceJumpinPeopleHome>(context);
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    print(controller.listOfAllReqUserSent);
    return controller.currentUserRequestingUserids.contains(user.id) == true
        ? (controller.getLoadingStatusAfterAcceptReject == false
            ? (controller.getAcceptedList.contains(user.id)
                ? NeumorphicButton(
                    style: NeumorphicStyle(
                      depth: 10,
                      intensity: 0.7,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(5)),
                      color: controller.listOfAllReqUserSent.contains(user.id)
                          ? ColorsJumpin.kPrimaryColor
                          : Colors.grey[50],
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      ConnectionUser cu = ConnectionUser(
                          id: user.id,
                          username: user.username,
                          fullname: user.fullname,
                          timestamp: Timestamp.now(),
                          avatarImageUrl: user.photoUrl);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PeopleConversationScreen(
                            connectionUser: cu,
                            navigatorRoute: "connection",
                          ),
                        ),
                      );
                    },
                    child: Container(
                        height: size.height * 0.05,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.near_me_sharp,
                                size: SizeConfig.blockSizeHorizontal * 5,
                                color: Colors.blue.withOpacity(0.8)),
                            Padding(
                              padding: EdgeInsets.only(left: size.width * 0.02),
                              child: Text('Message',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontFamily: font1,
                                      color: controller.listOfAllReqUserSent
                                              .contains(user.id)
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: size.height * 0.018,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ))),
                  )
                : Row(children: [
                    InkWell(
                        onTap: () async {
                          controller.setLoadingStatusAfterAcceptReject = true;
                          ConnectionUser cu = ConnectionUser(
                              id: user.id,
                              username: user.username,
                              fullname: user.fullname,
                              timestamp: Timestamp.now(),
                              avatarImageUrl: user.photoUrl);
                          await NotificationService
                              .acceptJumpinRequestFromNotification(cu, context);
                          controller.addAccepted(user.id);
                          controller.setLoadingStatusAfterAcceptReject = false;
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.check,
                                color: Colors.white,
                                size: SizeConfig.blockSizeHorizontal * 4),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.02),
                      child: InkWell(
                          onTap: () async {
                            controller.setLoadingStatusAfterAcceptReject = true;
                            ConnectionUser cu = ConnectionUser(
                                id: user.id,
                                username: user.username,
                                fullname: user.fullname,
                                timestamp: Timestamp.now(),
                                avatarImageUrl: user.photoUrl);
                            await NotificationService
                                .rejectJumpinRequestFromNotification(
                                    cu, context);
                            controller.removeCurrentReqId(user.id);
                            controller.setLoadingStatusAfterAcceptReject =
                                false;
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.close,
                                  color: Colors.white,
                                  size: SizeConfig.blockSizeHorizontal * 4),
                            ),
                          )),
                    ),
                  ]))
            : Center(
                child: SpinKitThreeBounce(
                color: Colors.blue[300],
                size: SizeConfig.blockSizeVertical * 3,
              )))
        : NeumorphicButton(
            style: NeumorphicStyle(
              depth: 10,
              intensity: 0.7,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
              color: controller.listOfAllReqUserSent.contains(user.id)
                  ? ColorsJumpin.kPrimaryColor
                  : Colors.grey[50],
            ),
            padding: EdgeInsets.zero,
            onPressed: () {
              controller.changeReqProcessingStatus(true);
              ConnectionUser cu = ConnectionUser(
                  id: user.id,
                  username: user.username,
                  fullname: user.fullname,
                  avatarImageUrl: user.photoUrl);

              if (controller.listOfAllReqUserSent.contains(user.id)) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Undo Request",
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        content: Text(
                            "Are you sure you want to cancel the connection request ?",
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16)),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffe6ecf2),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 10),
                              child: Text(
                                "Cancel",
                                textScaleFactor: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => controller
                                .undoConnectionRequest(cu, context)
                                .then(
                                  (_) => Navigator.of(context).pop(),
                                ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 10),
                              child: Text(
                                "Confirm",
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                controller.sendConnectionRequest(cu, context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pop(true);
                      });
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Lottie.asset('assets/animations/success.json',
                            repeat: false, animate: true),
                      );
                    });
              }
            },
            child: Container(
                height: size.height * 0.05,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: GestureDetector(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/images/Onboarding/logo_final.png",
                        height: size.height * 0.027),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.02),
                      child: Text('JumpIn',
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontFamily: font1,
                              color: controller.listOfAllReqUserSent
                                      .contains(user.id)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: size.height * 0.018,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ))),
          );
  }
}
