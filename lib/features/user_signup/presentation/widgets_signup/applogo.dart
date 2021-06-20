import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApplogonName extends StatefulWidget {
  const ApplogonName({
    Key key,
    this.height,
    this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  _ApplogonNameState createState() => _ApplogonNameState();
}

class _ApplogonNameState extends State<ApplogonName> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeHorizontal * 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 8,
                    child:
                        Image.asset('assets/images/Onboarding/logo_final.png'),
                  ),
                  Text("JUMPIN",
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 30,
                          fontFamily: 'TrebuchetMS',
                          fontWeight: FontWeight.bold))
                ],
              ),
            )
          ],
        ),
      ],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ],
    );
  }
}
