import 'package:flutter/material.dart';

class InboxUserProfilePhoto extends StatelessWidget {
  const InboxUserProfilePhoto({Key key, this.imageURL}) : super(key: key);
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            spreadRadius: 2,
            blurRadius: 14,
            color: Colors.grey[300],
            offset: const Offset(10, 10))
      ]),
      child: CircleAvatar(
        radius: 35,
        backgroundImage: NetworkImage(imageURL),
      ),
    );
  }
}
