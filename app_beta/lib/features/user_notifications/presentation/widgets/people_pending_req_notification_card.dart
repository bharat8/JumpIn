import 'package:JumpIn/features/user_notifications/data/entity_notfication.dart';
import 'package:JumpIn/features/user_notifications/domain/notification_service.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PeoplePendingReqNotificationCard extends StatelessWidget {
  const PeoplePendingReqNotificationCard(
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
                    Container(
                      width: (constraints.maxWidth * 0.35) * 0.95,
                      child: CircleAvatar(
                        radius: (constraints.maxWidth * 0.35) * 0.35,
                        backgroundImage: NetworkImage(user.avatarImageUrl),
                      ),
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
                                  text: " sent",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsJumpin.kSecondaryColor)),
                              TextSpan(
                                  text: " you connection request",
                                  style: TextStyle(
                                      color: ColorsJumpin.kSecondaryColor))
                            ])),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          margin: EdgeInsets.all(3),
                          padding: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.white,
                            elevation: 10,
                            onPressed: () async {
                              ConnectionUser cu = ConnectionUser(
                                  id: user.id,
                                  username: user.username,
                                  fullname: user.fullname,
                                  timestamp: Timestamp.now(),
                                  avatarImageUrl: user.avatarImageUrl);
                              await NotificationService
                                  .acceptJumpinRequestFromNotification(
                                      cu, context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 3.0),
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3),
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          onPressed: () async {
                            ConnectionUser cu = ConnectionUser(
                                id: user.id,
                                username: user.username,
                                fullname: user.fullname,
                                avatarImageUrl: user.avatarImageUrl);

                            await NotificationService
                                .rejectJumpinRequestFromNotification(
                                    cu, context);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 3.0, bottom: 3.0),
                            child: Text('Reject',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3)),
                          ),
                        ),
                      ],
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
                                text: " sent",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorsJumpin.kSecondaryColor)),
                            TextSpan(
                                text: " you connection request",
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
                        onPressed: () async {
                          ConnectionUser cu = ConnectionUser(
                              id: user.id,
                              username: user.username,
                              fullname: user.fullname,
                              timestamp: Timestamp.now(),
                              avatarImageUrl: user.avatarImageUrl);
                          await NotificationService
                              .acceptJumpinRequestFromNotification(cu, context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: Text(
                            'Accept',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.white,
                      elevation: 10,
                      onPressed: () async {
                        ConnectionUser cu = ConnectionUser(
                            id: user.id,
                            username: user.username,
                            fullname: user.fullname,
                            avatarImageUrl: user.avatarImageUrl);

                        await NotificationService
                            .rejectJumpinRequestFromNotification(cu, context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                        child: Text('Reject',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: SizeConfig.blockSizeHorizontal * 3)),
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
