import 'dart:math';

import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/features/user_notifications/presentation/widgets/i_accepted_req_notification_card.dart';
import 'package:JumpIn/features/user_notifications/presentation/widgets/notification_jumpin_appbar.dart';
import 'package:JumpIn/features/user_notifications/presentation/widgets/people_accepted_req_notification_card.dart';
import 'package:JumpIn/features/user_notifications/presentation/widgets/people_pending_req_notification_card.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/entity_notfication.dart';
import '../../domain/notification_service.dart';

class ScreenJumpinNotifications extends StatefulWidget {
  @override
  _ScreenJumpinNotificationsState createState() =>
      _ScreenJumpinNotificationsState();
}

class _ScreenJumpinNotificationsState extends State<ScreenJumpinNotifications> {
  ConnectionChecker cc = ConnectionChecker();

  @override
  void initState() {
    cc.checkConnection(context);
    if (sharedPrefs.myPendingNotification != null)
      sharedPrefs.myNotificationCount += sharedPrefs.myPendingNotification;
    sharedPrefs.myPendingNotification = 0;
    super.initState();
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  List<Color> notificationColors = [
    Color(0xffff8880),
    Color(0xffffc680),
    Color(0xff6cba79),
    Color(0xff80a4ff),
    Color(0xff9980ff),
    Color(0xffff80d3),
    Color(0xffff8097),
  ];
  var rand = Random();
  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);
    return WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: NotificationJumpinAppBar(context, "jUMPIN"),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Notifications")
                  .doc(sharedPrefs.userid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData || !snapshot.data.exists) {
                  return const Center(child: Text('No New Notification'));
                }
                List<PeopleNotificationEntity> peopleNotificationList = [];
                snapshot.data["peopleNotification"].forEach((cu) {
                  print(cu);
                  peopleNotificationList.add(PeopleNotificationEntity.fromJson(
                      cu as Map<String, dynamic>));
                });
                peopleNotificationList =
                    List.from(peopleNotificationList.reversed);
                return Column(
                  children: [
                    Expanded(
                      child: peopleNotificationList.isEmpty
                          ? const Center(child: Text('No New Notification'))
                          : ListView.builder(
                              itemCount: peopleNotificationList.length,
                              itemBuilder: (context, index) {
                                if (peopleNotificationList[index].type ==
                                    PeopleNotificationEntity
                                        .typeConnectionRequestAccepted) {
                                  return PeopleAcceptedReqNotificationCard(
                                    user: peopleNotificationList[index],
                                    notificationSideColor:
                                        notificationColors[rand.nextInt(7)],
                                  );
                                }
                                if (peopleNotificationList[index].type ==
                                    PeopleNotificationEntity
                                        .typeConnectionRequestAcceptedByMe) {
                                  return IAcceptedReqNotificationCard(
                                      user: peopleNotificationList[index],
                                      notificationSideColor:
                                          notificationColors[rand.nextInt(7)]);
                                }
                                return PeoplePendingReqNotificationCard(
                                    user: peopleNotificationList[index],
                                    notificationSideColor:
                                        notificationColors[rand.nextInt(7)]);
                              }),
                    ),
                  ],
                );
              }),
        ));
  }
}
