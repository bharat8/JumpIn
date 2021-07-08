import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:flutter/cupertino.dart';
import 'each_req_user_card.dart';

class ListUserCards extends StatelessWidget {
  const ListUserCards(
      {Key key,
      @required this.height,
      @required this.width,
      @required this.currentAppUser,
      @required this.requestingUsers})
      : super(key: key);

  final double height;
  final double width;
  final List<JumpinUser> requestingUsers;
  final JumpinUser currentAppUser;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: height * 0.05),
        height: height * 0.7,
        width: width,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => EachReqUserCard(
              user: requestingUsers[index], currentAppUser: currentAppUser),
          itemCount: requestingUsers.length,
        ));
  }
}
