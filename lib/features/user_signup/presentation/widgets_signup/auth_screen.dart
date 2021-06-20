import 'package:JumpIn/features/user_signup/presentation/widgets_signup/applogo.dart';
import 'package:JumpIn/features/user_signup/presentation/widgets_signup/google_signup_button.dart';
import 'package:JumpIn/features/user_signup/presentation/widgets_signup/signup_text.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

Widget authScreen(BuildContext context) {
  SizeConfig().init(context);
  return WillPopScope(
    onWillPop: () {
      return Future(() => false);
    },
    child: SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.center,
                    colorFilter: new ColorFilter.mode(
                        Colors.white.withOpacity(0.3), BlendMode.dstATop),
                    image: const AssetImage(
                        'assets/images/Onboarding/one_hand.jpg'),
                    fit: BoxFit.contain)),
            child: Column(
              children: [
                Expanded(
                  flex: 20,
                  child: ApplogonName(width: getScreenSize(context).width),
                ),
                Expanded(
                    flex: 50,
                    child: SizedBox(height: SizeConfig.blockSizeVertical * 50)),
                const Expanded(flex: 8, child: SignupText()),
                Expanded(
                    flex: 8,
                    child: SizedBox(
                        height: SizeConfig.blockSizeVertical * 8.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GoogleSignupButton(),
                          ],
                        ))),
                //const Expanded(flex: 8, child: LoginText())
                Expanded(flex: 8, child: Container())
              ],
            ),
          )),
    ),
  );
}
