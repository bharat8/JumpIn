import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class HomepagePlanImage extends StatelessWidget {
  const HomepagePlanImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: getScreenSize(context).height * 0.10,
            backgroundImage: const AssetImage(
                'assets/images/Home/people_background_blue_shades.png'),
          ),
          Positioned(
            left: getScreenSize(context).width * 0.042,
            top: getScreenSize(context).width * 0.047,
            child: Center(
              child: CircleAvatar(
                radius: getScreenSize(context).height * 0.076,
                backgroundImage:
                    const AssetImage('assets/images/Onboarding/plan1.jpeg'),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
