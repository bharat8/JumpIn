import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';

class UserConnectionCard extends StatelessWidget {
  const UserConnectionCard({
    @required this.connectionUser,
    Key key,
  }) : super(key: key);

  final ConnectionUser connectionUser;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: SizeConfig.blockSizeVertical * 70,
      child: GestureDetector(
        onTap: () {
          String source = "connection";
          Navigator.pushNamed(context, rPeopleProfile,
              arguments: [connectionUser.id, source]);
        },
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: CircleAvatar(
                  minRadius: SizeConfig.blockSizeVertical * 7,
                  maxRadius: SizeConfig.blockSizeVertical * 10,
                  backgroundImage: NetworkImage(connectionUser.avatarImageUrl)),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(2),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      connectionUser.fullname,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: font1,
                          fontSize: SizeConfig.blockSizeVertical * 3,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
