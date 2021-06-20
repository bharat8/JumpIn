import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:JumpIn/core/network/chat_service.dart';
import 'package:JumpIn/core/network/service_people_profile.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user_status.dart';
import 'package:JumpIn/features/people_home/presentation/screen_people_home.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_notifications/domain/notification_service.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/state_manager.dart';
import 'package:path_provider/path_provider.dart';

class ServiceJumpinPeopleHome extends ChangeNotifier {
  List<JumpinUser> _jumpinUserList = [];
  static JumpinUser currentUser = JumpinUser();
  var jumpinReqProcessing = false;

  List<Map<dynamic, dynamic>> peoplesConnections = [];

  List<String> currentUserRequestingUserids = [];
  //List<String> listOfAllReqUserSent = <String>[].obs;
  List<String> listOfAllReqUserSent = [];

  List<ConnectionUser> currentUserConnections = [];

  List<ModelJumpinUserStatus> reqStatusList = [];

  List<JumpinUser> get jumpinUser => _jumpinUserList;

  Map<String, double> _vibeOfUsers = {};

  Map<String, double> get getVibeOfUsers => _vibeOfUsers;

  bool _locationAfterEnablingPermission = false;
  bool get locationAfterEnablingPermission => _locationAfterEnablingPermission;
  set locationAfterEnablingPermission(bool val) {
    _locationAfterEnablingPermission = val;
    notifyListeners();
  }

  String _selectedList = "People";
  String get getSelectedList => _selectedList;
  set setSelectedList(String val) {
    _selectedList = val;
    notifyListeners();
  }

  bool _isLocationLoading = false;
  bool get getLocationLoadingStatus => _isLocationLoading;
  set setLocationLoadingStatus(bool val) {
    _isLocationLoading = val;
    notifyListeners();
  }

  bool _isLoadingAfterAcceptReject = false;
  bool get getLoadingStatusAfterAcceptReject => _isLoadingAfterAcceptReject;
  set setLoadingStatusAfterAcceptReject(bool val) {
    _isLoadingAfterAcceptReject = val;
    notifyListeners();
  }

  List _acceptedList = [];
  List get getAcceptedList => _acceptedList;
  set setAcceptedList(List list) {
    _acceptedList = list;
    notifyListeners();
  }

  void addAccepted(String id) {
    if (!_acceptedList.contains(id)) {
      _acceptedList.add(id);
    }
    notifyListeners();
  }

  void removeCurrentReqId(String id) {
    currentUserRequestingUserids.remove(id);
    notifyListeners();
  }

  void changeReqProcessingStatus(bool status) {
    jumpinReqProcessing = status;
    notifyListeners();
  }

  bool _isFiltersSelected = false;
  bool get getFiltersSelectionStatus => _isFiltersSelected;

  void setFilterSelectionStatus(bool val) {
    _isFiltersSelected = val;
    notifyListeners();
  }

  List<JumpinUser> _filteredList = [];
  List<JumpinUser> get getFilteredList => _filteredList;
  set setFilteredList(List<JumpinUser> users) => _filteredList = users;

  List _vibe = [
    {"name": "High to Low", "value": false},
    {"name": "Low to High", "value": false}
  ];

  List get vibe => _vibe;

  RangeValues _distanceRangeValues;
  RangeValues get distanceRangeValues => _distanceRangeValues;
  set distanceRangeValues(RangeValues rangeValues) =>
      _distanceRangeValues = rangeValues;

  RangeLabels _distanceRangeLabels;
  RangeLabels get distanceRangeLabels => _distanceRangeLabels;
  set distanceRangeLabels(RangeLabels rangeLabels) =>
      _distanceRangeLabels = rangeLabels;

  RangeValues _ageRangeValues;
  RangeValues get ageRangeValues => _ageRangeValues;
  set ageRangeValues(RangeValues rangeValues) => _ageRangeValues = rangeValues;

  RangeLabels _ageRangeLabels;
  RangeLabels get ageRangeLabels => _ageRangeLabels;
  set ageRangeLabels(RangeLabels rangeLabels) => _ageRangeLabels = rangeLabels;

  List _gender = [
    {
      "name": "male",
      "image": "assets/images/Onboarding/gender_male.png",
      "value": false
    },
    {
      "name": "female",
      "image": "assets/images/Onboarding/gender_female.png",
      "value": false
    },
    {
      "name": "non-binary",
      "image": "assets/images/Onboarding/gender_non_binary.png",
      "value": false
    }
  ];

  List get gender => _gender;

