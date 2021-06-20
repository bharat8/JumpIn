import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_notifications/data/entity_notfication.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PeopleAcceptedReqNotificationCard extends StatelessWidget {
  const PeopleAcceptedReqNotificationCard(
      {Key key, @required this.user, @required this.notificationSideColor})
      : super(key: key);
  final PeopleNotificationEntity user;
  final Color notificationSideColor;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String timeElapsed = Utils.calculateTimeElapsed(user.timestamp.toDate());
    return Container(
      height: SizeConfig.blockSizeVertical * 18,
      width: getScreenSize(context).width,
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 1,
          vertical: SizeConfig.blockSizeVertical * 1),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              child: Container(
                width: constraints.maxWidth * 0.35,
                color: Colors.lightBlue[100],
                child: Row(
                  children: [
                    Container(
                      width: (constraints.maxWidth * 0.35) * 0.05,
                      color: notificationSideColor,
                    ),
                    Neumorphic(
                      margin: EdgeInsets.only(
                          left: (constraints.maxWidth * 0.35) * 0.125),
                      // margin: EdgeInsets.all(SizeConfig.blockSizeVertical * 3),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(2000)),
                        depth: -10,
                        surfaceIntensity: 0.9,
                        lightSource: LightSource.top,
                        intensity: 1,
                      ),
                      child: CircleAvatar(
                          radius: (constraints.maxWidth * 0.35) * 0.35,
                          backgroundImage: NetworkImage(user.avatarImageUrl)),
                    )
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              child: Container(
                width: constraints.maxWidth * 0.65,
                color: Colors.lightBlue[50],
                padding: EdgeInsets.fromLTRB(
                    constraints.maxHeight * 0.05,
                    constraints.maxHeight * 0.04,
                    constraints.maxHeight * 0.05,
                    0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                        maxLines: 2,
                        text: TextSpan(
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                            ),
                            children: [
                              TextSpan(
                                  text: "@${user.fullname}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsJumpin.kSecondaryColor)),
                              TextSpan(
                                  text: " has",
                                  style: TextStyle(
                                      color: ColorsJumpin.kSecondaryColor)),
                              TextSpan(
                                  text: " accepted",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsJumpin.kSecondaryColor)),
                              TextSpan(
                                  text: " your connection request",
                                  style: TextStyle(
                                      color: ColorsJumpin.kSecondaryColor))
                            ])),
                    Container(
                      margin: EdgeInsets.all(3),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.white,
                        elevation: 10,
                        onPressed: () {
                          ConnectionUser cu = ConnectionUser(
                              id: user.id,
                              username: user.username,
                              fullname: user.fullname,
                              avatarImageUrl: user.avatarImageUrl);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PeopleConversationScreen(
                                connectionUser: cu,
                                navigatorRoute: "notification",
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: Text(
                            'Start a Conversation',
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
    return Container(
      height: SizeConfig.blockSizeVertical * 21,
      width: getScreenSize(context).width,
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      color: ColorsJumpin.kPrimaryColorLite,
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user.avatarImageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            margin: const EdgeInsets.all(7),
            color: ColorsJumpin.kPrimaryColorLite,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              fontFamily: font1),
                          children: [
                            TextSpan(
                                text: "@${user.fullname}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorsJumpin.kSecondaryColor)),
                            TextSpan(
                                text: " has",
                                style: TextStyle(
                                    color: ColorsJumpin.kSecondaryColor)),
                            TextSpan(
                                text: " accepted",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorsJumpin.kSecondaryColor)),
                            TextSpan(
                                text: " your connection request",
                                style: TextStyle(
                                    color: ColorsJumpin.kSecondaryColor))
                          ])),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeElapsed,
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Icon(Icons.circle, color: Colors.red, size: 10),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.all(3),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.white,
                        elevation: 10,
                        onPressed: () {
                          ConnectionUser cu = ConnectionUser(
                              id: user.id,
                              username: user.username,
                              fullname: user.fullname,
                              avatarImageUrl: user.avatarImageUrl);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PeopleConversationScreen(
                                connectionUser: cu,
                                navigatorRoute: "notification",
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: Text(
                            'Start a Conversation',
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
