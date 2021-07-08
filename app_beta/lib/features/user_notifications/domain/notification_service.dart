import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../data/entity_notfication.dart';

const String sendReq = "send";
const String undoReq = "undo";

class NotificationService extends ChangeNotifier {
  List<PeopleNotificationEntity> peopleNotificationList = [];

  void notifications(snap) {
    snap.data["peopleNotification"].forEach((cu) {
      var pne = PeopleNotificationEntity.fromJson(cu as Map<String, dynamic>);
      print(pne.id);

      if (peopleNotificationList.isEmpty) {
        peopleNotificationList.add(pne);
      } else {
        for (var i = 0; i < peopleNotificationList.length; i++) {
          print("inside");
          print(peopleNotificationList[i].id);
          if (peopleNotificationList[i].id != pne.id)
            peopleNotificationList.add(pne);
        }
      }
    });
  }

  //when someone accepts my request, I need to be notified
  static requestAcceptedNotification(ConnectionUser whoAccepted) async {
    PeopleNotificationEntity nE = PeopleNotificationEntity(
        id: sharedPrefs.userid,
        username: sharedPrefs.userName,
        fullname: sharedPrefs.fullname,
        avatarImageUrl: sharedPrefs.photoUrl,
        type: PeopleNotificationEntity.typeConnectionRequestAccepted,
        timestamp: Timestamp.now());

    //ConnectionUser whoAccepted = ConnectionUser(id: cu.id, username: cu.username, fullname: cu.fullname, avatarImageUrl: cu.avatarImageUrl,timestamp: Timestamp.fromDate()
    DocumentSnapshot notificationDoc = await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(whoAccepted.id)
        .get();

    if (notificationDoc.exists) {
      FirebaseFirestore.instance
          .collection('Notifications')
          .doc(whoAccepted.id)
          .update({
        "peopleNotification": FieldValue.arrayUnion([nE.toJson()])
      });
    } else {
      FirebaseFirestore.instance
          .collection('Notifications')
          .doc(whoAccepted.id)
          .set({
        "peopleNotification": FieldValue.arrayUnion([nE.toJson()])
      });
    }
  }

  static requestPendingNotification(
      ConnectionUser whoSent, String instruction, BuildContext context) async {
    PeopleNotificationEntity nE = PeopleNotificationEntity(
        id: sharedPrefs.userid,
        username: sharedPrefs.userName,
        fullname: sharedPrefs.fullname,
        avatarImageUrl: sharedPrefs.photoUrl,
        type: PeopleNotificationEntity.typeConnectionRequestReceived,
        timestamp: Timestamp.now());

    List<PeopleNotificationEntity> pnList = [];
    //the receiver who's notification is to be updated
    DocumentSnapshot notificationDoc = await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(whoSent.id)
        .get();

    if (notificationDoc.exists) {
      notificationDoc["peopleNotification"].forEach((entry) {
        pnList.add(
            PeopleNotificationEntity.fromJson(entry as Map<String, dynamic>));
      });
      if (instruction == sendReq) {
        pnList.add(nE);

        List<Map<String, dynamic>> pnListJson =
            pnList.map((e) => e.toJson()).toList();

        FirebaseFirestore.instance
            .collection('Notifications')
            .doc(whoSent.id)
            .update({"peopleNotification": pnListJson}).catchError((e) {
          showDialog(
              context: context,
              builder: (_) {
                return Text("Try again!");
              });
        });
      } else if (instruction == undoReq) {
        pnList.removeWhere((element) =>
            element.id == sharedPrefs.userid &&
            element.type ==
                PeopleNotificationEntity.typeConnectionRequestReceived);

        List<Map<String, dynamic>> pnListJson =
            pnList.map((e) => e.toJson()).toList();

        FirebaseFirestore.instance
            .collection('Notifications')
            .doc(whoSent.id)
            .update({"peopleNotification": pnListJson}).catchError((e) {
          showDialog(
              context: context,
              builder: (_) {
                return Text("Try again!");
              });
        });
      }
    } else {
      if (instruction == sendReq) {
        pnList.add(nE);
        final List<Map<String, dynamic>> pnListJson =
            pnList.map((e) => e.toJson()).toList();

        FirebaseFirestore.instance
            .collection('Notifications')
            .doc(whoSent.id)
            .set({"peopleNotification": pnListJson}).catchError((e) {
          showDialog(
              context: context,
              builder: (_) {
                return Text("Try again!");
              });
        });
      } else if (instruction == undoReq) {
        pnList.removeWhere((element) =>
            element.id == whoSent.id &&
            element.type ==
                PeopleNotificationEntity.typeConnectionRequestReceived);

        List<Map<String, dynamic>> pnListJson =
            pnList.map((e) => e.toJson()).toList();

        FirebaseFirestore.instance
            .collection('Notifications')
            .doc(whoSent.id)
            .set({"peopleNotification": pnListJson}).catchError((e) {
          showDialog(
              context: context,
              builder: (_) {
                return Text("Try again!");
              });
        });
      }
    }
  }

