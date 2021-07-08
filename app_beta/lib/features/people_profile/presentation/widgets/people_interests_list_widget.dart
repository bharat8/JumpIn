import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class InterestsListWidget extends StatelessWidget {
  const InterestsListWidget({
    Key key,
    @required this.size,
    @required this.interestsList,
    @required this.interestsListName,
  }) : super(key: key);

  final Size size;
  final Map<String, String> interestsList;
  final String interestsListName;

  @override
  Widget build(BuildContext context) {
    final profileController =
        Provider.of<ServicePeopleProfileController>(context, listen: false);
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
                Text(interestsListName,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.w700)),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: Text(
                      interestsList.length < 10
                          ? "0${interestsList.length}"
                          : interestsList.length.toString(),
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            interestsList.length > 0
                ? Container(
                    width: size.width,
                    height: size.height * 0.25,
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          0, size.width * 0.025, size.width * 0.025, 0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: interestsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: size.width * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      interestsList.values.elementAt(index)),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.02),
                                child: Text(interestsList.keys.elementAt(index),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Spacer(flex: 1)
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: size.width,
                    height: size.height * 0.15,
                    child: Center(
                        child: Text(
                            interestsListName == "Other Interests"
                                ? "No other interests"
                                : "No mutual Interests",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w400))))
          ],
        ),
      ),
    );
  }
}
