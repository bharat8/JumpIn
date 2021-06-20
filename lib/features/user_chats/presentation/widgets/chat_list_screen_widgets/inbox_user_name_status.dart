import 'package:flutter/material.dart';

import 'inbox_list_user_name.dart';

class InboxUserNameNStatus extends StatelessWidget {
  const InboxUserNameNStatus(
      {Key key, @required this.status, @required this.name})
      : super(key: key);
  final bool status;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 5, top: 5, bottom: 5),
      alignment: Alignment.center,
      child: InboxListUserName(name: name),
    );
  }
}
