import 'dart:async';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";
import 'package:provider/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
JumpinUser jumpinUser;

Future signInWithGoogle(BuildContext context) async {
  await Firebase.initializeApp();

  //pop up of user's google accounts,googleSignInAccount holds the account you chose
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  //this will take care of the authentication aspect
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  //asking firebase so that the user can access our application and we can use user's public data
  //Here firebase will communicate with Google's server and request access to the data
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final User user = (await (auth.signInWithCredential(credential))).user;
  print(credential.providerId);

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get()
      .then((doc) {
    // if user doesnt exist, signout
    if (doc.exists) {
      FirebaseFirestore.instance
          .collection("fcmTokens")
          .doc(user.uid)
          .get()
          .then((user) {
        if (user.exists) {
          sharedPrefs.fcmToken = user.data()["fcmToken"] as String;
        }
      });
      final DateTime dob = (doc.data()["dob"] as Timestamp).toDate();
      sharedPrefs.dobDay = dob.day;
      sharedPrefs.dobMonth = dob.month;
      sharedPrefs.dobYear = dob.year;
      sharedPrefs.fullname =
          (doc.data()["fullname"] as String) ?? user.displayName;
      sharedPrefs.email = (doc.data()["email"] as String) ?? user.email;
      sharedPrefs.gender = (doc.data()["gender"] as String) ?? "N/A";
      sharedPrefs.phoneNo = (doc.data()["phoneNo"] as String) ?? "N/A";
      sharedPrefs.photoUrl =
          (doc.data()["photoUrl"] as String) ?? user.photoURL;
      sharedPrefs.userName = (doc.data()["username"] as String) ?? "N/A";
      sharedPrefs.userid = (doc.data()["id"] as String) ?? user.uid;

      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);

      sharedPrefs.isLoggedIn = true;
      sharedPrefs.isSignedUp = true;
      sharedPrefs.isGoogleSignedUp = true;
      sharedPrefs.isFacebookLoggedIn =
          (doc.data()["facebookLoggedIn"] as bool) ?? false;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Already a user! Redirecting to homepage"),
                actions: [
                  RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, rSocialAuth);
                      },
                      child: const Text('')),
                ],
              ));

      Navigator.pushNamedAndRemoveUntil(
          context, rHomePlaceHolder, (Route<dynamic> route) => false);
    } else {
      sharedPrefs.fullname = user.displayName;
      jumpinUser = JumpinUser.assignfullName(user.displayName);

      jumpinUser = JumpinUser.assignEmail(user.email);
      sharedPrefs.email = user.email;
      jumpinUser = JumpinUser.assignPhotourl(user.photoURL);
      sharedPrefs.photoUrl = user.photoURL;
      jumpinUser = JumpinUser.assignId(user.uid);
      // print("here in Google_login");
      sharedPrefs.userid = user.uid.toString();

      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);
      print(
          "\n\n\n value  doesn't exist, returning jumpin user ${jumpinUser.fullname} \n\n\n");
      sharedPrefs.isLoggedIn = false;
      sharedPrefs.isSignedUp = false;
      sharedPrefs.isGoogleSignedUp = true;
      sharedPrefs.isFacebookLoggedIn = false;

      Navigator.pushNamed(context, rPhoneVerification);
    }
  });
}

Future signOutGoogle(BuildContext context) async {
  await googleSignIn.signOut();
  //sharedPrefs.isSignedUp = false;
  sharedPrefs.isLoggedIn = false;
  sharedPrefs.isGoogleSignedUp = false;
  sharedPrefs.isLoggedIn = false;
  sharedPrefs.isGoogleSignedUp = false;
  sharedPrefs.dobDay = null;
  sharedPrefs.dobMonth = null;
  sharedPrefs.dobYear = null;
  sharedPrefs.email = null;
  sharedPrefs.fcmToken = null;
  sharedPrefs.fullname = null;
  sharedPrefs.myChatCount = null;
  sharedPrefs.myConnectionListasString = null;
  sharedPrefs.myNoOfConnections = null;
  sharedPrefs.myNotificationCount = null;
  sharedPrefs.myPendingConnectionListasString = null;
  sharedPrefs.okToNavigateFromInterest = null;
  sharedPrefs.isSignedUp = null;
  sharedPrefs.okToNavigateFromOnboardingUser = null;
  sharedPrefs.phoneNo = null;
  sharedPrefs.photoUrl = null;
  sharedPrefs.userName = null;
  sharedPrefs.userid = null;
  sharedPrefs.isFacebookLoggedIn = null;
  sharedPrefs.setFeedback = null;
  sharedPrefs.setVibeWithPeopleList = null;
  sharedPrefs.setMutualFriends = null;
  final prov = Provider.of<ServiceJumpinPeopleHome>(context, listen: false);
  prov.resetProvData();
  print("User Logged out");
}
