import 'dart:async';
import 'dart:convert';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_notifications/data/entity_notfication.dart';
import 'package:JumpIn/features/user_notifications/domain/notification_service.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';

import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'chat_service.dart';

const String sendReq = "send";
const String undoReq = "undo";

// Future sendConnectionRequest(ConnectionUser cu, BuildContext context) async {
//   DocumentSnapshot userDoc = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(sharedPrefs.userid)
//       .get();

//   if (userDoc.exists) {
//     try {
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(sharedPrefs.userid)
//           .update({
//         "requestSentTo": FieldValue.arrayUnion([cu.id])
//       }).whenComplete(() {
//         updateReceiverDatabase(cu, sendReq).whenComplete(() {
//           upadtingReqSentList();

//           showDialog(
//               context: context,
//               builder: (context) {
//                 Future.delayed(Duration(seconds: 2), () {
//                   Navigator.of(context).pop(true);
//                 });
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Lottie.asset('assets/animations/success.json',
//                       repeat: false, animate: true),
//                 );
//               });
//         });
//       });
//     } on Exception catch (e) {
//       print("error\n");
//     }
//   } else {
//     FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userid).set({
//       "requestSentTo": FieldValue.arrayUnion([cu.id]),
//       "requestReceivedFrom": [],
//       "myConnections": []
//     }).whenComplete(() {
//       updateReceiverDatabase(cu, sendReq).whenComplete(() {
//         upadtingReqSentList();
//         showDialog(
//             context: context,
//             builder: (context) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Lottie.asset('assets/animations/success.json',
//                     repeat: false, animate: true),
//               );
//             });
//       });
//     });
//   }
// }

// Future undoConnectionRequest(ConnectionUser cu, BuildContext context) async {
//   DocumentSnapshot userDoc = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(sharedPrefs.userid)
//       .get();

//   if (userDoc.exists) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(sharedPrefs.userid)
//         .update({
//       "requestSentTo": FieldValue.arrayRemove([cu.id])
//     }).whenComplete(() {
//       updateReceiverDatabase(cu, undoReq).whenComplete(() {
//         upadtingReqSentList();
//         showDialog(
//             context: context,
//             builder: (context) {
//               Future.delayed(const Duration(seconds: 2), () {
//                 Navigator.of(context).pop(true);
//               });
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Lottie.asset('assets/animations/success.json',
//                     repeat: false, animate: true),
//               );
//             });
//       });
//     });
//   } else {
//     FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userid).set({
//       "requestSentTo": FieldValue.arrayRemove([cu.id]),
//       "requestReceivedFrom": [],
//       "myConnections": []
//     }).whenComplete(() {
//       updateReceiverDatabase(cu, undoReq).whenComplete(() {
//         upadtingReqSentList();
//         showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//                   title: const Text("Request withdrawm"),
//                 ));
//       });
//     });
//   }
// }

// Future updateReceiverDatabase(ConnectionUser cu, String instruction) async {
//   DocumentSnapshot peopleDoc =
//       await FirebaseFirestore.instance.collection('users').doc(cu.id).get();

//   if (peopleDoc.exists) {
//     var doc = FirebaseFirestore.instance.collection('users').doc(cu.id);
//     DocumentSnapshot pd =
//         await FirebaseFirestore.instance.collection('users').doc(cu.id).get();
//     print("inside updatereceiverDatabase and doc exists with-> ${pd.data()}");
//     if (instruction == sendReq) {
//       doc.update({
//         "requestReceivedFrom": FieldValue.arrayUnion([sharedPrefs.userid])
//       });

//       //letting the other user know that there's request notification
//       NotificationService.requestPendingNotification(cu, sendReq);
//     } else if (instruction == undoReq) {
//       doc.update({
//         "requestReceivedFrom": FieldValue.arrayRemove([sharedPrefs.userid])
//       });
//       NotificationService.requestPendingNotification(cu, undoReq);
//     }
//   } else {
//     if (instruction == sendReq) {
//       FirebaseFirestore.instance.collection('users').doc(cu.id).set({
//         "requestReceivedFrom": FieldValue.arrayUnion([sharedPrefs.userid]),
//         "requestSentTo": [],
//         "myConnections": []
//       });
//       //letting the other user know that there's request notification
//       NotificationService.requestPendingNotification(cu, sendReq);
//     } else if (instruction == undoReq) {
//       FirebaseFirestore.instance.collection('users').doc(cu.id).set({
//         "requestReceivedFrom": FieldValue.arrayRemove([sharedPrefs.userid]),
//         "requestSentTo": [],
//         "myConnections": []
//       });
//       NotificationService.requestPendingNotification(cu, undoReq);
//     }
//   }
// }

Future requestPendingNotification(ConnectionUser whoSent) async {
  print("inside request pending NOtification");

  PeopleNotificationEntity nE = PeopleNotificationEntity(
      id: sharedPrefs.userid,
      username: sharedPrefs.userName,
      fullname: sharedPrefs.fullname,
      avatarImageUrl: sharedPrefs.photoUrl,
      type: PeopleNotificationEntity.typeConnectionRequestReceived,
      timestamp: Timestamp.now());

  //the receiver who's notification is to be updated
  DocumentSnapshot notificationDoc = await FirebaseFirestore.instance
      .collection('Notifications')
      .doc(whoSent.id)
      .get();

  if (notificationDoc.exists) {
    FirebaseFirestore.instance
        .collection('Notifications')
        .doc(whoSent.id)
        .update({
      "peopleNotification": FieldValue.arrayUnion([nE.toJson()])
    });
  } else {
    FirebaseFirestore.instance.collection('Notifications').doc(whoSent.id).set({
      "peopleNotification": FieldValue.arrayUnion([nE.toJson()])
    });
  }
}

upadtingReqSentList() {
  List<String> reqSentList = [];
  var doc = FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .get();

  doc.then((data) {
    data['requestSentTo'].forEach((userid) {
      reqSentList.add(userid as String);
    });
    String reqSentListAsString = jsonEncode(reqSentList);
    sharedPrefs.myPendingConnectionListasString = reqSentListAsString;
  });
}

Future rejectJumpinRequest(JumpinUser user, BuildContext context) async {
  var doc =
      FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userid);

  doc.update({
    "requestReceivedFrom": FieldValue.arrayRemove([user.id])
  }).whenComplete(() => print("\n removed from my request"));

  var docPeople = FirebaseFirestore.instance.collection('users').doc(user.id);
  docPeople.update({
    "requestSentTo": FieldValue.arrayRemove([sharedPrefs.userid])
  }).whenComplete(() => print("removed from his request list"));
  // .whenComplete(() => showDialog(
  //     context: context,
  //     builder: (context) {
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.pop(context);
  //         },
  //         child: Lottie.asset('assets/animations/success.json',
  //             repeat: false, animate: true),
  //       );
  //     }))
  // .catchError((onError) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: const Text('Ahh! Seems like an error'),
  //           ));
  // });

  PeopleNotificationEntity pne = PeopleNotificationEntity(
      avatarImageUrl: user.photoUrl,
      type: PeopleNotificationEntity.typeConnectionRequestAccepted,
      id: user.id,
      fullname: user.fullname,
      username: user.username);

  NotificationService.removeRequestFromNotification(pne);
}

Future rejectJumpinRequestFromNotification(
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
  // .whenComplete(() => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           title: const Text('Request Rejected'),
  //         )))
  // .catchError((onError) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: const Text('Ahh! Seems like an error'),
  //           ));
  // });

  PeopleNotificationEntity pne = PeopleNotificationEntity(
      avatarImageUrl: user.avatarImageUrl,
      type: PeopleNotificationEntity.typeConnectionRequestAccepted,
      id: user.id,
      fullname: user.fullname,
      username: user.username);

  NotificationService.removeRequestFromNotification(pne);
}

Future acceptJumpinRequestFromNotification(
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
  }).whenComplete(() {
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

                      String uniqueChatId = ChatService()
                          .getUniqueChatId(sharedPrefs.userid, user.id);

                      connectionUser.timestamp =
                          Timestamp.fromDate(DateTime.now());

                      ChatService().uploadMessage(
                          uniqueChatId: uniqueChatId,
                          message: "",
                          connectionUser: connectionUser,
                          seenByReceiver: false);

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
    var docPeople = FirebaseFirestore.instance.collection('users').doc(user.id);
    docPeople.update({
      "requestSentTo": FieldValue.arrayRemove([sharedPrefs.userid])
    });

    PeopleNotificationEntity pne = PeopleNotificationEntity(
        avatarImageUrl: user.avatarImageUrl,
        type: PeopleNotificationEntity.typeConnectionRequestReceived,
        id: user.id,
        timestamp: user.timestamp,
        fullname: user.fullname,
        username: user.username);

    NotificationService.removeRequestFromNotification(pne);

    PeopleNotificationEntity pne2 = PeopleNotificationEntity(
        avatarImageUrl: user.avatarImageUrl,
        type: PeopleNotificationEntity.typeConnectionRequestAcceptedByMe,
        id: user.id,
        timestamp: Timestamp.now(),
        fullname: user.fullname,
        username: user.username);
    print(
        "\n\n\ncalling I accepted from Notification handler, for ${pne2.username}\n\n\n");
    NotificationService.iAcceptedRequestFromNotification(pne2);
  }).catchError((onError) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Ahh! Seems like an error'),
            ));
  });

  List<ConnectionUser> connectionUsers = [];
  doc.get().then((value) => value.data()['myConnections'].forEach((json) {
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
  });

  final currentUser = ConnectionUser(
      id: sharedPrefs.userid,
      username: sharedPrefs.userName,
      fullname: sharedPrefs.fullname,
      avatarImageUrl: sharedPrefs.photoUrl);

  FirebaseFirestore.instance.collection('users').doc(user.id).update({
    "myConnections": FieldValue.arrayUnion([currentUser.toJson()])
  });

  NotificationService.requestAcceptedNotification(connectionUser);
  //updateReceiverDatabase()
}