  List<String> _interests = [];
  List<String> get interests => _interests;

  List _mutualFriendsShow = [
    {"name": "Yeah!", "value": false},
    {"name": "Nah!", "value": false}
  ];

  List get mutualFriendsShow => _mutualFriendsShow;

  // bool _isInterestEmpty = false;
  // bool get getRandomSelectionStatus => _isRandomSelected;

  bool _isRandomSelected = false;
  bool get getRandomSelectionStatus => _isRandomSelected;
  void setRandomSelectionStatus(bool val) {
    setFilterSelectionStatus(true);
    _isRandomSelected = val;
    if (_isRandomSelected == true) {
      _vibe.forEach((element) {
        if (element["value"] == true) {
          element["value"] = false;
        }
      });
    }
    finaliseFilters();
    notifyListeners();
  }

  void selectVibeFilter(String vibeName) {
    setFilterSelectionStatus(true);
    _vibe.forEach((element) async {
      if (element["name"] == vibeName) {
        if (element["value"] == false) {
          element["value"] = true;
          _isRandomSelected = false;
        }
      } else {
        element["value"] = false;
      }
    });
    finaliseFilters();
    notifyListeners();
  }

  void selectDistanceFilter(RangeValues newRangeVal) {
    setFilterSelectionStatus(true);
    _distanceRangeValues = newRangeVal;
    _distanceRangeLabels = RangeLabels(
        "${newRangeVal.start.toInt()} kms",
        newRangeVal.end == 5000
            ? "${newRangeVal.end.toInt()}+ kms"
            : "${newRangeVal.end.toInt()} kms");
    finaliseFilters();
    notifyListeners();
  }

  void selectAgeFilter(RangeValues newRangeVal) {
    setFilterSelectionStatus(true);
    _ageRangeValues = newRangeVal;
    _ageRangeLabels = RangeLabels(
        "${newRangeVal.start.toInt()} years",
        newRangeVal.end == 75
            ? "${newRangeVal.end.toInt()}+ years"
            : "${newRangeVal.end.toInt()} years");
    finaliseFilters();
    notifyListeners();
  }

  void selectGenderFilter(String gender) {
    setFilterSelectionStatus(true);
    _gender.forEach((element) {
      if (element["name"] == gender) {
        element["value"] = true;
      } else {
        element["value"] = false;
      }
    });
    finaliseFilters();
    notifyListeners();
  }

  void selectInterestsFilter(List<String> selectedInterests) {
    setFilterSelectionStatus(true);
    _interests = selectedInterests;
    finaliseFilters();
    notifyListeners();
  }

  void selectMutualFriendsFilter(String val) {
    setFilterSelectionStatus(true);
    _mutualFriendsShow.forEach((element) {
      if (element["name"] == val) {
        element["value"] = true;
      } else {
        element["value"] = false;
      }
    });
    finaliseFilters();
    notifyListeners();
  }

  void removeItems(int index) {
    _interests.removeAt(index);
    finaliseFilters();
    notifyListeners();
  }

