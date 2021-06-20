import 'package:JumpIn/features/user_notifications/data/entity_notfication.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationCounter {
  static Future getRequestCount() async {
    print("inside get request count\n");
    List<dynamic> pne = [];
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .get();
    //print("\n\ncalled getRequestCount() with ${doc.exists}\n\n");
    if (doc.exists) {
      pne = doc['requestReceivedFrom']
          .map((connection) => connection as String)
          .toList() as List<dynamic>;
      sharedPrefs.myNoOfConnectionRequests = pne.length;
      // print(
      //     "inside notification count,my no of connection request-> ${sharedPrefs.myNoOfConnectionRequests}");
    } else {
      sharedPrefs.myNoOfConnectionRequests = 0;
    }
  }

  static Future getNotificationCount() async {
    print("inside get notification count");
    List<dynamic> pne = [];
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(sharedPrefs.userid)
        .get();

    print(".\n.\n\n inside notification count -> \n.\n.\n");
    if (doc.exists) {
      pne = doc['peopleNotification']
          .map((notification) => PeopleNotificationEntity.fromJson(
              notification as Map<String, dynamic>))
          .toList() as List<dynamic>;

      sharedPrefs.myPendingNotification =
          pne.length - sharedPrefs.myNotificationCount;
      // print(
      //     "inside notification count,my notification count-> ${sharedPrefs.myPendingNotification}");
    } else {
      sharedPrefs.myPendingNotification = 0;
    }
  }

  static Future getConnectionCount() async {
    print("\nget connection count");
    List<dynamic> pne = [];
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .get();

    //print(".\n.\n\n inside notification count -> \n.\n.\n");
    if (doc.exists) {
      pne = doc['myConnections']
          .map((connection) =>
              ConnectionUser.fromJson(connection as Map<String, dynamic>))
          .toList() as List<dynamic>;
      sharedPrefs.myNoOfConnections = pne.length;
      // print(
      //     "inside notification count,my no of connections-> ${sharedPrefs.myNoOfConnections}");
    } else {
      sharedPrefs.myNoOfConnections = 0;
    }
  }
}