Future acceptJumpinRequest(JumpinUser user, BuildContext context) async {
  final connectionUser = ConnectionUser(
      id: user.id,
      username: user.username,
      fullname: user.fullname,
      avatarImageUrl: user.photoUrl);

  var doc =
      FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userid);

  doc.update({
    "requestReceivedFrom": FieldValue.arrayRemove([user.id])
  }).whenComplete(() {
    print("\n\nnow completed request removal\n\n");
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Congratulations! Request Accepted'),
              actions: [
                FlatButton(
                    onPressed: () {
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
    if (sharedPrefs.myNoOfConnectionRequests > 0) {
      sharedPrefs.myNoOfConnectionRequests -= 1;
    }
    sharedPrefs.myNoOfConnections += 1;

    String uniqueChatId =
        ChatService().getUniqueChatId(sharedPrefs.userid, user.id);

    connectionUser.timestamp = Timestamp.fromDate(DateTime.now());

    ChatService().uploadMessage(
        uniqueChatId: uniqueChatId,
        message: "",
        connectionUser: connectionUser,
        seenByReceiver: false);

    PeopleNotificationEntity pne = PeopleNotificationEntity(
        avatarImageUrl: user.photoUrl,
        type: PeopleNotificationEntity.typeConnectionRequestReceived,
        id: user.id,
        fullname: user.fullname,
        username: user.username);

    NotificationService.removeRequestFromNotification(pne);

    PeopleNotificationEntity pne2 = PeopleNotificationEntity(
        avatarImageUrl: user.photoUrl,
        type: PeopleNotificationEntity.typeConnectionRequestAcceptedByMe,
        id: user.id,
        timestamp: Timestamp.now(),
        fullname: user.fullname,
        username: user.username);
    print("calling iAccepted with $pne2 ");
    NotificationService.iAcceptedRequestFromNotification(pne2);
  }).catchError((onError) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Ahh! Seems like an error'),
            ));
  });
  var docPeople = FirebaseFirestore.instance.collection('users').doc(user.id);
  docPeople.update({
    "requestSentTo": FieldValue.arrayRemove([sharedPrefs.userid])
  });

  List<ConnectionUser> connectionUsers = [];
  doc.get().then((value) => value.data()['myConnections'].forEach((json) {
        ConnectionUser cu =
            ConnectionUser.fromJson(json as Map<String, dynamic>);
        connectionUsers.add(cu);

        if (connectionUsers.isNotEmpty) {
          sharedPrefs.myConnectionListasString =
              ConnectionUser.encode(connectionUsers);
        }
      }));
  //adding my friend to my connection
  FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .update({
    "myConnections": FieldValue.arrayUnion([connectionUser.toJson()])
  });

  //adding me to my friend connection
  final currentUser = ConnectionUser(
      id: sharedPrefs.userid,
      username: sharedPrefs.userName,
      fullname: sharedPrefs.fullname,
      avatarImageUrl: sharedPrefs.photoUrl);

  FirebaseFirestore.instance.collection('users').doc(user.id).update({
    "myConnections": FieldValue.arrayUnion([currentUser.toJson()])
  });

  NotificationService.requestAcceptedNotification(connectionUser);
}

Future addToBookmark(JumpinUser ju, BuildContext context) async {
  DocumentSnapshot userref = await FirebaseFirestore.instance
      .collection("users")
      .doc(sharedPrefs.userid)
      .get();

  if (userref.exists) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .update({
      "bookmarks": FieldValue.arrayUnion([JumpinUser.toMap(ju)])
    }).whenComplete(() {
      showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Lottie.asset('assets/animations/success.json',
                  repeat: false, animate: true),
            );
          });
    });
  } else {
    FirebaseFirestore.instance.collection("users").doc(sharedPrefs.userid).set({
      "bookmarks": FieldValue.arrayUnion([JumpinUser.toMap(ju)])
    }).whenComplete(() {
      showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Lottie.asset('assets/animations/success.json',
                  repeat: false, animate: true),
            );
          });
    });
  }
}
