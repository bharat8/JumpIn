import 'package:JumpIn/features/interests/interest_page_provider.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ServicePeopleProfileController extends ChangeNotifier {
  JumpinUser user;
  ConnectionUser connectionUser;

  List<String> _bookMarkIds = [];

  String _reqStatus;

  Map<String, String> interestsList = {};

  String get getReqStatus => _reqStatus;
  set setReqStatus(String val) {
    _reqStatus = val;
  }

  String _userLocation;

  String get getUserLocation => _userLocation;

  bool _addedToBookmarks = false;
  bool get getBookmarksStatus => _addedToBookmarks;

  Map<String, String> _mutualInterests = {};
  Map<String, String> get mutualInterests => _mutualInterests;

  List<String> _mutualFriends = [];
  List<String> get mutualFriends => _mutualFriends;

  List<String> _mutualFriendsLess = [];
  List<String> get mutualFriendsLess => _mutualFriendsLess;

  List<String> _imageURLs = [];

  List<String> get getImageURLs => _imageURLs;

  bool _isLoading = false;
  bool get getLoadingStatus => _isLoading;

  bool _isLoadingAfterAcceptReject = false;
  bool get getLoadingStatusAfterAcceptReject => _isLoadingAfterAcceptReject;
  set setLoadingStatusAfterAcceptReject(bool val) {
    _isLoadingAfterAcceptReject = val;
    notifyListeners();
  }

  bool _isAccepted = false;
  bool get getAcceptedStatus => _isAccepted;
  set setAcceptedStatus(bool val) {
    _isAccepted = val;
    notifyListeners();
  }

  bool _isRejected = false;
  bool get getRejectedStatus => _isRejected;
  set setRejectedStatus(bool val) {
    _isRejected = val;
    notifyListeners();
  }

  bool _isContactPermGranted = false;
  bool get getContactPermStatus => _isContactPermGranted;
  set setContactPermStatus(bool val) {
    _isContactPermGranted = val;
    notifyListeners();
  }

  bool _mutualFriendsLoading = false;
  bool get mutualFriendsLoadingStatus => _mutualFriendsLoading;
  set mutualFriendsLoadingStatus(bool val) {
    _mutualFriendsLoading = val;
    notifyListeners();
  }

  void clearData() {
    user = null;
    connectionUser = null;
    _bookMarkIds = [];
    _reqStatus = null;
    _userLocation = null;
    _addedToBookmarks = false;
    _mutualInterests = {};
    _mutualFriendsLess = [];
    _mutualFriends = [];
    _imageURLs = [];
    _isLoading = false;
  }

  Future<bool> getUserDetails(BuildContext context, String userId) async {
    _isLoading = true;
    final snap =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    user = JumpinUser.fromDocument(snap.data());
    connectionUser = ConnectionUser(
        id: user.id,
        username: user.username,
        fullname: user.fullname,
        avatarImageUrl: user.photoUrl);

    final docSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .get();

    final interestProv =
        Provider.of<InterestPageProvider>(context, listen: false);

    List userInterestList = docSnap.data()["interestList"] as List;
    List profileInterestList = user.interestList;
    List mutualInteretList = [];

    mutualInteretList = userInterestList
        .where((element) => profileInterestList.contains(element))
        .toList();

    interestProv.getSubCategories.values.toList().forEach((element) {
      user.interestList.forEach((interest) {
        if ((element as Map).containsKey(interest) &&
            !mutualInteretList.contains(interest)) {
          interestsList[interest as String] = element[interest][1] as String;
        }
      });
      mutualInteretList.forEach((interest) {
        if ((element as Map).containsKey(interest)) {
          _mutualInterests[interest as String] = element[interest][1] as String;
        }
      });
    });

    _imageURLs = [user.photoUrl];
    if (user.photoLists.isNotEmpty) {
      user.photoLists.forEach((element) {
        if (!_imageURLs.contains(element)) _imageURLs.add(element as String);
      });
    }
    Map<String, String> _mutualPhoneNos = {};
    // print(snap.data()["contacts"]);
    // if (snap.data()["contacts"] != null && docSnap.data()["contacts"] != null) {
    //   (snap.data()["contacts"] as Map).forEach((profileName, profilePhoneNos) {
    //     (docSnap.data()["contacts"] as Map).forEach((userName, userPhoneNos) {
    //       if ((profilePhoneNos as List)
    //               .any((element) => (userPhoneNos as List).contains(element)) &&
    //           !_mutualFriends.contains(userName)) {
    //         _mutualFriends.add(userName as String);
    //         // _mutualPhoneNos.add
    //       }
    //     });
    //   });
    // }

    if (snap.data()["contacts"] != null && docSnap.data()["contacts"] != null)
      (snap.data()["contacts"] as List).forEach((profilePhoneNos) {
        (docSnap.data()["contacts"] as List).forEach((userPhoneNos) {
          if ((profilePhoneNos["phoneNumbers"] as List).any((element) =>
                  (userPhoneNos["phoneNumbers"] as List).contains(element)) &&
              !_mutualFriends.contains(userPhoneNos["name"])) {
            _mutualFriends.add(userPhoneNos["name"]);
          }
        });
      });

    for (int i = 0; i < _mutualFriends.length; i++) {
      if (i <= 3) _mutualFriendsLess.add(_mutualFriends[i]);
    }

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    snapshot.docs.forEach((element) {
      String phone = (element["phoneNo"] as String).replaceRange(0, 2, "");
    });

    final List reqReceivedList = docSnap
        .data()['requestReceivedFrom']
        .map((rr) => rr as String)
        .toList() as List;

    final List reqSentList = docSnap
        .data()['requestSentTo']
        .map((rs) => rs as String)
        .toList() as List;

    if ((docSnap.data()['bookmarks'] as List) != null) {
      (docSnap.data()['bookmarks'] as List).forEach((bookMark) {
        if (!_bookMarkIds.contains(bookMark['id'])) {
          _bookMarkIds.add(bookMark['id'] as String);
        }
      });
    }

    if (_bookMarkIds.contains(connectionUser.id)) {
      _addedToBookmarks = true;
    } else {
      _addedToBookmarks = false;
    }

    if (reqReceivedList.contains(userId)) {
      _reqStatus = "reqReceived";
    } else if (reqSentList.contains(userId)) {
      _reqStatus = "reqSent";
    } else {
      _reqStatus = "neitherReceivednorSent";
    }
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future getContactsStatus() async {
    if (await Permission.contacts.isGranted) {
      _isContactPermGranted = true;
    }
  }

  Future<String> determinePosition() async {
    print(user.geoPoint.latitude);

    if (user.geoPoint.latitude == 0.0 || user.geoPoint.longitude == 0.0) {
      _userLocation = "N/A";
      return "N/A";
    }
    final coordinates =
        Coordinates(user.geoPoint.latitude, user.geoPoint.longitude);

    final List<Address> addressesList =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    _userLocation = addressesList.first.adminArea;
    return addressesList.first.adminArea;
  }

  Future addRemoveBookmarks(JumpinUser ju, BuildContext context) async {
    DocumentSnapshot userref = await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .get();

    if (userref.exists) {
      print(_bookMarkIds);
      if (!_bookMarkIds.contains(connectionUser.id)) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPrefs.userid)
            .update({
          "bookmarks": FieldValue.arrayUnion([JumpinUser.toMap(ju)])
        }).then((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop(true);
                });
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Lottie.asset('assets/animations/success.json',
                      repeat: false, animate: true),
                );
              }).then((_) {
            _addedToBookmarks = true;
            _bookMarkIds.add(connectionUser.id);
            notifyListeners();
          });
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Undo Bookmark",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                content: Text("Are you sure you want to remove the bookmark ?",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16)),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xffe6ecf2),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(sharedPrefs.userid)
                          .get()
                          .then((doc) {
                        List oldBookMarks = [];
                        List newBookMarks = [];
                        (doc.data()["bookmarks"]).forEach((bookMarkUser) {
                          if (bookMarkUser["id"] != ju.id) {
                            newBookMarks.add(bookMarkUser);
                          }
                          oldBookMarks.add(bookMarkUser);
                        });

                        // print("OldBookmarks ===================");
                        // oldBookMarks.forEach((element) {
                        //   print(element["id"]);
                        // });
                        // print("NewBookmarks ===================");
                        // newBookMarks.forEach((element) {
                        //   print(element["id"]);
                        // });
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(sharedPrefs.userid)
                            .update({
                          "bookmarks": FieldValue.arrayRemove(oldBookMarks)
                        }).then((_) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(sharedPrefs.userid)
                              .update({
                            "bookmarks": FieldValue.arrayUnion(newBookMarks)
                          });
                        });
                      }).then((_) {
                        Navigator.of(context).pop();
                        _addedToBookmarks = false;
                        _bookMarkIds.remove(connectionUser.id);
                        notifyListeners();
                      });
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                      child: Text("Confirm"),
                    ),
                  ),
                ],
              );
            });
      }
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPrefs.userid)
          .set({
        "bookmarks": FieldValue.arrayUnion([JumpinUser.toMap(ju)])
      }).then((_) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Lottie.asset('assets/animations/success.json',
                    repeat: false, animate: true),
              );
            }).then((_) {
          _addedToBookmarks = true;
          _bookMarkIds.add(connectionUser.id);
          notifyListeners();
        });
      });
    }
  }

  void acceptCancelJumpinRequest(
      ServiceJumpinPeopleHome controller, BuildContext context) {
    controller.changeReqProcessingStatus(true);

    if (controller.listOfAllReqUserSent.contains(connectionUser.id)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Undo Request",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              content: Text(
                  "Are you sure you want to cancel the connection request ?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16)),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffe6ecf2),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => controller
                      .undoConnectionRequest(connectionUser, context)
                      .then(
                        (_) => Navigator.of(context).pop(),
                      ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                    child: Text("Confirm"),
                  ),
                ),
              ],
            );
          });
    } else {
      controller.sendConnectionRequest(connectionUser, context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Lottie.asset('assets/animations/success.json',
                  repeat: false, animate: true),
            );
          });
    }
  }
}
