import 'package:JumpIn/features/interests/interest_page_provider.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UserProfileController extends ChangeNotifier {
  JumpinUser _currentUserProfileUser;

  JumpinUser get currentUserProfileUser => _currentUserProfileUser;

  Map<String, String> interestsList = {};

  String _userLocation;

  String get getUserLocation => _userLocation;

  List<String> _imageURLs = [];

  List<String> get getImageURLs => _imageURLs;

  void getUserDocumentSnapshot(BuildContext context, snapshot) {
    _currentUserProfileUser = JumpinUser.fromDocument(snapshot.data());

    final interestProv =
        Provider.of<InterestPageProvider>(context, listen: false);
    _currentUserProfileUser.interestList.forEach((interest) {
      interestProv.getSubCategories.values.toList().forEach((element) {
        if ((element as Map).containsKey(interest)) {
          interestsList[interest as String] = element[interest][1] as String;
        }
      });
    });
    _imageURLs = [_currentUserProfileUser.photoUrl];
    if (_currentUserProfileUser.photoLists.isNotEmpty) {
      _currentUserProfileUser.photoLists.forEach((element) {
        if (!_imageURLs.contains(element)) _imageURLs.add(element as String);
      });
    }
  }

  Future<String> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.deniedForever:
        print("denier forever");
        _userLocation = null;
        return null;
        break;
      case LocationPermission.denied:
        print("denied");
        _userLocation = null;
        return null;
        break;
      case LocationPermission.always:
        print("always");
        _userLocation = await calDistance();
        return _userLocation;
        break;
      case LocationPermission.whileInUse:
        print(LocationPermission.whileInUse);
        _userLocation = await calDistance();
        return _userLocation;
        break;
      default:
        _userLocation = null;
        return null;
        break;
    }
  }

  Future<String> calDistance() async {
    Position pos;

    pos = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    );

    if (pos != null) {
      return getAbsoluteLocation(pos);
    } else {
      pos = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true,
      );
      if (pos == null) {
        return "N/A";
      } else {
        return getAbsoluteLocation(pos);
      }
    }
  }

  Future<String> getAbsoluteLocation(Position pos) async {
    final coordinates = Coordinates(pos.latitude, pos.longitude);
    sharedPrefs.myLatitude = pos.latitude.toString();
    sharedPrefs.myLongitude = pos.longitude.toString();

    List<Address> addressesList;
    try {
      addressesList =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
    } catch (e) {
      return "N/A";
    }

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .update({
      "geoPoint": GeoPoint(double.parse(sharedPrefs.myLatitude),
          double.parse(sharedPrefs.myLongitude))
    });
    sharedPrefs.savedLocationCity = addressesList.first.adminArea;
    return addressesList.first.adminArea;
  }

  Future<void> calDistanceAfterReject(BuildContext context) async {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: Container(
              width: size.width * 0.7,
              height: size.height * 0.3,
              // color: Colors.black12,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: constraints.maxHeight * 0.15,
                          height: constraints.maxHeight * 0.15,
                          child: Image.asset(
                              "assets/images/SideNav/placeholder.png")),
                      Text(
                          "Please enable location permissions to get the most out of JumpIn",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontWeight: FontWeight.w600,
                              fontSize: size.height * 0.02)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: constraints.maxWidth * 0.4,
                              height: constraints.maxHeight * 0.2,
                              decoration: BoxDecoration(
                                  color: Colors.red[700],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.005),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.height * 0.025),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              AppSettings.openAppSettings();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: constraints.maxWidth * 0.4,
                              height: constraints.maxHeight * 0.2,
                              decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.005),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.height * 0.025),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                },
              )),
        );
      },
    );
  }

  void handleError(BuildContext ctx) {
    SizeConfig().init(ctx);
    showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
                title: Text(
              "$Error,Try Again!",
              style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
            )));
  }

  Future<void> postUserAbout(String userAbout, BuildContext context) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(sharedPrefs.userid)
          .update({'userProfileAbout': userAbout}).then((value) => showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Updated"),
                  )));
    } catch (e) {
      print("caught error $e");
      handleError(context);
    }
  }

  Future<void> postImInJumpinFor(
      String inJumpinFor, BuildContext context) async {
    print("inside user in jumpin for");
    try {
      circularProgressIndicator();
      FirebaseFirestore.instance
          .collection('users')
          .doc(sharedPrefs.userid)
          .update({'inJumpinFor': inJumpinFor}).then((value) => showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Updated"),
                  )));
    } catch (e) {
      handleError(context);
    }
  }

  Future<void> uploadPhotoToFirestore(downloadUrl) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .update({
      "photoLists": FieldValue.arrayUnion([downloadUrl])
    });
  }

  // Future<void> deleteImageFromFirebaseStorage(String imageFileUrl) async {
  //   if (imageFileUrl != null) {
  //     var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
  //         .replaceAll(RegExp(r'(\?alt).*'), '');

  //     final Reference photoRef =
  //         await FirebaseStorage.instance.ref().child(fileUrl);
  //     // try {
  //     //   photoRef.delete();
  //     // }on StorageException catch (e) {
  //     //   print("Exception occured");
  //     // }
  //     //-----implement storage exception----
  //     await photoRef
  //         .delete()
  //         .whenComplete(() => deleteFromFirebaseFirestore(imageFileUrl));
  //   }

  Future<void> deleteFromFirebaseFirestore(imageFileUrl) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .update({
      'photoLists': FieldValue.arrayRemove([imageFileUrl])
    }).then((_) => print("deleted"));
  }
}
