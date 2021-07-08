import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleNotificationEntity {
  final String id;
  final String username;
  final String fullname;
  final String avatarImageUrl;
  final Timestamp timestamp;
  final String type;
  bool seenByReceiver;
  /*
  for connection request received: type-> "connectionRequestReceived"
  for connection request accepted: type-> "connectionRequestAccepted"
  for connection request accepted by me: type-> "connectionRequestAcceptedByMe"
  */

  static String typeConnectionRequestReceived = "connectionRequestReceived";
  static String typeConnectionRequestAccepted = "connectionRequestAccepted";
  static String typeConnectionRequestAcceptedByMe =
      "connectionRequestAcceptedByMe";
  PeopleNotificationEntity({
    this.id,
    this.username,
    this.fullname,
    this.avatarImageUrl,
    this.timestamp,
    this.type,
    this.seenByReceiver,
  });

  static PeopleNotificationEntity fromJson(Map<String, dynamic> json) =>
      PeopleNotificationEntity(
          id: json['id'] as String,
          username: json['username'] as String,
          fullname: json['fullname'] as String,
          avatarImageUrl: json['avatarImageUrl'] as String,
          type: json['type'] as String,
          timestamp: json['timestamp'] as Timestamp,
          seenByReceiver: json['seenByReceiver'] as bool);

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'fullname': fullname,
        'avatarImageUrl': avatarImageUrl,
        'type': type,
        'timestamp': timestamp,
        'seenByReceiver': seenByReceiver
      };

  static Map<String, dynamic> toMap(
          PeopleNotificationEntity notificationEntity) =>
      {
        'id': notificationEntity.id,
        'username': notificationEntity.username,
        'fullname': notificationEntity.fullname,
        'avatarImageUrl': notificationEntity.avatarImageUrl,
        'type': notificationEntity.type,
        'timestamp': notificationEntity.timestamp,
        'seenByReceiver': notificationEntity.seenByReceiver,
      };

// //list of connection users to string
//   static String encode(List<NotificationEntity> notifications) =>
//       json.encode(notifications
//           .map<Map<String, dynamic>>((cu) => NotificationEntity.toMap(cu))
//           .toList());

// //encoded string data to list of connection users
//   static List<ConnectionUser> decode(String connectionUsers) =>
//       (json.decode(connectionUsers) as List<dynamic>)
//           .map((item) => ConnectionUser.fromJson(item as Map<String, dynamic>))
//           .toList();
}
