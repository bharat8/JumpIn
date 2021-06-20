import 'dart:io';

import 'package:JumpIn/core/network/service_user_profile.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfileController extends GetxController {
  JumpinUser _currentEditUser;

  String _userFullNameEdit;

  String _userName;

  String _gender;

  DateTime _dob;

  String _profession;

  String _placeOfWork;

  String _placeOfEdu;

  String _acadCourse;

  String _wtfDesc;

  String _aboutDesc;

  String _imInJumpinFor;

  var isUpdatingUserData = false.obs;

  set setUpdatingUserData(bool val) {
    isUpdatingUserData.value = val;
  }

  var isImagesLoading = false.obs;

  get getImagesLoadingStatus => isImagesLoading;

  set setImagesLoadingStatus(bool val) {
    isImagesLoading.value = val;
  }

  JumpinUser get currentEditUser => _currentEditUser;

  String get userFullNameEdit => _userFullNameEdit;

  String get userName => _userName;

  String get gender => _gender;

  DateTime get dob => _dob;

  set setDob(DateTime time) {
    _dob = time;
  }

  String get profession => _profession;

  String get placeOfWork => _placeOfWork;

  String get placeOfEdu => _placeOfEdu;

  String get acadCourse => _acadCourse;

  String get wtfDesc => _wtfDesc;

  String get aboutDesc => _aboutDesc;

  String get imInJumpinFor => _imInJumpinFor;

  void updateValues(JumpinUser currentUser) {
    _userFullNameEdit = currentUser.fullname;
    //_fullNameEditformKey.text = currentUser.fullname;

    _userName = currentUser.username;
    // _userNameEditformKey.text = currentUser.username;

    _gender = currentUser.gender;
    // _genderEditformKey.text = currentUser.gender;

    _dob = currentUser.dob.toDate();
    // _dobEditformKey.text = currentUser.dob.toDate().toString();

    _profession = currentUser.profession;
    //_professionEditformKey.text = currentUser.profession;

    _placeOfWork = currentUser.placeOfWork;
    //_placeOfWorkformKeyEdit.text = currentUser.placeOfWork;

    _placeOfEdu = currentUser.placeOfEdu;
    //_placeOfEduformKeyEdit.text = currentUser.placeOfEdu;

    _acadCourse = currentUser.acadCourse;
    //_acadCourseformKeyEdit.text = currentUser.acadCourse;

    _wtfDesc = currentUser.wtfDesc;
    //_wtfDescformKeyEdit.text = currentUser.wtfDesc;

    _aboutDesc = currentUser.userProfileAbout;
    //_aboutformKeyEdit.text = currentUser.userProfileAbout;

    _imInJumpinFor = currentUser.inJumpinFor;
    //_imInJumpinForformKeyEdit.text = currentUser.inJumpinFor;
  }

  Future<DocumentSnapshot> getUserDocumentSnapshot() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .get()
        .then((docSnap) {
      _currentEditUser = JumpinUser.fromDocument(docSnap);
      return docSnap;
    });
  }

  Future<void> updateUserOnDatabase() async {
    await Firebase.initializeApp();
    sharedPrefs.fullname = _userFullNameEdit == null
        ? _currentEditUser.fullname
        : _userFullNameEdit;

    sharedPrefs.userName =
        _userName == null ? _currentEditUser.username : _userName;

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .update({
      "fullname": _userFullNameEdit == null
          ? _currentEditUser.fullname
          : _userFullNameEdit,
      "username": _userName == null ? _currentEditUser.username : _userName,
      "profession":
          _profession == null ? _currentEditUser.profession : _profession,
      "placeOfWork":
          _placeOfWork == null ? _currentEditUser.placeOfWork : _placeOfWork,
      "placeOfEdu":
          _placeOfEdu == null ? _currentEditUser.placeOfEdu : _placeOfEdu,
      "acadCourse":
          _acadCourse == null ? _currentEditUser.acadCourse : _acadCourse,
      "wtfDesc": _wtfDesc == null ? _currentEditUser.wtfDesc : _wtfDesc,
      "userProfileAbout":
          _aboutDesc == null ? _currentEditUser.userProfileAbout : _aboutDesc,
      "inJumpinFor":
          _imInJumpinFor == null ? _currentEditUser.inJumpinFor : _imInJumpinFor
    });

    final List<String> docIds = [];
    FirebaseFirestore.instance.collection("chats").get().then((chat) {
      chat.docs.forEach((doc) {
        (doc.data()["users"] as List).forEach((user) {
          if (user["id"] == sharedPrefs.userid) {
            docIds.add(doc.id);
          }
        });
      });
    }).then((_) async {
      for (int j = 0; j < docIds.length; j++) {
        final List oldChatUsersData = [];
        final List updatedChatUsersData = [];
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(docIds[j])
            .get()
            .then((chat) {
          (chat.data()["users"] as List).forEach((user) {
            final ConnectionUser cu =
                ConnectionUser.fromJson(user as Map<String, dynamic>);
            if (user["id"] == sharedPrefs.userid) {
              oldChatUsersData.add(cu.toJson());
              cu.username = _userName ?? _currentEditUser.username;
              cu.fullname = _userFullNameEdit ?? _currentEditUser.fullname;
              updatedChatUsersData.add(cu.toJson());
            } else {
              oldChatUsersData.add(cu.toJson());
              updatedChatUsersData.add(cu.toJson());
            }
          });
        }).then((_) async {
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(docIds[j])
              .update({"users": FieldValue.arrayRemove(oldChatUsersData)});
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(docIds[j])
              .update({"users": FieldValue.arrayUnion(updatedChatUsersData)});
        });
      }
    });
  }

  Future<void> pickImage() async {
    var picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile.path != null) {
      print(File(pickedFile.path));
      File fileName = File(pickedFile.path);
      await uploadImage(fileName);
    }
  }

  Future<void> uploadImage(File fileName) async {
    print("inside upload image");

    var _firebaseStorage = FirebaseStorage.instance;
    try {
      var snapshot = await _firebaseStorage
          .ref(
              '/userPhotos/${sharedPrefs.userid}/${sharedPrefs.userid + "_" + DateTime.now().toString()}')
          .putFile(fileName);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      await uploadPhotoToFirestore(downloadUrl);
    } on FirebaseException catch (e) {
      print("failed");
    }
  }

  void assignValue(int assigningCode, String value) {
    print("inside assignValue with code $assigningCode and value $value");
    switch (assigningCode) {
      case 0:
        _userFullNameEdit = value;
        break;
      case 1:
        print("before, username -> $_userName");
        _userName = value;
        print("after, username -> $_userName");
        break;
      case 2:
        _gender = value;
        break;
      //3 is dob
      case 4:
        _profession = value;
        break;
      case 5:
        _placeOfWork = value;
        break;
      case 6:
        _placeOfEdu = value;
        break;
      case 7:
        _acadCourse = value;
        break;
      case 8:
        _wtfDesc = value;
        break;
      case 9:
        _aboutDesc = value;
        break;
      case 10:
        _imInJumpinFor = value;
        break;
    }
  }
}