  void finaliseFilters() async {
    if (_isFiltersSelected == true) {
      String _genderSelected;
      _gender.forEach((element) {
        if (element["value"] == true) {
          _genderSelected = element["name"] as String;
        }
      });

      for (var i = 0; i < _jumpinUserList.length; i++) {
        double location = LocationUtils.getDistance(
                _jumpinUserList[i].geoPoint.latitude.toDouble(),
                _jumpinUserList[i].geoPoint.longitude.toDouble())
            .toDouble();

        if (((_distanceRangeValues.end < 5000 &&
                    (location >= _distanceRangeValues.start) &&
                    (location <= _distanceRangeValues.end)) ||
                (_distanceRangeValues.end == 5000 &&
                    (location >= _distanceRangeValues.start))) &&
            (((DateTime.now().year - _jumpinUserList[i].dob.toDate().year) >=
                    _ageRangeValues.start) &&
                ((DateTime.now().year - _jumpinUserList[i].dob.toDate().year) <=
                    _ageRangeValues.end)) &&
            ((_genderSelected != null &&
                    _jumpinUserList[i].gender == _genderSelected) ||
                (_genderSelected == null)) &&
            (_filteredList.contains(_jumpinUserList[i]) == false)) {
          _filteredList.add(_jumpinUserList[i]);
        }
      }

      print("filteredList =========== here");
      print(_filteredList.length);

      List<JumpinUser> tempList = [];

      for (var i = 0; i < _filteredList.length; i++) {
        double location = LocationUtils.getDistance(
                _filteredList[i].geoPoint.latitude.toDouble(),
                _filteredList[i].geoPoint.longitude.toDouble())
            .toDouble();

        if (((_distanceRangeValues.end < 5000 &&
                    (location >= _distanceRangeValues.start) &&
                    (location <= _distanceRangeValues.end)) ||
                (_distanceRangeValues.end == 5000 &&
                    (location >= _distanceRangeValues.start))) &&
            (((DateTime.now().year - _filteredList[i].dob.toDate().year) >=
                    _ageRangeValues.start) &&
                ((DateTime.now().year - _filteredList[i].dob.toDate().year) <=
                    _ageRangeValues.end)) &&
            ((_genderSelected != null &&
                    _filteredList[i].gender == _genderSelected) ||
                (_genderSelected == null))) {
          tempList.add(_filteredList[i]);
        }
      }

      _filteredList = tempList;
      print(_filteredList.length);

      if (_interests.isNotEmpty) {
        List<JumpinUser> _interestIncludedList = [];
        for (var i = 0; i < _filteredList.length; i++) {
          bool _isInterestsPresent = false;
          _filteredList[i].interestList.forEach((interest1) {
            if (_interests.contains(interest1)) {
              _isInterestsPresent = true;
            }
          });

          if (_isInterestsPresent == true && _interests.isNotEmpty) {
            _interestIncludedList.add(_filteredList[i]);
          }
        }

        _filteredList = _interestIncludedList;
      }

      // print(_filteredList.length);

      //Vibe Sort
      String _vibeSelection;
      _vibe.forEach((element) {
        if (element["value"] == true) {
          _vibeSelection = element["name"] as String;
        }
      });

      if (_vibeSelection != null && _isRandomSelected == false) {
        var temp = _vibeOfUsers;
        LinkedHashMap sortedMap;
        if (_vibeSelection == "High to Low") {
          var sortedKeys = temp.keys.toList(growable: false)
            ..sort((k2, k1) => temp[k1].compareTo(temp[k2]));
          sortedMap = LinkedHashMap.fromIterable(sortedKeys,
              key: (k) => k, value: (k) => temp[k]);
        } else {
          var sortedKeys = temp.keys.toList(growable: false)
            ..sort((k1, k2) => temp[k1].compareTo(temp[k2]));
          sortedMap = LinkedHashMap.fromIterable(sortedKeys,
              key: (k) => k, value: (k) => temp[k]);
        }
        print(sortedMap);
        print(_filteredList.length);

        List<JumpinUser> _sortedUsers = [];
        sortedMap.keys.forEach((element) {
          if (_filteredList.any((user) => user.id == element)) {
            _sortedUsers.add(_filteredList[
                _filteredList.indexWhere((user) => user.id == element)]);
          }
        });

        _filteredList = _sortedUsers;
      }

      if (_isRandomSelected == true) {
        _filteredList.shuffle();
      }

      print("filtered");
      _filteredList.forEach((element) {
        print(element.id);
      });
      print(_filteredList.length);
    }
  }

  void resetFiltersData() {
    _isFiltersSelected = false;
    _filteredList = [];
    _vibe = [
      {"name": "High to Low", "value": false},
      {"name": "Low to High", "value": false}
    ];
    _distanceRangeValues = RangeValues(0, 5000);
    _distanceRangeLabels = RangeLabels(
        "${_distanceRangeValues.start.toInt()} kms",
        "${_distanceRangeValues.end.toInt()} kms");
    _ageRangeValues = RangeValues(13, 75);
    _ageRangeLabels = RangeLabels("${_ageRangeValues.start.toInt()} years",
        "${_ageRangeValues.end.toInt()} years");
    _gender = [
      {
        "name": "male",
        "image": "assets/images/Onboarding/gender_male.png",
        "value": false
      },
      {
        "name": "female",
        "image": "assets/images/Onboarding/gender_female.png",
        "value": false
      },
      {
        "name": "non-binary",
        "image": "assets/images/Onboarding/gender_non_binary.png",
        "value": false
      }
    ];
    _interests = [];
    _mutualFriendsShow = [
      {"name": "Yeah!", "value": false},
      {"name": "Nah!", "value": false}
    ];
    _filteredList = [];
    _isRandomSelected = false;
    notifyListeners();
  }

  Future<bool> capturePng(String userid, GlobalKey _globalKey) async {
    print("indise captrujed ====================");
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    print(pngBytes);
    final documentDirectory = (await getExternalStorageDirectory()).path;
    final File imgFile = File('$documentDirectory/${userid}_image.png');
    imgFile.writeAsBytesSync(pngBytes);
    print(imgFile.path);
    return true;
  }

