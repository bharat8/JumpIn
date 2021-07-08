import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ServiceRequests {
  LocationPermission permissionLocal;

  List<JumpinUser> _requestingUsers = [];

  List<JumpinUser> get requestingUsers => _requestingUsers;

  JumpinUser _currentUser;

  JumpinUser get currentUser => _currentUser;

  Future getPermission(BuildContext context) async {
    permissionLocal = await Geolocator.checkPermission();
    if (permissionLocal == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Location Permission Denied Forever"),
              ));
    }
  }

  void getLocationLatLong(BuildContext context) {
    getPermission(context).whenComplete(() {
      LocationUtils.getLocation().then((position) {
        LocationUtils.getAddress(position).then((addrs) {
          if (position.latitude.toString() != sharedPrefs.myLatitude ||
              position.longitude.toString() != sharedPrefs.myLongitude) {
            sharedPrefs.myLatitude = position.latitude.toString();
            sharedPrefs.myLongitude = position.longitude.toString();

            LocationUtils.updateLocationInDatabase(position)
                .then((value) => print(""));
          }
        });
      });
    });
  }

  String decideStudyWork(String placeOfWork, String placeOfEdu) {
    if (placeOfWork.isEmpty && placeOfEdu.isEmpty) {
      return "N/A";
    } else if (placeOfWork.isEmpty) {
      return placeOfEdu;
    }
    return placeOfWork;
  }

  void fetchRequetsUserID(AsyncSnapshot<QuerySnapshot> snapshot) {
    snapshot.data.docs.forEach((snapDoc) {
      if ((snapDoc["requestSentTo"] as List).contains(sharedPrefs.userid)) {
        _requestingUsers.add(JumpinUser(
            id: snapDoc['id'] as String,
            fullname: snapDoc['fullname'] as String,
            gender: snapDoc['gender'] as String,
            username: snapDoc['username'] as String,
            dob: snapDoc['dob'] as Timestamp,
            profession: snapDoc['profession'] as String,
            placeOfWork: snapDoc['placeOfWork'] as String,
            placeOfEdu: snapDoc['placeOfEdu'] as String,
            acadCourse: snapDoc['acadCourse'] as String,
            wtfDesc: snapDoc['wtfDesc'] as String,
            photoUrl: snapDoc['photoUrl'] as String,
            photoLists:
                List<String>.from(snapDoc['photoLists'] as Iterable<dynamic>),
            email: snapDoc['email'] as String,
            phoneNo: snapDoc['phoneNo'] as String,
            interestList:
                List<String>.from(snapDoc['interestList'] as Iterable<dynamic>),
            userProfileAbout: snapDoc['userProfileAbout'] as String,
            myConnections: List.from(snapDoc['myConnections'] as Iterable),
            geoPoint:
                snapDoc['geoPoint'] as GeoPoint ?? const GeoPoint(0.0, 0.0),
            inJumpinFor: snapDoc['inJumpinFor'] as String));
      }
      if (snapDoc.id == sharedPrefs.userid) {
        _currentUser = JumpinUser.fromDocument(snapDoc);
      }
    });
  }

  String _distance;

  String get distance => _distance;

  void doSomeRoundUps(JumpinUser user) {
    double dist_double;
    if (permissionLocal == null ||
        permissionLocal == LocationPermission.denied ||
        permissionLocal == LocationPermission.deniedForever) {
      _distance = "N/A";
    } else {
      dist_double = LocationUtils.getDistance(user.geoPoint.latitude.toDouble(),
              user.geoPoint.longitude.toDouble())
          .toDouble();

      if (dist_double == null) {
        _distance = "N/A";
      } else {
        print("dist_double here-> $dist_double");
        _distance = dist_double.toStringAsFixed(1);
      }
    }
  }
}
