import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:flutter/material.dart';

class PeopleAboutWidget extends StatelessWidget {
  const PeopleAboutWidget({
    Key key,
    @required this.size,
    @required this.profileController,
  }) : super(key: key);

  final Size size;
  final ServicePeopleProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      color: Colors.blue[50],
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.05),
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.06, vertical: size.height * 0.025),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bio",
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w600)),
            ],
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.015),
            // color: Colors.black12,
            child: Center(
              child: Text(
                profileController.user.userProfileAbout.isEmpty
                    ? "N / A"
                    : profileController.user.userProfileAbout,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }
}