  Future getUsersList() async {
    QuerySnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").get();
    print("here");
    List<JumpinUser> user = [];
    if (docSnap != null) {
      docSnap.docs.forEach((doc) {
        user.add(JumpinUser(
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
            photoLists:
                List<String>.from(doc['photoLists'] as Iterable<dynamic>),
            email: doc['email'] as String,
            requestSentTo: doc['requestSentTo'] as List<dynamic>,
            requestReceivedFrom: doc['requestReceivedFrom'] as List<dynamic>,
            phoneNo: doc['phoneNo'] as String,
            interestList:
                List<String>.from(doc['interestList'] as Iterable<dynamic>),
            userProfileAbout: doc['userProfileAbout'] as String,
            geoPoint: doc['geoPoint'] as GeoPoint ?? const GeoPoint(0.0, 0.0),
            inJumpinFor: doc['inJumpinFor'] as String,
            myConnections: doc['myConnections'] as List<dynamic>));
      });
      //assigning current user
      user.forEach((x) {
        try {
          if (x.id == sharedPrefs.userid) {
            currentUser = x;
          }
        } on NoSuchMethodError catch (e) {
          print("No such method error");
        }
      });

      //removing current user
      try {
        user.removeWhere((element) => element.id == sharedPrefs.userid);
      } on NoSuchMethodError catch (e) {
        print("no such method error");
      }

      // user.shuffle();
    }

    _jumpinUserList = user;

    doSomePrelimsOnUserList();
  }

  void doSomePrelimsOnUserList() {
    removeMyConnectionsFromHomeUserList();
    getPeopleWhoRequestMe();
    getPeopleWhomIRequested();
    populatePeopleConnection();
    calculateVibeOfUsers();
  }

  Future calculateVibeOfUsers() async {
    List list = jsonDecode(sharedPrefs.getVibeWithPeopleList);

    for (var i = 0; i < list.length; i++) {
      _vibeOfUsers.addAll({list[i]["peopleId"]: list[i]["peopleVibe"]});
    }
  }

  void removeMyConnectionsFromHomeUserList() {
    if (currentUser.myConnections != null) {
      currentUser.myConnections.forEach((connection) {
        try {
          _jumpinUserList.removeWhere((user) => user.id == connection['id']);

          //populate current user connections
          currentUserConnections
              .add(ConnectionUser.fromJson(connection as Map<String, dynamic>));
        } on NoSuchMethodError catch (e) {
          print("NO SUCH METHOD ERROR");
        }
      });
    } else {
      print("connections of current user is null");
    }
  }

  void populatePeopleConnection() {
    _jumpinUserList.forEach((user) {
      if (user.myConnections != null) {
        List<ConnectionUser> cus = [];
        user.myConnections.forEach((json) {
          cus.add(ConnectionUser.fromJson(json as Map<String, dynamic>));
        });

        ScreenPeopleHome.peopleConnections.add({user.id.toString(): cus});
      }
    });
  }

  void getPeopleWhoRequestMe() {
    currentUserRequestingUserids = List.from(currentUser.requestReceivedFrom);
  }

  void getPeopleWhomIRequested() {
    listOfAllReqUserSent = List.from(currentUser.requestSentTo);
  }

