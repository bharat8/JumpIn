import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class ChatUserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class ChatUser {
  final String idUser;
  final String name;
  final String urlAvatar;
  final DateTime lastMessageTime;

  const ChatUser({
    this.idUser,
    @required this.name,
    @required this.urlAvatar,
    @required this.lastMessageTime,
  });

  ChatUser copyWith({
    String idUser,
    String name,
    String urlAvatar,
    DateTime lastMessageTime,
  }) =>
      ChatUser(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static ChatUser fromJson(Map<String, dynamic> json) => ChatUser(
        idUser: json['idUser'] as String,
        name: json['name'] as String,
        urlAvatar: json['urlAvatar'] as String,
        lastMessageTime: Utils.toDateTime(json['lastMessageTime'] as Timestamp),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
