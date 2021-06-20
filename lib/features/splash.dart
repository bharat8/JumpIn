import 'dart:async';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenJumpin extends StatefulWidget {
  @override
  _SplashScreenJumpinState createState() => _SplashScreenJumpinState();
}

class _SplashScreenJumpinState extends State<SplashScreenJumpin> {
  ConnectionChecker cc = ConnectionChecker();

  @override
  void initState() {
    cc.checkConnection(context);
    super.initState();

    Timer(const Duration(seconds: 6), () {
      print(
          "login: ${sharedPrefs.isLoggedIn}, signup: ${sharedPrefs.isSignedUp}, otpok: ${sharedPrefs.okToNavigateFromOTP}, interestOk: ${sharedPrefs.okToNavigateFromInterest}, onboardinguser: ${sharedPrefs.okToNavigateFromOnboardingUser}");

      if (!sharedPrefs.isGoogleSignedUp) {
        print("navigating because not signed up");
        Navigator.pushNamed(context, rSocialAuth);
      } else if (sharedPrefs.isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(
            context, rHomePlaceHolder, (Route<dynamic> route) => false);
      } else {
        if (!sharedPrefs.okToNavigateFromOTP) {
          Navigator.pushNamed(context, rPhoneVerification);
        } else if (!sharedPrefs.okToNavigateFromInterest) {
          Navigator.pushNamed(context, rOnboardingInterests);
        } else if (!sharedPrefs.okToNavigateFromOnboardingUser) {
          Navigator.pushNamed(context, rOnboardingUser);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, rHomePlaceHolder, (Route<dynamic> route) => false);
        }
      }
    });

    if (sharedPrefs.appOpenCount == null) {
      sharedPrefs.appOpenCount = 1;
    } else {
      sharedPrefs.appOpenCount = sharedPrefs.appOpenCount + 1;
    }
    sharedPrefs.appOpenLastTime = DateTime.now().toString();
    print(sharedPrefs.appOpenCount);
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsJumpin.kPrimaryColorLite,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset('assets/animations/people-morph-flow.json',
                  height: SizeConfig.blockSizeHorizontal * 30,
                  repeat: true,
                  animate: true,
                  reverse: true),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 10,
                  child: Image.asset('assets/images/Onboarding/logo_final.png'),
                ),
                Container(
                  margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("JUMPIN",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: SizeConfig.blockSizeHorizontal * 7,
                              fontFamily: 'TrebuchetMS',
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              ],
            ),
            const TaglineJI(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class TaglineJI extends StatelessWidget {
  const TaglineJI({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 2, right: 2),
            child: Text('Discover interest-twins near you',
                style: TextStyle(
                    fontFamily: font1,
                    fontSize: SizeConfig.blockSizeHorizontal * 4,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }
}
