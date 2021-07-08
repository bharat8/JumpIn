import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class SignupText extends StatelessWidget {
  const SignupText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        height: SizeConfig.blockSizeVertical * 8.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign Up ",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    color: ColorsJumpin.kPrimaryColor,
                    fontWeight: FontWeight.w700)),
            Text("to start vibing! ",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.w700))
          ],
        ));
  }
}