  Future<void> sendConnectionRequest(
      ConnectionUser cu, BuildContext context) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .get()
        .then((userDoc) {
      if (userDoc.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(sharedPrefs.userid)
            .update({
          "requestSentTo": FieldValue.arrayUnion([cu.id])
        }).then((_) {
          print("\n\nreqprocessing -> $jumpinReqProcessing");
          listOfAllReqUserSent.add(cu.id);
          jumpinReqProcessing = false;
          notifyListeners();
          updateReceiverDatabase(cu, sendReq, context).then((_) {
            upadtingReqSentList();
          });
        }).catchError((e) => showDialog(
                context: context,
                builder: (_) {
                  return Text("Try again!");
                }));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(sharedPrefs.userid)
            .set({
          "requestSentTo": FieldValue.arrayUnion([cu.id]),
          "requestReceivedFrom": [],
          "myConnections": []
        }, SetOptions(merge: true)).then((_) {
          print("\n\njumpinReqSent -> $jumpinReqProcessing");
          listOfAllReqUserSent.add(cu.id);
          jumpinReqProcessing = false;
          notifyListeners();
          updateReceiverDatabase(cu, sendReq, context).then((_) {
            upadtingReqSentList();
          });
        }).catchError((e) => showDialog(
                context: context,
                builder: (_) {
                  return Text("Try again!");
                }));
      }
    });
  }

  Future<void> undoConnectionRequest(
      ConnectionUser cu, BuildContext context) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .get()
        .then((userDoc) {
      if (userDoc.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(sharedPrefs.userid)
            .update({
          "requestSentTo": FieldValue.arrayRemove([cu.id])
        }).then((_) {
          print("\n\njumpinReqSent -> $jumpinReqProcessing");
          listOfAllReqUserSent.remove(cu.id);
          jumpinReqProcessing = false;
          print("\n\nupdating undo");
          notifyListeners();
          updateReceiverDatabase(cu, undoReq, context).then((_) {
            upadtingReqSentList();
          });
        }).catchError((e) => showDialog(
                context: context,
                builder: (_) {
                  return const Text("Try again!");
                }));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(sharedPrefs.userid)
            .set({
          "requestSentTo": FieldValue.arrayRemove([cu.id]),
          "requestReceivedFrom": [],
          "myConnections": []
        }, SetOptions(merge: true)).then((_) {
          print("\n\nreqprocessing -> $jumpinReqProcessing");
          listOfAllReqUserSent.remove(cu.id);
          jumpinReqProcessing = false;
          notifyListeners();
          updateReceiverDatabase(cu, undoReq, context).then((_) {
            upadtingReqSentList();
          }).catchError((e) => showDialog(
              context: context,
              builder: (_) {
                return const Text("Try again!");
              }));
        });
      }
    });
  }

  Future<void> updateReceiverDatabase(
      ConnectionUser cu, String instruction, BuildContext context) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(cu.id)
        .get()
        .then((peopleDoc) {
      if (peopleDoc.exists) {
        if (instruction == sendReq) {
          FirebaseFirestore.instance.collection('users').doc(cu.id).update({
            "requestReceivedFrom": FieldValue.arrayUnion([sharedPrefs.userid])
          }).then((_) {
            (NotificationService.requestPendingNotification(
                    cu, sendReq, context) as Future)
                .then((_) => updateStatus(cu, sendReq));
          });
        }
        if (instruction == undoReq) {
          FirebaseFirestore.instance.collection('users').doc(cu.id).update({
            "requestReceivedFrom": FieldValue.arrayRemove([sharedPrefs.userid])
          }).then((_) {
            (NotificationService.requestPendingNotification(
                    cu, undoReq, context) as Future)
                .then((_) => updateStatus(cu, undoReq));
          });
        }
      } else {
        if (instruction == sendReq) {
          FirebaseFirestore.instance.collection('users').doc(cu.id).set({
            "requestReceivedFrom": FieldValue.arrayUnion([sharedPrefs.userid]),
            "requestSentTo": [],
            "myConnections": []
          }, SetOptions(merge: true)).then((_) =>
              (NotificationService.requestPendingNotification(
                      cu, sendReq, context) as Future)
                  .then((_) => updateStatus(cu, sendReq)));
        }
        if (instruction == undoReq) {
          FirebaseFirestore.instance.collection('users').doc(cu.id).set({
            "requestReceivedFrom": FieldValue.arrayRemove([sharedPrefs.userid]),
            "requestSentTo": [],
            "myConnections": []
          }, SetOptions(merge: true)).then((_) =>
              (NotificationService.requestPendingNotification(
                      cu, undoReq, context) as Future)
                  .then((_) => updateStatus(cu, undoReq)));
        }
      }
    });
  }

  void updateStatus(ConnectionUser cu, String status) {
    final ModelJumpinUserStatus modelJumpinUserStatus =
        ModelJumpinUserStatus(reqStatus: status, id: cu.id);
    reqStatusList.add(modelJumpinUserStatus);
  }

  Future<void> upadtingReqSentList() async {
    final List<String> reqSentList = [];
    String reqSentListAsString = "";
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .get()
        .then((doc) {
      doc['requestSentTo'].forEach((userid) {
        reqSentList.add(userid as String);
      });
      reqSentListAsString = jsonEncode(reqSentList);
      sharedPrefs.myPendingConnectionListasString = reqSentListAsString;
    });
  }

  void resetProvData() {
    _jumpinUserList = [];
    _acceptedList = [];
    currentUser = null;
    peoplesConnections = [];
    currentUserRequestingUserids = [];
    listOfAllReqUserSent = [];
    currentUserConnections = [];
    reqStatusList = [];
    _vibeOfUsers = {};
    resetFiltersData();
  }
}
