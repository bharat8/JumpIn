import 'package:JumpIn/features/user_signup/domain/service_signup.dart';
import 'package:JumpIn/features/user_signup/presentation/phone_verification.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> signUpUserWithOTP(BuildContext context) async {
  print("loginUser called");
  //FirebaseAuth _auth = FirebaseAuth.instance;

  await Firebase.initializeApp();

  auth.verifyPhoneNumber(
      //phoneNumber: "+8801788868972",
      phoneNumber: "+91$phoneNo",
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        print("inside verification completed");
        try {
          // FirebaseAuth.instance.signInWithCredential(credential);

          auth.currentUser.linkWithCredential(credential);

          //userRefFS.doc(currentGoogleUser.id).set({"phoneNo": "+91$phoneNo"});
          sharedPrefs.phoneNo = "+91$phoneNo";
          // print(
          //     "before-> inside verification-> ${otpController.otpTextInitialValue}");
          // otpController.alterOTPTextInitialValue("****");
          // print(
          //     "after-> inside verification-> ${otpController.otpTextInitialValue}");

          sharedPrefs.okToNavigateFromOTP = true;
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(
                        "User Verified by reading the otp from SMS on device"),
                    actions: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, rOnboardingInterests);

                          sharedPrefs.okToNavigateFromOTP = true;
                        },
                        child: const Text('Alright'),
                      )
                    ],
                  ));
        } on FirebaseAuthException catch (error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("$error"),
                  ));
        }

        //This callback gets called when verification is done automatically
      },
      verificationFailed: (FirebaseAuthException exception) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("$exception"),
                ));
      },
      codeSent: (String verId, [int forceResendingToken]) async {
        try {
          AuthCredential authCreds = PhoneAuthProvider.credential(
              verificationId: verId, smsCode: smsCode);
          auth.currentUser.linkWithCredential(authCreds);

          //userRefFS.doc(currentGoogleUser.id).set({"phoneNo": "+91$phoneNo"});
          sharedPrefs.okToNavigateFromOTP = true;
          sharedPrefs.phoneNo = "+91$phoneNo";
        } on FirebaseAuthException catch (error) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("$error"),
                  ));
        }
      },
      codeAutoRetrievalTimeout: (String verificationid) {
        print(verificationid);
      });
}
