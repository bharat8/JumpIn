import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class OnboardingProgressIndicator1 extends StatelessWidget {
  const OnboardingProgressIndicator1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenSize(context).height * 0.05,
      child: SizedBox(
          width: 500,
          height: 50,
          child:
              Image.asset('assets/images/Onboarding/onboardingProgress1.png')),
    );
  }
}
