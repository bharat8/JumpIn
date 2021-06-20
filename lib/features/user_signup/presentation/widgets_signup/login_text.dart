import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  const LoginText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.blockSizeVertical * 8.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already a User?',
              style: TextStyle(
                  color: ColorsJumpin.kSecondaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: font1,
                  fontSize: SizeConfig.blockSizeHorizontal * 5)),
          GestureDetector(
            onTap: () => {Navigator.pushNamed(context, rLoginScreen)},
            child: Text(
              " LOGIN",
              style: TextStyle(
                  color: ColorsJumpin.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: font1,
                  fontSize: SizeConfig.blockSizeHorizontal * 5),
            ),
          )
        ],
      ),
    );
  }
}