  static Future removeRequestFromNotification(
      PeopleNotificationEntity pne) async {
    DocumentSnapshot notificationDoc = await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(sharedPrefs.userid)
        .get();
    print(
        "inside removeRequest->About to remove\n ${pne.avatarImageUrl}, ${pne.fullname}, ${pne.id}, ${pne.timestamp} ${pne.type} ${pne.username}");

    List<Map<String, dynamic>> pneList = [];
    notificationDoc['peopleNotification'].forEach((notificationValue) {
      if (notificationValue["id"] != pne.id) {
        print(notificationValue["id"]);
        print("\n${pne.id}");
        pneList.add(notificationValue as Map<String, dynamic>);
      }
    });

    if (notificationDoc.exists) {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(sharedPrefs.userid)
          .update({"peopleNotification": pneList});
    } else {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(sharedPrefs.userid)
          .set({"peopleNotification": pneList});
    }
  }

  static Future iAcceptedRequestFromNotification(
      PeopleNotificationEntity pne) async {
    DocumentSnapshot notificationDoc = await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(sharedPrefs.userid)
        .get();
    print(
        "inside IAcceptedRequest->About to add\n ${pne.avatarImageUrl}, ${pne.fullname}, ${pne.id}, ${pne.timestamp} ${pne.type} ${pne.username}");

    if (notificationDoc.exists) {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(sharedPrefs.userid)
          .update({
        "peopleNotification":
            FieldValue.arrayUnion([PeopleNotificationEntity.toMap(pne)])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(sharedPrefs.userid)
          .set({
        "peopleNotification":
            FieldValue.arrayUnion([PeopleNotificationEntity.toMap(pne)])
      });
    }
  }

  static rejectJumpinRequest(JumpinUser user, BuildContext context) async {
    var doc =
        FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userid);

    doc.update({
      "requestReceivedFrom": FieldValue.arrayRemove([user.id])
    }).whenComplete(() => print("\n removed from my request"));

    var docPeople = FirebaseFirestore.instance.collection('users').doc(user.id);
    docPeople.update({
      "requestSentTo": FieldValue.arrayRemove([sharedPrefs.userid])
    }).whenComplete(() => print("removed from his request list"));

    PeopleNotificationEntity pne = PeopleNotificationEntity(
        avatarImageUrl: user.photoUrl,
        type: PeopleNotificationEntity.typeConnectionRequestAccepted,
        id: user.id,
        fullname: user.fullname,
        username: user.username);

    NotificationService.removeRequestFromNotification(pne);
  }

  static rejectJumpinRequestFromNotification(
      ConnectionUser user, BuildContext context) async {
    var doc =
        FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userid);

    doc.update({
      "requestReceivedFrom": FieldValue.arrayRemove([user.id])
    });

    var docPeople = FirebaseFirestore.instance.collection('users').doc(user.id);
    docPeople.update({
      "requestSentTo": FieldValue.arrayRemove([sharedPrefs.userid])
    });

    PeopleNotificationEntity pne = PeopleNotificationEntity(
        avatarImageUrl: user.avatarImageUrl,
        type: PeopleNotificationEntity.typeConnectionRequestAccepted,
        id: user.id,
        fullname: user.fullname,
        username: user.username);

    NotificationService.removeRequestFromNotification(pne);
  }

