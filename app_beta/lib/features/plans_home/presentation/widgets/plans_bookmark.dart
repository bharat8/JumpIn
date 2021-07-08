import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class BookMark extends StatelessWidget {
  const BookMark({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 8,
        right: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            shadowColor: Colors.black,
            child: Container(
              child: ImageIcon(
                AssetImage('assets/images/Home/bookmark_icon.png'),
                color: ColorsJumpin.kSecondaryColor,
              ),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ));
  }
}
