import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future getMutualFriends(String user_id) async {
  //get user's connection
  DocumentSnapshot usersRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .get();

  List usersConnections = [];
  if (usersRef.exists) {
    usersConnections = usersRef["myConnections"]
        .map((user) => ConnectionUser.fromJson(user as Map<String, dynamic>))
        .toList() as List<dynamic>;
  }

  //find mutual friends
  DocumentSnapshot peopleRef =
      await FirebaseFirestore.instance.collection('users').doc(user_id).get();

  List peopleConnections = [];
  if (peopleRef.exists) {
    peopleConnections = peopleRef["myConnections"]
        .map((user) => ConnectionUser.fromJson(user as Map<String, dynamic>))
        .toList() as List<dynamic>;
  }
  //return list of mutual friends
  List mutualFriends = [];

  usersConnections.forEach((userConnection) {
    peopleConnections.forEach((peopleConnection) {
      if (peopleConnection.id == userConnection.id) {
        mutualFriends.add(peopleConnection);
      }
    });
  });

  return mutualFriends;
}

Future updateMyConnection(String userid) async {
  DocumentSnapshot userrefConnections =
      await FirebaseFirestore.instance.collection('users').doc(userid).get();

  if (userrefConnections.exists) {
    FirebaseFirestore.instance.collection('users').doc(userid).update({
      "myConnections": userrefConnections['myConnections'],
      "requestReceivedFrom": userrefConnections['requestReceivedFrom'],
      "requestSentTo": userrefConnections['requestSentTo']
    });
  }
}

Future getMutualInterests(String user_id) async {
  //get user's connection
  DocumentSnapshot usersRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .get();

  List usersInterests = [];
  if (usersRef.exists) {
    usersInterests = usersRef["interestList"]
        .map((interest) => interest as String)
        .toList() as List;
  }

  //find mutual friends
  DocumentSnapshot peopleRef =
      await FirebaseFirestore.instance.collection('users').doc(user_id).get();

  List peopleInterests = [];
  if (peopleRef.exists) {
    peopleInterests = peopleRef["interestList"]
        .map((interest) => interest as String)
        .toList() as List;
  }
  //return list of mutual friends
  List mutualInterests = [];

  usersInterests.forEach((userInterest) {
    peopleInterests.forEach((peopleInterest) {
      if (peopleInterest.compareTo(userInterest) == 0) {
        mutualInterests.add(peopleInterest);
      }
    });
  });
  return mutualInterests;
}

Future<double> calculateVibeForPeople(String userid) async {
  DocumentSnapshot userRefJU = await FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .get();
  JumpinUser user = JumpinUser.fromDocument(userRefJU);
  DocumentSnapshot peopleRefJU =
      await FirebaseFirestore.instance.collection('users').doc(userid).get();

  JumpinUser people = JumpinUser.fromDocument(peopleRefJU);

  //return list of mutual friends
  List usersConnections = userRefJU['myConnections']
      .map((connection) =>
          ConnectionUser.fromJson(connection as Map<String, dynamic>))
      .toList() as List;

  List peopleConnections = peopleRefJU['myConnections']
      .map((connection) =>
          ConnectionUser.fromJson(connection as Map<String, dynamic>))
      .toList() as List;

  List mutualFriends = [];

  usersConnections.forEach((userConnection) {
    peopleConnections.forEach((peopleConnection) {
      if (peopleConnection.id == userConnection.id) {
        mutualFriends.add(peopleConnection);
      }
    });
  });

  double distance = LocationUtils.getDistance(
      user.geoPoint.latitude, user.geoPoint.longitude);

  print("\n vibe calculation for ${user.fullname}");
  Vibemeter vm = Vibemeter(
      myInterestList: user.interestList,
      peopleInterestlist: people.interestList,
      distance: distance,
      myWorkPlace: user.placeOfWork,
      peopleWorkPlace: people.placeOfWork,
      myConnectionsNo: sharedPrefs.myNoOfConnections,
      peopleConnectionsNo: peopleConnections.length,
      myAge: Utils.calculateAge(user.dob.toDate()),
      peopleAge: Utils.calculateAge(people.dob.toDate()),
      myAcadInstituition: user.placeOfEdu,
      peopleAcadInstituition: people.placeOfEdu,
      mutualConnections: mutualFriends.length);

  return vm.calculateVibe();
}

Future isRequestReceived(String peopleid) async {
  print("inside isReq recieved");
  //get user's connection
  DocumentSnapshot usersRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .get();

  print("req received from-> ${usersRef['requestReceivedFrom']}");
  List reqReceivedList = usersRef['requestReceivedFrom']
      .map((rr) => rr as String)
      .toList() as List;

  List reqSentList =
      usersRef['requestSentTo'].map((rr) => rr as String).toList() as List;
  print("req sent to-> ${usersRef['requestSentTo']}");

  print("people id $peopleid");
  if (reqReceivedList.contains(peopleid)) {
    print("in requestReceived List returning true");
    return reqReceived;
  } else if (reqSentList.contains(peopleid)) {
    print("in requestSent List returning true for $peopleid");
    return reqSent;
  } else {
    print("returning false");
    return neitherReceivednorSent;
  }
}
