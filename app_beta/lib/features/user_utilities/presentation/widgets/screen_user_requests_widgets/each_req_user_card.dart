import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'each_req_user_card_home.dart';

class EachReqUserCard extends StatelessWidget {
  const EachReqUserCard({
    Key key,
    @required this.user,
    @required this.currentAppUser,
  }) : super(key: key);

  final JumpinUser user;
  final JumpinUser currentAppUser;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    List<String> mutualInterests = [];
    user.interestList.forEach((user_interest) {
      currentAppUser.interestList.forEach((interest) {
        if (user_interest == interest) {
          mutualInterests.add(interest as String);
        }
      });
    });

    List<ConnectionUser> mutualConnections = [];
    if (user.myConnections != null) {
      user.myConnections.forEach((user_connection) {
        currentAppUser.myConnections.forEach((connection) {
          if (user_connection == connection) {
            ConnectionUser cu =
                ConnectionUser.fromJson(connection as Map<String, dynamic>);
            mutualConnections.add(cu);
          }
        });
      });
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        height: getScreenSize(context).height * 0.6,
        width: getScreenSize(context).width * 0.68,
        margin: const EdgeInsets.only(right: 50, top: 5, left: 5, bottom: 5),
        child: EachReqUserCardHome(
          user: user,
          mutualConnections: mutualConnections,
          mutualInterests: mutualInterests,
        ));
  }
}
