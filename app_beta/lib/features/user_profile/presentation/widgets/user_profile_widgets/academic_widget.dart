import 'package:JumpIn/features/user_profile/domain/user_profile_controller.dart';
import 'package:flutter/material.dart';

class AcademicWidget extends StatelessWidget {
  const AcademicWidget({
    Key key,
    @required this.size,
    @required this.profileController,
  }) : super(key: key);

  final Size size;
  final UserProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      // color: Colors.blue[50],
      margin: EdgeInsets.only(top: size.height * 0.08),
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.025),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: size.height * 0.05,
                padding: EdgeInsets.only(right: size.width * 0.02),
                child: Image.asset("assets/images/Profile/certificate.png"),
              ),
              Text("Academic",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.015),
            // color: Colors.black12,
            child: Center(
              child: Text(
                profileController.currentUserProfileUser.acadCourse.length != 0
                    ? profileController.currentUserProfileUser.acadCourse
                    : "N/A",
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
