import 'dart:async';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";

import '../../features/people_home/data/model_jumpin_user.dart';
import '../utils/route_constants.dart';
import '../utils/sharedpref.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
JumpinUser jumpinUser;
// String userName;
// String userEmail;
// String userProfileimageUrl;

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
      final DateTime dob = DateTime.parse(doc.data()["dob"] as String);
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
      // jumpinUser = JumpinUser.assignfullName(sharedPrefs.fullname);
      // jumpinUser = JumpinUser.assignEmail(user.email);
      // sharedPrefs.email = user.email;
      // jumpinUser = JumpinUser.assignPhotourl(user.photoURL);
      // sharedPrefs.photoUrl = user.photoURL;
      // jumpinUser = JumpinUser.assignId(user.uid);
      // print("here in Google_login");
      // sharedPrefs.userid = user.uid.toString();

      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);
      // print(
      //     "\n\n\n value exists, returning jumpin user ${jumpinUser.fullname} \n\n\n");
      sharedPrefs.isLoggedIn = true;
      sharedPrefs.isSignedUp = true;
      sharedPrefs.isGoogleSignedUp = true;
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

      // if (userName.contains(" ")) {
      //   userName = userName.substring(0, userName.indexOf(" "));
      // }

      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);
      print(
          "\n\n\n value  doesn't exist, returning jumpin user ${jumpinUser.fullname} \n\n\n");
      sharedPrefs.isLoggedIn = false;
      sharedPrefs.isSignedUp = false;
      sharedPrefs.isGoogleSignedUp = true;

      Navigator.pushNamed(context, rPhoneVerification);
    }
  });
}

Future logInWithGoogle(BuildContext context) async {
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
    if (!doc.exists) {
      // if signout is successful i.e. value!=null, return null because the user doesn't exist
      print("\n\nvalue doesn't exist\n\n");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Can't Log You In, You need to SignUp First"),
                actions: [
                  RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, rSocialAuth);
                      },
                      child: const Text('Sign Me Up!')),
                ],
              ));
      signOutGoogle().then((value) {
        if (value != null) return null;
      });
    } else {
      FirebaseFirestore.instance
          .collection("fcmTokens")
          .doc(user.uid)
          .get()
          .then((user) {
        if (user.exists) {
          sharedPrefs.fcmToken = user.data()["fcmToken"] as String;
        }
      });
      final DateTime dob = DateTime.parse(doc.data()["dob"] as String);
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
      // jumpinUser = JumpinUser.assignfullName(sharedPrefs.fullname);
      // jumpinUser = JumpinUser.assignEmail(user.email);
      // sharedPrefs.email = user.email;
      // jumpinUser = JumpinUser.assignPhotourl(user.photoURL);
      // sharedPrefs.photoUrl = user.photoURL;
      // jumpinUser = JumpinUser.assignId(user.uid);
      // print("here in Google_login");
      // sharedPrefs.userid = user.uid.toString();

      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);
      // print(
      //     "\n\n\n value exists, returning jumpin user ${jumpinUser.fullname} \n\n\n");
      sharedPrefs.isLoggedIn = true;
      sharedPrefs.isSignedUp = true;
      sharedPrefs.isGoogleSignedUp = true;
      Navigator.pushNamedAndRemoveUntil(
          context, rHomePlaceHolder, (Route<dynamic> route) => false);
      return true;
    }
  });

  //return null;
}

Future signOutGoogle() async {
  await googleSignIn.signOut();
  sharedPrefs.isLoggedIn = false;
  sharedPrefs.isGoogleSignedUp = false;
  print("User Logged out");
}
