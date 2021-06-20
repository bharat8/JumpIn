import 'package:flutter/material.dart';

class UserOnlineOffline extends StatelessWidget {
  const UserOnlineOffline({Key key, @required this.status}) : super(key: key);
  final bool status;
  @override
  Widget build(BuildContext context) {
    if (status == true) {
      return const Icon(Icons.circle, color: Colors.green, size: 10);
    }
    return Icon(Icons.circle, color: Colors.grey[300], size: 10);
  }
}
