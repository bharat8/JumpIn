// import 'dart:async';

// import 'package:JumpIn/Services/google_signin.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// //final FacebookLogin facebookSignIn = FacebookLogin();
// FirebaseAuth _auth = FirebaseAuth.instance;

// Future<bool> signinWithFacebook() async {
//   final result = await FacebookAuth.instance.login();
//   switch (result.status) {
//     case FacebookAuthLoginResponse.ok:
//       print(result);
//       // get the user data
//       final userData = await FacebookAuth.instance.getUserData();
//       AuthCredential credential = FacebookAuthProvider.getCredential(
//           accessToken: result.accessToken.token);

//       await FirebaseAuth.instance.signInWithCredential(credential);
//       // final userData = await _fb.getUserData(fields:"email,birthday");
//       userName = userData['name'];
//       userEmail = userData['email'];
//       userProfileimageUrl = userData['picture']['data']['url'];
//       return true;
//       break;
//     case FacebookAuthLoginResponse.cancelled:
//       print("login cancelled");
//       break;
//     default:
//       print("login failed");
//   }
//   return false;
// }

// Future<Null> signOutFacebook() async {
//   await FacebookAuth.instance.logOut();
//   // _showMessage('Logged out.');
// }
