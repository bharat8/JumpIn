import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import '../widgets/page_background_widget_second.dart';
import '../widgets/page_background_widget_first.dart';
import '../widgets/page_background_widget_third.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: IntroductionScreen(
      pages: [
        PageBackgroundWidgetFirst().buildPageViewModel(size, context),
        PageBackgroundWidgetSecond().buildPageViewModel(size, context),
        PageBackgroundWidgetThird().buildPageViewModel(size, context)
      ],
      onDone: () {
        Navigator.pushNamedAndRemoveUntil(
            context, rHomePlaceHolder, (Route<dynamic> route) => false);
      },
      onSkip: () {
        Navigator.pushNamedAndRemoveUntil(
            context, rHomePlaceHolder, (Route<dynamic> route) => false);
      },
      globalHeader: Container(),
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Icon(Icons.forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.blue,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    ));
  }
}
