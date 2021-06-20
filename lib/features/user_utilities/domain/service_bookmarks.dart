import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBookmarks {
  List<JumpinUser> _allUsers = [];

  List<JumpinUser> get allUsers => _allUsers;

  Map<String, bool> _isBookMarkConnection = {};

  Map<String, bool> get isBookMarkConnection => _isBookMarkConnection;

  Future<bool> modelBookmarks() async {
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .get();

    docSnap["bookmarks"].forEach((user) {
      docSnap["myConnections"].forEach((bookMark) {
        if (user["id"] == bookMark["id"]) {
          print(user["id"]);
          _isBookMarkConnection[user["id"] as String] = true;
        } else {
          _isBookMarkConnection[user["id"] as String] = false;
        }
      });
    });

    docSnap['bookmarks'].forEach((doc) {
      JumpinUser ju = JumpinUser(
          id: doc['id'] as String,
          fullname: doc['fullname'] as String,
          gender: doc['gender'] as String,
          username: doc['username'] as String,
          dob: doc['dob'] as Timestamp,
          profession: doc['profession'] as String,
          placeOfWork: doc['placeOfWork'] as String,
          placeOfEdu: doc['placeOfEdu'] as String,
          acadCourse: doc['acadCourse'] as String,
          wtfDesc: doc['wtfDesc'] as String,
          photoUrl: doc['photoUrl'] as String,
          email: doc['email'] as String,
          phoneNo: doc['phoneNo'] as String,
          userProfileAbout: doc['userProfileAbout'] as String,
          geoPoint: doc['geoPoint'] as GeoPoint ?? const GeoPoint(0.0, 0.0),
          inJumpinFor: doc['inJumpinFor'] as String);

      allUsers.add(ju);
    });
    return true;
  }
}
