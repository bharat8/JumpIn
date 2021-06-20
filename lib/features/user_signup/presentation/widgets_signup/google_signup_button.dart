import 'package:JumpIn/features/user_signup/domain/service_signup.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class GoogleSignupButton extends StatelessWidget {
  const GoogleSignupButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialButton(
      onPressed: () {
        try {
          signInWithGoogle(context);
        } on PlatformException catch (error) {
          print("NO INTERNET CONNECTION");
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Resolve $error'),
                  ));
          print(error);
        }
      },
      child: Neumorphic(
          style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: 8,
              lightSource: LightSource.top,
              color: ColorsJumpin.kPrimaryColorLite),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 8.0, horizontal: size.height * 0.02),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Image(
                    image:
                        AssetImage('assets/images/Onboarding/google_logo.png'),
                    width: SizeConfig.blockSizeHorizontal * 5,
                    height: SizeConfig.blockSizeVertical * 8,
                  ),
                ),
                Text(
                  "Continue With Google",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8),
                      fontSize: SizeConfig.blockSizeHorizontal * 5),
                )
              ],
            ),
          )),
      // child: Container(
      //   decoration: BoxDecoration(
      //       color: ColorsJumpin.kPrimaryColorLite,
      //       boxShadow: [
      //         BoxShadow(color: Colors.grey[300], offset: Offset(8, 4))
      //       ],
      //       borderRadius: BorderRadius.circular(20)),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       children: [
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Image(
      //     image: AssetImage('assets/images/Onboarding/google_logo.png'),
      //     width: SizeConfig.blockSizeHorizontal * 5,
      //     height: SizeConfig.blockSizeVertical * 8,
      //   ),
      // ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Text(
      //     "Continue With Google",
      //     style: TextStyle(
      //         fontSize: SizeConfig.blockSizeHorizontal * 5),
      //   ),
      // )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
