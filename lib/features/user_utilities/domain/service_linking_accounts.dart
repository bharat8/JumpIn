import 'dart:convert';

import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class ServiceLinkingAccounts extends ChangeNotifier {
  bool _isFacebookLoggedIn;
  bool get isFacebookLoggedIn => _isFacebookLoggedIn;
  set setFacebookLoginStatus(bool value) {
    _isFacebookLoggedIn = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = true;
    notifyListeners();
  }

  void initiateFacebookLogin(BuildContext context) async {
    var facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    var facebookLoginResult =
        await facebookLogin.logIn(["email", "public_profile", "user_friends"]);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        // onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        // onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        onLoginStatusChanged(facebookLoginResult, context);
        break;
    }
  }

  Future onLoginStatusChanged(
      FacebookLoginResult result, BuildContext context) async {
    _isLoading = true;
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);

    var graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,friends&access_token=${result.accessToken.token}'));

    final profile = jsonDecode(graphResponse.body);

    print(jsonDecode(graphResponse.body).toString());

    User user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot docSnap;
    try {
      await user.linkWithCredential(facebookAuthCredential);
      docSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPrefs.userid)
          .get();

      if (docSnap.exists) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPrefs.userid)
            .update({"facebookLoggedIn": true});
      }
    } on Exception catch (e) {
      showError(context);
    }

    sharedPrefs.isFacebookLoggedIn = true;
    _isFacebookLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  Future unlinkAccount(BuildContext context) async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot docSnap;
    _isLoading = true;
    try {
      user.unlink("facebook.com");
      docSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPrefs.userid)
          .get();

      if (docSnap.exists) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPrefs.userid)
            .update({"facebookLoggedIn": false});
      }
    } on Exception catch (e) {
      showError(context);
    }
    sharedPrefs.isFacebookLoggedIn = false;
    _isFacebookLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }
}

void showError(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          title:
              Center(child: Image.asset("assets/images/Onboarding/error.png")),
          content: Text("Oops, An error occured! Please try again later"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Okay"))
          ]);
    },
  );
}
