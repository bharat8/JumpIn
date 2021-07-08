import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({
    Key key,
    @required this.user,
  }) : super(key: key);

  final JumpinUser user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.35,
      child: Text(
          user.username.startsWith("@")
              ? '${user.username}'
              : '@${user.username}',
          textScaleFactor: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorsJumpin.kPrimaryColor,
              fontSize: SizeConfig.blockSizeHorizontal * 3.7)),
    );
  }
}
