import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:JumpIn/features/user_chats/domain/chat_list.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'mutual_people_more.dart';
import 'get_image_from_name.dart';

class MutualPeopleLess extends StatelessWidget {
  const MutualPeopleLess({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ServicePeopleProfileController>(context);
    return FutureBuilder(
        future: prov.getContactsStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgressIndicator();
          }
          return Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.03,
                left: size.width * 0.04,
                right: size.width * 0.04),
            child: Container(
              width: size.width * 0.96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("You and @${prov.user.username} both know",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.w700)),
                  if (prov.mutualFriendsLoadingStatus == true)
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      child: SpinKitThreeBounce(
                        size: size.height * 0.03,
                        color: Colors.blue[900],
                      ),
                    )
                  else if (prov.getContactPermStatus == false)
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      child: Column(
                        children: [
                          Text(
                            "Want to know more about the person? Enable contacts to see your mutual friends",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.height * 0.018,
                                color: Colors.black38,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.02),
                            child: NeumorphicButton(
                                style: NeumorphicStyle(
                                  depth: 10,
                                  intensity: 0.7,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(5)),
                                  color: Colors.blue,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  await AppSettings.openAppSettings();
                                },
                                child: Container(
                                    height: size.height * 0.05,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.01),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('Enable',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize:
                                                      size.height * 0.018))
                                        ]))),
                          ),
                        ],
                      ),
                    )
                  else if (prov.mutualFriends.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: size.width * 0.8,
                            height: size.height * 0.15,
                            padding:
                                EdgeInsets.only(top: (size.height * 0.15) / 5),
                            child: Stack(
                              children: prov.mutualFriendsLess.map((e) {
                                return Positioned(
                                    left: prov.mutualFriendsLess.indexOf(e) *
                                        (size.width * 0.17),
                                    child: GetImageFromName(
                                      name: e,
                                    ));
                              }).toList(),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: (size.height * 0.15) / 5,
                              right: size.width * 0.02),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => ListenableProvider<
                                            ServicePeopleProfileController>.value(
                                        value: prov,
                                        child: MutualPeopleMore(
                                            prov.mutualFriends)))),
                            child: Container(
                              width: size.width * 0.1,
                              height: size.width * 0.2,
                              // color: Colors.black26,
                              padding: EdgeInsets.all(size.width * 0.02),
                              child: FittedBox(
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: size.height * 0.025,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  else
                    Container(
                        height: size.height * 0.1,
                        child: Center(child: Text("No mutual friends")))
                ],
              ),
            ),
          );
        });
  }
}
