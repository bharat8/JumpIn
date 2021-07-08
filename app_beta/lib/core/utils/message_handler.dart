import 'package:JumpIn/core/network/chat_service.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_notifications/presentation/screens/notifications.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '10', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

class MessageHandler {
  static bool _isConfigured = false;

  int count = 0;
  static void configuringFirebase(BuildContext context) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    //Ios,Apple Permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    Future selectNotification(String userId) async {
      if (userId != null) {
        debugPrint('notification payload: $userId');
      }

      final String uniqueChatId =
          ChatService().getUniqueChatId(sharedPrefs.userid, userId);
      FirebaseFirestore.instance
          .collection("chats")
          .doc(uniqueChatId)
          .get()
          .then((docSnap) {
        (docSnap.data()["users"] as List).forEach((user) {
          if (user["id"] == userId) {
            final ConnectionUser connectionUser =
                ConnectionUser.fromJson(user as Map<String, dynamic>);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PeopleConversationScreen(
                          connectionUser: connectionUser,
                          navigatorRoute: "notification",
                        )));
          }
        });
      });
    }

    if (!_isConfigured) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('logo_white');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: selectNotification);

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: android.smallIcon,
                  // other properties...
                ),
              ),
              payload: message.data["id"] as String);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        goToAppointmentsScreen(context, message.data);
        // print(message.data);
      });

      RemoteMessage initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      // If the message also contains a data property with a "type" of "chat",
      // navigate to a chat screen
      if (initialMessage != null) {
        goToAppointmentsScreen(context, initialMessage.data);
      }

      _isConfigured = true;
    }

    _firebaseMessaging.getToken().then((token) {
      sharedPrefs.fcmToken = token;
      print("FCM TOKEN -------------> $token");
    }).then((_) {
      if (sharedPrefs.userid != null) {
        print(sharedPrefs.fullname);
        FirebaseFirestore.instance.collection("fcmTokens").get().then((value) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection("fcmTokens")
                .doc(sharedPrefs.userid)
                .set({
              "fcmToken": sharedPrefs.fcmToken,
              "userName": sharedPrefs.fullname,
              "userId": sharedPrefs.userid,
            });
          });
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}

Future<void> goToAppointmentsScreen(BuildContext context, message) async {
  if (message["messageType"] == "chatMessage") {
    final String uniqueChatId = ChatService()
        .getUniqueChatId(sharedPrefs.userid, message["id"] as String);
    FirebaseFirestore.instance
        .collection("chats")
        .doc(uniqueChatId)
        .get()
        .then((docSnap) {
      (docSnap.data()["users"] as List).forEach((user) {
        if (user["id"] == message["id"] as String) {
          final ConnectionUser connectionUser =
              ConnectionUser.fromJson(user as Map<String, dynamic>);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PeopleConversationScreen(
                        connectionUser: connectionUser,
                        navigatorRoute: "notification",
                      )));
        }
      });
    });
  }

  if (message["messageType"] == "connectionRequestReceived") {
    Navigator.pushNamed(context, rPeopleProfile,
        arguments: [message["id"] as String, "connectionRequest"]);
  }
  if (message["messageType"] == "connectionRequestAccepted") {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ScreenJumpinNotifications()));
  }
}
