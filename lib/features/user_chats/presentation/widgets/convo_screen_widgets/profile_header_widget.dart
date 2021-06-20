import 'package:JumpIn/features/user_chats/domain/chat_list.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name, username, userid, routeType, image;

  const ProfileHeaderWidget({
    @required this.name,
    @required this.username,
    @required this.userid,
    @required this.routeType,
    @required this.image,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(routeType);
    SizeConfig().init(context);
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.24,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue[900], Colors.blue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
              left: constraints.maxWidth * 0.05,
              right: constraints.maxWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        String source = "chat";
                        Navigator.pushNamed(context, rPeopleProfile,
                            arguments: [userid, source]);
                      },
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: 10,
                          surfaceIntensity: 0.1,
                          shadowLightColor: Colors.blue[800],
                          shadowDarkColor: Colors.blue[800],
                          lightSource: LightSource.top,
                          intensity: 1,
                        ),
                        child: CircleAvatar(
                          radius: constraints.maxHeight * 0.26,
                          backgroundImage: NetworkImage(image),
                        ),
                      )),
                  GestureDetector(
                    onTap: () async {
                      if (routeType == "notification" ||
                          routeType == "connection") {
                        Navigator.of(context).pop();
                      } else {
                        print("here");
                        final InboxChatList inboxChatList =
                            Provider.of<InboxChatList>(context, listen: false);
                        await inboxChatList.changeUnseenStatus(userid);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: constraints.maxHeight * 0.2,
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  String source = "chat";
                  Navigator.pushNamed(context, rPeopleProfile,
                      arguments: [userid, source]);
                },
                child: Text(name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: constraints.maxHeight * 0.15,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
