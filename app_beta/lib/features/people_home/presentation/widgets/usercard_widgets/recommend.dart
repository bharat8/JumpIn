import 'package:JumpIn/core/utils/file_sharing.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Recommend extends StatelessWidget {
  const Recommend({
    Key key,
    @required this.user,
  }) : super(key: key);

  final JumpinUser user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: 10,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
        color: Colors.grey[50],
      ),
      padding: EdgeInsets.zero,
      onPressed: () {
        urlFileShare(context, user.username, user.id);
      },
      child: Container(
          height: size.height * 0.05,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ImageIcon(const AssetImage('assets/images/Home/refer_icon.png'),
                size: size.height * 0.035),
            Text('Recommend',
                style: TextStyle(
                    fontFamily: 'TrebuchetMS',
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.018))
          ])),
    );
  }
}