  static acceptJumpinRequestFromNotification(
      ConnectionUser user, BuildContext context) async {
    final connectionUser = ConnectionUser(
        id: user.id,
        username: user.username,
        fullname: user.fullname,
        avatarImageUrl: user.avatarImageUrl);

    var doc =
        FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userid);

    doc.update({
      "requestReceivedFrom": FieldValue.arrayRemove([user.id])
    }).then((_) {
      print("\n\nnow completed request removal\n\n");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Congratulations! Request Accepted'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        print('connection user ${connectionUser.fullname}');
                        if (sharedPrefs.myNoOfConnectionRequests > 0) {
                          sharedPrefs.myNoOfConnectionRequests -= 1;
                        }
                        sharedPrefs.myNoOfConnections += 1;

                        connectionUser.timestamp =
                            Timestamp.fromDate(DateTime.now());

                        //Navigator.pushNamed(context, rListOfChat);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PeopleConversationScreen(
                              connectionUser: connectionUser,
                              navigatorRoute: "notification",
                            ),
                          ),
                        );
                      },
                      child: const Text('Have a chat '))
                ],
              ));

      FirebaseFirestore.instance.collection('users').doc(user.id).update({
        "requestSentTo": FieldValue.arrayRemove([sharedPrefs.userid])
      });

      PeopleNotificationEntity pne = PeopleNotificationEntity(
          avatarImageUrl: user.avatarImageUrl,
          type: PeopleNotificationEntity.typeConnectionRequestReceived,
          id: user.id,
          timestamp: user.timestamp,
          fullname: user.fullname,
          username: user.username);

      NotificationService.removeRequestFromNotification(pne).then((_) {
        PeopleNotificationEntity pne2 = PeopleNotificationEntity(
            avatarImageUrl: user.avatarImageUrl,
            type: PeopleNotificationEntity.typeConnectionRequestAcceptedByMe,
            id: user.id,
            timestamp: Timestamp.now(),
            fullname: user.fullname,
            username: user.username);
        print(
            "\n\n\ncalling I accepted from Notification handler, for ${pne2.username}\n\n\n");
        NotificationService.iAcceptedRequestFromNotification(pne2).then((_) {
          List<ConnectionUser> connectionUsers = [];
          doc.get().then((value) => value['myConnections'].forEach((json) {
                ConnectionUser cu =
                    ConnectionUser.fromJson(json as Map<String, dynamic>);
                connectionUsers.add(cu);

                if (connectionUsers.isNotEmpty) {
                  sharedPrefs.myConnectionListasString =
                      ConnectionUser.encode(connectionUsers);
                }
              }));
          FirebaseFirestore.instance
              .collection('users')
              .doc(sharedPrefs.userid)
              .update({
            "myConnections": FieldValue.arrayUnion([connectionUser.toJson()])
          }).then((_) {
            final currentUser = ConnectionUser(
                id: sharedPrefs.userid,
                username: sharedPrefs.userName,
                fullname: sharedPrefs.fullname,
                avatarImageUrl: sharedPrefs.photoUrl);

            FirebaseFirestore.instance.collection('users').doc(user.id).update({
              "myConnections": FieldValue.arrayUnion([currentUser.toJson()])
            }).then((_) {
              NotificationService.requestAcceptedNotification(connectionUser);
              //updateReceiverDatabase()
            });
          });
        });
      });
    });
  }
}
