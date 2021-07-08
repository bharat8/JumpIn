import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idUser;
  final String message;
  final DateTime createdAt;
  bool seenByReceiver;

  Message({
    @required this.idUser,
    @required this.message,
    @required this.createdAt,
    this.seenByReceiver,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
      idUser: json['idUser'] as String,
      message: json['message'] as String,
      createdAt: Utils.toDateTime(
        json['createdAt'] as Timestamp,
      ),
      seenByReceiver: json['seenByReceiver'] as bool);

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
        'seenByReceiver': seenByReceiver,
      };
}
