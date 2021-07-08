import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class InboxListUserName extends StatelessWidget {
  const InboxListUserName({Key key, @required this.name}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Text(
        name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: font1,
            fontSize: SizeConfig.blockSizeHorizontal * 4),
      ),
    );
  }
}
