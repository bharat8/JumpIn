import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConnectionUser {
  final String id;
  String username;
  String fullname;
  final String avatarImageUrl;
  Timestamp timestamp;

  ConnectionUser(
      {@required this.id,
      @required this.username,
      @required this.fullname,
      this.timestamp,
      @required this.avatarImageUrl});

  static ConnectionUser fromJson(Map<String, dynamic> json) => ConnectionUser(
        id: json['id'] as String,
        username: json['username'] as String,
        fullname: json['fullname'] as String,
        avatarImageUrl: json['avatarImageUrl'] as String,
      );
  static ConnectionUser fromJsonForNotification(Map<String, dynamic> json) =>
      ConnectionUser(
          id: json['id'] as String,
          username: json['username'] as String,
          fullname: json['fullname'] as String,
          avatarImageUrl: json['avatarImageUrl'] as String,
          timestamp: json['timestamp'] as Timestamp);

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'fullname': fullname,
        'avatarImageUrl': avatarImageUrl
      };

  Map<String, dynamic> toJsonForNotification() => {
        'id': id,
        'username': username,
        'fullname': fullname,
        'avatarImageUrl': avatarImageUrl,
        'timestamp': Timestamp.now()
      };
  static Map<String, dynamic> toMap(ConnectionUser connectionUser) => {
        'id': connectionUser.id,
        'username': connectionUser.username,
        'fullname': connectionUser.fullname,
        'avatarImageUrl': connectionUser.avatarImageUrl
      };

//list of connection users to string
  static String encode(List<ConnectionUser> connectionUsers) =>
      json.encode(connectionUsers
          .map<Map<String, dynamic>>((cu) => ConnectionUser.toMap(cu))
          .toList());

//encoded string data to list of connection users
  static List<ConnectionUser> decode(String connectionUsers) =>
      (json.decode(connectionUsers) as List<dynamic>)
          .map((item) => ConnectionUser.fromJson(item as Map<String, dynamic>))
          .toList();
}
