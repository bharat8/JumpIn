import 'package:cloud_firestore/cloud_firestore.dart';

class JumpinUser {
  String id = "";
  String fullname = "";
  String gender = "";
  String username = "";
  Timestamp dob;
  String profession = "";
  String placeOfWork = "";
  String placeOfEdu = "";
  String acadCourse = "";
  String wtfDesc = "";
  String photoUrl = "";
  String email = "";
  String userProfileAbout = "";
  String inJumpinFor = "";
  GeoPoint geoPoint;
  List interestList = [];
  List photoLists = [];
  List requestSentTo = [];
  List requestReceivedFrom = [];
  List myConnections = [];
  //String gmailDisplayName = "";
  String phoneNo = "";
  JumpinUser(
      {this.id,
      this.fullname,
      this.gender,
      this.username,
      this.dob,
      this.profession,
      this.placeOfWork,
      this.placeOfEdu,
      this.acadCourse,
      this.wtfDesc,
      this.photoUrl,
      this.photoLists,
      this.email,
      this.geoPoint,
      this.phoneNo,
      this.myConnections,
      this.requestReceivedFrom,
      this.requestSentTo,
      this.interestList,
      this.inJumpinFor,
      this.userProfileAbout});

  static final JumpinUser _jumpinuser = JumpinUser._internal();
  JumpinUser._internal();

  factory JumpinUser.assignId(String id) {
    _jumpinuser.id = id;
    return _jumpinuser;
  }

  factory JumpinUser.assignfullName(String fullname) {
    _jumpinuser.fullname = fullname;
    return _jumpinuser;
  }

  factory JumpinUser.assignGender(String gender) {
    _jumpinuser.gender = gender;
    return _jumpinuser;
  }

  factory JumpinUser.assignUsername(String username) {
    _jumpinuser.username = username;
    return _jumpinuser;
  }

  factory JumpinUser.assignDob(Timestamp dob) {
    _jumpinuser.dob = dob;
    return _jumpinuser;
  }

  factory JumpinUser.assignProfession(String profession) {
    _jumpinuser.profession = profession;
    return _jumpinuser;
  }

  factory JumpinUser.assignPlaceOfWork(String placeOfWork) {
    _jumpinuser.placeOfWork = placeOfWork;
    return _jumpinuser;
  }
  factory JumpinUser.assignPlaceOfEdu(String placeOfEdu) {
    _jumpinuser.placeOfEdu = placeOfEdu;
    return _jumpinuser;
  }

  factory JumpinUser.assignAcadCourse(String acadCourse) {
    _jumpinuser.acadCourse = acadCourse;
    return _jumpinuser;
  }

  factory JumpinUser.assignPhotourl(String photourl) {
    _jumpinuser.photoUrl = photourl;
    return _jumpinuser;
  }

  factory JumpinUser.assignEmail(String email) {
    _jumpinuser.email = email;
    return _jumpinuser;
  }

  factory JumpinUser.assignWTFdesc(String wtfdesc) {
    _jumpinuser.acadCourse = wtfdesc;
    return _jumpinuser;
  }

  factory JumpinUser.assignPhoneNo(String phoneNo) {
    _jumpinuser.phoneNo = phoneNo;
    return _jumpinuser;
  }

  static JumpinUser copyObject(JumpinUser ju) {
    JumpinUser juTemp = JumpinUser();
    juTemp.id = ju.id;
    juTemp.acadCourse = ju.acadCourse;
    juTemp.username = ju.username;
    juTemp.profession = ju.profession;
    juTemp.placeOfEdu = ju.placeOfEdu;
    juTemp.placeOfWork = ju.placeOfWork;
    juTemp.dob = ju.dob;
    juTemp.email = ju.email;
    juTemp.fullname = ju.fullname;
    juTemp.gender = ju.gender;
    juTemp.geoPoint = ju.geoPoint;
    juTemp.inJumpinFor = ju.inJumpinFor;
    juTemp.interestList = ju.interestList;
    juTemp.requestReceivedFrom = ju.requestReceivedFrom;
    juTemp.requestSentTo = ju.requestSentTo;
    juTemp.myConnections = ju.myConnections;
    juTemp.userProfileAbout = ju.userProfileAbout;
    juTemp.photoLists = ju.photoLists;
    juTemp.phoneNo = ju.phoneNo;
    juTemp.wtfDesc = ju.wtfDesc;
    juTemp.photoUrl = ju.photoUrl;
    return juTemp;
  }

