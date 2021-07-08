import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class SearchPeopleInbox extends StatelessWidget {
  const SearchPeopleInbox({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: width * 0.7,
        child: const TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon:
                    Icon(Icons.search, color: ColorsJumpin.kSecondaryColor),
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'Search')),
      ),
    );
  }
}
