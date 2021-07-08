import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class BookMark extends StatefulWidget {
  const BookMark({
    Key key,
  }) : super(key: key);

  @override
  _BookMarkState createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  Color color = ColorsJumpin.kSecondaryColor;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 8,
        right: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Card(
              elevation: 10,
              shadowColor: Colors.black,
              child: Container(
                child: ImageIcon(
                  AssetImage('assets/images/Home/bookmark_icon.png'),
                  color: color,
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ),
        ));
  }
}
