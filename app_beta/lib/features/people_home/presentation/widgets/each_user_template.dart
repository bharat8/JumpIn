import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/each_home_user_card.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EachUserCard extends StatefulWidget {
  EachUserCard({
    Key key,
    @required this.width,
    @required this.height,
    @required this.user,
    @required this.parentContext,
    @required this.vibeWithUser,
  }) : super(key: key);

  final double width;
  final double height;
  final JumpinUser user;
  final BuildContext parentContext;
  final double vibeWithUser;

  @override
  _EachUserCardState createState() => _EachUserCardState();
}

class _EachUserCardState extends State<EachUserCard> {
  @override
  Widget build(BuildContext context) {
    final homeScreenProv =
        Provider.of<ServiceJumpinPeopleHome>(context, listen: false);

    return Container(
        width: widget.width * 0.7,
        decoration: BoxDecoration(
          // color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: getScreenSize(context).width * 0.07),
        child: homeScreenProv.currentUserRequestingUserids
                .contains(widget.user.id)
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: widget.height * 0.01),
                    child: Column(children: [
                      Container(
                        width: getScreenSize(context).width * 0.68,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                                radius: SizeConfig.blockSizeHorizontal * 3,
                                backgroundImage:
                                    NetworkImage(widget.user.photoUrl)),
                            Container(
                                child: Text('  @${widget.user.username}',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: ColorsJumpin.kPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                3))),
                          ],
                        ),
                      ),
                      Container(
                          child: Text('wants to Jumpin with you',
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 3.2)))
                    ]),
                  ),
                  EachHomeUserCard(
                    user: widget.user,
                    parentContext: widget.parentContext,
                    requestReceived: true,
                    vibeWithUser: widget.vibeWithUser,
                  ),
                ],
              )
            : EachHomeUserCard(
                user: widget.user,
                parentContext: widget.parentContext,
                requestReceived: false,
                vibeWithUser: widget.vibeWithUser,
              ));
  }
}