  factory JumpinUser.fromDocument(dynamic doc) {
    _jumpinuser.id = doc['id'] as String;
    _jumpinuser.fullname = doc['fullname'] as String;
    _jumpinuser.gender = doc['gender'] as String;
    _jumpinuser.username = doc['username'] as String;
    _jumpinuser.dob = doc['dob'] as Timestamp;
    _jumpinuser.profession = doc['profession'] as String;
    _jumpinuser.placeOfWork = doc['placeOfWork'] as String;
    _jumpinuser.placeOfEdu = doc['placeOfEdu'] as String;
    _jumpinuser.acadCourse = doc['acadCourse'] as String;
    _jumpinuser.wtfDesc = doc['wtfDesc'] as String;
    _jumpinuser.photoUrl = doc['photoUrl'] as String;
    _jumpinuser.interestList =
        List<String>.from(doc['interestList'] as Iterable<dynamic>);
    _jumpinuser.photoLists =
        List<String>.from(doc['photoLists'] as Iterable<dynamic>);
    _jumpinuser.geoPoint = doc['geoPoint'] as GeoPoint;
    _jumpinuser.email = doc['email'] as String;
    _jumpinuser.requestSentTo = doc['requestSentTo'] as List<dynamic>;
    _jumpinuser.requestReceivedFrom =
        doc['requestReceivedFrom'] as List<dynamic>;
    _jumpinuser.phoneNo = doc['phoneNo'] as String;
    _jumpinuser.userProfileAbout = doc['userProfileAbout'] as String;
    _jumpinuser.inJumpinFor = doc['inJumpinFor'] as String;
    _jumpinuser.myConnections = doc['myConnections'] as List<dynamic>;

    return _jumpinuser;
  }

  factory JumpinUser.fromDocumentForConnection(Map<String, dynamic> doc) {
    _jumpinuser.id = doc['id'] as String;
    _jumpinuser.myConnections = doc['myConnections'] as List;
    _jumpinuser.requestReceivedFrom = doc['requestReceivedFrom'] as List;
    _jumpinuser.requestSentTo = doc['requestSentTo'] as List;
    _jumpinuser.fullname = doc['fullname'] as String;
    _jumpinuser.gender = doc['gender'] as String;
    _jumpinuser.username = doc['username'] as String;
    _jumpinuser.dob = doc['dob'] as Timestamp;
    _jumpinuser.profession = doc['profession'] as String;
    _jumpinuser.placeOfWork = doc['placeOfWork'] as String;
    _jumpinuser.placeOfEdu = doc['placeOfEdu'] as String;
    _jumpinuser.acadCourse = doc['acadCourse'] as String;
    _jumpinuser.wtfDesc = doc['wtfDesc'] as String;
    _jumpinuser.photoUrl = doc['photoUrl'] as String;
    _jumpinuser.interestList =
        List<String>.from(doc['interestList'] as Iterable<dynamic>);
    _jumpinuser.photoLists =
        List<String>.from(doc['photoLists'] as Iterable<dynamic>);
    _jumpinuser.geoPoint = doc['geoPoint'] as GeoPoint;
    _jumpinuser.email = doc['email'] as String;
    _jumpinuser.phoneNo = doc['phoneNo'] as String;
    _jumpinuser.userProfileAbout = doc['userProfileAbout'] as String;
    _jumpinuser.inJumpinFor = doc['inJumpinFor'] as String;
    return _jumpinuser;
  }
  static Map<String, dynamic> toMap(JumpinUser user) {
    return {
      'id': user.id,
      'fullname': user.fullname,
      'photoUrl': user.photoUrl,
      'username': user.username,
      'gender': user.gender,
      'dob': user.dob,
      'interests': user.interestList,
      'myConnections': user.myConnections,
      'profession': user.profession,
      'placeOfEdu': user.placeOfEdu,
      'placeOfWork': user.placeOfWork,
      'acadCourse': user.acadCourse,
      'wtfDesc': user.wtfDesc,
      'geoPoint': user.geoPoint,
      'email': user.email,
      'phoneNo': user.phoneNo,
      'userProfileAbout': user.userProfileAbout,
      'inJumpinFor': user.inJumpinFor
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return _jumpinuser.acadCourse.toString() +
        _jumpinuser.photoLists.toString();
  }
}

// dob 10 November 1999 at 00:00:00 UTC+5:30
// email "baldawa54@gmail.com"
// fullname "Shubham Baldawa"
// gender "male"
// gmailDisplayName "Shubham Baldawa"
// id "109586360119774753122"
// phoneNo "+917722044446"
// photoUrl "https://lh3.googleusercontent.com/a-/AOh14GhglE1NS3vLT6isxKK5Lrtfhe0tIr0XurLzV0S36z4=s96-c"
// timeStamp 26 December 2020 at 21:10:07 UTC+5:30
// username "shubh"
