import 'dart:io';

import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileProvider extends ChangeNotifier {
  File _image;
  File get getImageFile => _image;

  String _imagePath;

  bool _errorShown = true;
  bool get getErrorStatus => _errorShown;
  set setErrorStatus(bool val) => _errorShown = val;

  bool _imageSelected = false;
  bool get getImageSelectedStatus => _imageSelected;
  set setImageSelectedStatus(bool val) => _imageSelected = val;

  Future selectImage(String source) async {
    final picker = ImagePicker();
    PickedFile pickedFile;

    if (source == "gallery") {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    } else {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    }

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _imagePath = pickedFile.path;
      _imageSelected = true;
      _errorShown = false;
    } else {
      print(pickedFile.path);
      print('No image selected.');
      if (_image == null) {
        _errorShown = true;
      }
    }
    notifyListeners();
  }

  Future uploadToDatabase() async {
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref("userPhotos/${sharedPrefs.userid}/avatar_${sharedPrefs.userid}")
        .putFile(_image);

    snapshot.ref.getDownloadURL().then((value) {
      String avatarUrl = value;
      FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPrefs.userid)
          .update({"photoUrl": avatarUrl});

      sharedPrefs.photoUrl = avatarUrl;

      // List<String>
      // FirebaseFirestore.instance.collection("users").get().then((querySnap) {
      //   querySnap.docs.forEach((doc) {
      //     if ((doc.data()["myConnections"] as List).isNotEmpty) {
      //       (doc.data()["myConnections"] as List).forEach((data) {
      //         if (data["id"] == sharedPrefs.userid) {
      //           FirebaseFirestore.instance
      //               .collection("users")
      //               .doc(doc.id)
      //               .update({"photoUrl": avatarUrl});
      //         }
      //       });
      //     }
      //   });
      // });
    });
  }

  List _userNamesWithIds = [];
  List get userNamesWithIds => _userNamesWithIds;

  List _tempUserNamesWithIds = [];
  List get tempUserNamesWithIds => _tempUserNamesWithIds;

  bool _isLoading = false;
  bool get getLoadingStatus => _isLoading;

  bool _isUserNameError = false;
  bool get getUserNameErrorStatus => _isUserNameError;

  String _userNameErrorText;
  String get getUserNameErrorText => _userNameErrorText;

  Future searchUserName(String searchText) async {
    if (searchText.isEmpty) {
      _userNamesWithIds = [];
      _tempUserNamesWithIds = [];
      notifyListeners();
    }
    String queryText;
    if (searchText.isNotEmpty) {
      queryText =
          searchText.substring(0, 1).toLowerCase() + searchText.substring(1);
    }

    if (_userNamesWithIds.isEmpty && searchText.length == 1) {
      _isLoading = true;
      notifyListeners();
      FirebaseFirestore.instance
          .collection("users")
          .where("userNameSearchIndex",
              isEqualTo: searchText.substring(0, 1).toLowerCase())
          .get()
          .then((result) {
        _isLoading = false;
        notifyListeners();
        result.docs.forEach((element) {
          _userNamesWithIds.add({
            "id": element["id"],
            "userName": element["username"],
            "photoUrl": element["photoUrl"]
          });
          notifyListeners();
        });
      });
      FirebaseFirestore.instance
          .collection("users")
          .where("userNameSearchIndex",
              isEqualTo: searchText.substring(0, 1).toUpperCase())
          .get()
          .then((result) {
        _isLoading = false;
        notifyListeners();
        result.docs.forEach((element) {
          _userNamesWithIds.add({
            "id": element["id"],
            "userName": element["username"],
            "photoUrl": element["photoUrl"]
          });
          notifyListeners();
        });
      });
    } else {
      _tempUserNamesWithIds = [];
      _userNamesWithIds.forEach((element) {
        if ((element["userName"] as String).startsWith(queryText)) {
          _tempUserNamesWithIds.add(element);
          notifyListeners();
        }
      });
    }
    _tempUserNamesWithIds.forEach((element) {
      if (element["userName"] == queryText) {
        print(true);
        print(element["userName"]);
        _userNameErrorText =
            "${element["userName"]} is already taken. Please choose another";
        _isUserNameError = true;
      } else {
        print(false);
        _userNameErrorText = null;
        _isUserNameError = false;
      }
    });
  }
}
