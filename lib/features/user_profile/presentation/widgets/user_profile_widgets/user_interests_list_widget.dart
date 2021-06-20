import 'package:JumpIn/features/interests/interest_page.dart';
import 'package:JumpIn/features/user_profile/domain/user_profile_controller.dart';
import 'package:JumpIn/features/interests/interest_page_provider.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserInterestsListWidget extends StatelessWidget {
  const UserInterestsListWidget({
    Key key,
    @required this.size,
    @required this.profileController,
  }) : super(key: key);

  final Size size;
  final UserProfileController profileController;

  @override
  Widget build(BuildContext context) {
    final interestProv = Provider.of<InterestPageProvider>(context);
    print(interestProv.isInterestsLoading);
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: Container(
        width: size.width,
        // color: Colors.black12,
        margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text("Interests",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.w700)),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: interestProv.isInterestsLoading == true
                      ? SpinKitThreeBounce(
                          size: size.height * 0.02,
                          color: Colors.blue[900],
                        )
                      : Text(
                          profileController.currentUserProfileUser.interestList
                                      .length <
                                  10
                              ? "0${profileController.currentUserProfileUser.interestList.length}"
                              : profileController
                                  .currentUserProfileUser.interestList.length
                                  .toString(),
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Container(
              width: size.width,
              height: size.height * 0.25,
              child: interestProv.isInterestsLoading == true
                  ? SpinKitThreeBounce(
                      size: size.height * 0.03,
                      color: Colors.blue[900],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          0, size.width * 0.025, size.width * 0.025, 0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: profileController.interestsList.length + 1,
                      itemBuilder: (context, index) {
                        return index != 0
                            ? Container(
                                width: size.width * 0.35,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(2000)),
                                        depth: -10,
                                        surfaceIntensity: 0.1,
                                        lightSource: LightSource.top,
                                        intensity: 1,
                                      ),
                                      child: CircleAvatar(
                                        radius: size.width * 0.13,
                                        backgroundColor: Colors.blue[900],
                                        backgroundImage: AssetImage(
                                            profileController.interestsList[
                                                profileController
                                                    .interestsList.keys
                                                    .elementAt(index - 1)]),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.02),
                                      child: Text(
                                          profileController.interestsList.keys
                                              .elementAt(index - 1),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: size.height * 0.02,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Spacer(flex: 1)
                                  ],
                                ),
                              )
                            : Container(
                                width: size.width * 0.2,
                                // color: Colors.black26,
                                margin: EdgeInsets.only(
                                    left: size.width * 0.07,
                                    bottom: size.height * 0.07,
                                    right: size.width * 0.07),
                                padding: EdgeInsets.all(size.width * 0.02),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => InterestPage(
                                                  source: "profile",
                                                )));
                                    profileController.interestsList = {};
                                  },
                                  child: Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        boxShape: NeumorphicBoxShape.circle(),
                                        depth: 10,
                                        surfaceIntensity: 0.1,
                                        lightSource: LightSource.top,
                                        intensity: 1,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                          colors: [
                                            Colors.blue[900],
                                            Colors.blue
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
