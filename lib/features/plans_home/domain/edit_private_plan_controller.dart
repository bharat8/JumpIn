import 'dart:io';

import 'package:JumpIn/features/plans_home/data/model_plan.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

class EditPrivatePlanController extends GetxController {
  String _planTitle;
  String _location;
  String _category;
  var isLoading = false.obs;
  var isPhotoUploading = false.obs;
  var dontAskForPhotos = false;
  DateTime _eventStartDate;
  DateTime _eventEndDate;
  String _planDesc;
  int _ageRestriction;
  int _entryFee;
  int _totalSpots;
  Timestamp _planStartTime;
  bool nullExists = false;
  List<String> listOfPlanPhotos = <String>[].obs;
  // Map<String, Icon> categoryPhotos = {
  //   'Spo'
  // };

  void setIsLoading(bool value) => isLoading.value = value;

  Future updatePlanOnDatabase(BuildContext context) async {
    // DocumentSnapshot doc = await FirebaseFirestore.instance
    //     .collection('plans')
    //     .doc(sharedPrefs.userid)
    //     .get();

    DocumentSnapshot docAllPlans = await FirebaseFirestore.instance
        .collection('plans')
        .doc('allPlans')
        .get();

    int allPlans_id =
        docAllPlans == null ? 0 : docAllPlans['plans'].length as int;
    // int myPlans_id =
    //     doc == null ? 0 : doc['myPlans'].length as int;

    ConnectionUser cu = ConnectionUser(
        id: sharedPrefs.userid,
        fullname: sharedPrefs.fullname,
        username: sharedPrefs.userName,
        avatarImageUrl: sharedPrefs.photoUrl);
    Plan plan = Plan(
        id: allPlans_id,
        privacy: Plan.private,
        photoList: listOfPlanPhotos,
        creator: ConnectionUser.toMap(cu),
        ageRestriction:
            _ageRestriction == null ? _ageRestriction = 5 : _ageRestriction,
        planTitle: _planTitle == null ? "no title" : _planTitle,
        locationName: _location == null ? "no location" : _location,
        category: _category,
        totalSpots: _totalSpots == null ? 3 : _totalSpots,
        startDate: _eventStartDate,
        endDate: _eventEndDate == null ? _eventStartDate : _eventEndDate,
        whoElseGoing: [],
        entryFee: _entryFee == null ? 0 : _entryFee,
        startTime: _planStartTime);

    if (!docAllPlans.exists) {
      await FirebaseFirestore.instance.collection('plans').doc('allPlans').set({
        'plans': FieldValue.arrayUnion([Plan.toJsonWithCreator(plan)])
      }).then((_) {
        showDialog(
            context: context,
            builder: (context) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Lottie.asset('assets/animations/success.json',
                      repeat: false, animate: true),
                ));
        isLoading.value = false;
        resetFields();
      }).catchError((e) => showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text('Error! Try Again'))));
    } else {
      await FirebaseFirestore.instance
          .collection('plans')
          .doc('allPlans')
          .update({
        'plans': FieldValue.arrayUnion([Plan.toJsonWithCreator(plan)])
      }).then((_) {
        showDialog(
            context: context,
            builder: (context) => GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Lottie.asset('assets/animations/success.json',
                    repeat: false, animate: true)));
        isLoading.value = false;

        resetFields();
      }).catchError((e) =>
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(title: Text('Error! Try Again'))));
    }
  }

  void setCategory(String category) {
    _category = category;
  }

  void resetFields() {
    _planTitle = null;
    _location = null;
    _eventStartDate = null;
    _eventEndDate = null;
    _planDesc = null;
    _ageRestriction = null;
    _entryFee = null;
    _totalSpots = null;
    _planStartTime = null;
    _category = null;
    dontAskForPhotos = false;
    listOfPlanPhotos = <String>[].obs;
  }

  void checkForEmptyFields(BuildContext context) {
    if (dontAskForPhotos == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title:
                  Text("Are you sure you don't want to add any more photos?"),
              actions: [
                FlatButton(
                  child: Text("YES"),
                  onPressed: () {
                    //Put your code here which you want to execute on Yes button click.
                    dontAskForPhotos = true;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("NO"),
                  onPressed: () {
                    dontAskForPhotos = false;
                    //Put your code here which you want to execute on No button click.
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else if (_category == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "Category field either empty or redundant. Select again"),
            );
          });
      nullExists = true;
    } else if (_planTitle == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "Plan title exists or the field is empty. Delete and type again"),
            );
          });
      nullExists = true;
    } else if (_location == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                  "Location exists or the field is empty. Delete and type again"),
            );
          });
      nullExists = true;
    } else if (_eventStartDate == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "Event Start Date exists or the field is empty. Delete and type again"),
            );
          });
      nullExists = true;
    } else if (_planStartTime == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "Start time of plan exists or the field is empty. Delete and type again"),
            );
          });
      nullExists = true;
    } else if (_planDesc == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                  "Plan Description exists or the field is empty. Delete and type again"),
            );
          });
      nullExists = true;
    } else if (_totalSpots == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                  "Total spots exists or the field is empty. Delete and type again"),
            );
          });
      nullExists = true;
    } else {
      nullExists = false;
    }
  }

  void assignDate(DateTime date, int assigningCode) {
    switch (assigningCode) {
      case 3:
        date == null
            ? _eventStartDate = DateTime.now()
            : _eventStartDate = date;
        break;
      case 4:
        date == null ? _eventEndDate = _eventStartDate : _eventEndDate = date;
        break;
      default:
    }
  }

  void assignTime(TimeOfDay tod, int assigningCode) {
    DateTime temp = DateTime(
        _eventStartDate.year, _eventStartDate.month, _eventStartDate.day);
    Timestamp ts = Timestamp.fromDate(temp);
    _planStartTime = ts;
  }

  void assignValue(int assigningCode, String value) {
    print("inside assignValue with code $assigningCode and value $value");
    switch (assigningCode) {
      case 1:
        value == null ? _planTitle = "" : _planTitle = value;
        print("\n plan title is assigned value $_planTitle, original $value");
        break;
      case 2:
        //location here
        value == null ? _location = '' : _location = value;
        break;
      //3->eventstart date, 4-> event end date, 5-> event time
      case 6:
        value == null ? _planDesc = "" : _planDesc = value;
        break;

      case 7:
        value == null
            ? _ageRestriction = 5
            : _ageRestriction = int.parse(value);
        break;
      case 8:
        value == null ? _entryFee = 0 : _entryFee = int.parse(value);
        break;
      case 9:
        value == null ? _totalSpots = 2 : _totalSpots = int.parse(value);
    }
  }

  Future<void> deletePrivatePlanImageFromFirebaseStorage(
      String imageFileUrl) async {
    print(
        "\n\n\n\n\nimageFileURl received for deletion -> $imageFileUrl\n\n\n\n");
    if (imageFileUrl != null) {
      var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
          .replaceAll(new RegExp(r'(\?alt).*'), '');

      final Reference photoRef =
          await FirebaseStorage.instance.ref().child(fileUrl);

      //-----implement storage exception----
      await photoRef.delete().then((_) {
        deletePrivatePlanPhotoFromFirebaseFirestore(imageFileUrl);
      }).catchError((e) => print(e));
    }
  }

  Future deletePrivatePlanPhotoFromFirebaseFirestore(imageFileUrl) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('plans')
        .doc('allPlans')
        .get();
    List<Map<String, dynamic>> plans = [];
    if (ds['plans'] != null) {
      ds['plans'].forEach((val) {
        Plan plan = Plan.fromJson(val as Map<String, dynamic>);
        plan.photoList.removeWhere((val) => val == imageFileUrl);
        plans.add(Plan.toJson(plan));
      });

      await FirebaseFirestore.instance
          .collection('plans')
          .doc('allPlans')
          .update({'plans': plans});
    }
  }

  void uploadPrivatePlanPhotoToFirestore(downloadUrl) {
    listOfPlanPhotos.add(downloadUrl as String);
  }

  Future<void> uploadPrivatePlanImage(File fileName) async {
    print("inside upload image for plans");

    var _firebaseStorage = FirebaseStorage.instance;
    try {
      var snapshot = await _firebaseStorage
          .ref(
              '/planPhotos/${sharedPrefs.userid}/${sharedPrefs.userid + "_" + DateTime.now().toString()}')
          .putFile(fileName);

      isPhotoUploading.value = false;

      var downloadUrl = await snapshot.ref.getDownloadURL();

      await uploadPrivatePlanPhotoToFirestore(downloadUrl);
    } on FirebaseException catch (e) {
      print("failed");
    }
  }

  Future<void> pickImageForPrivatePlan() async {
    var picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      print(File(pickedFile.path));
      File fileName = File(pickedFile.path);
      await uploadPrivatePlanImage(fileName);
    }
  }

  // FirebaseFirestore.instance
  //     .collection('plans')
  //     .doc('allPlans')
  //     .update({
  //   'photoLists': FieldValue.arrayRemove([imageFileUrl])
  // }).whenComplete(() => print("deleted"));

}
