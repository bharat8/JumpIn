import 'package:JumpIn/features/user_profile/domain/user_profile_controller.dart';
import 'package:flutter/material.dart';

class EduNJobWidget extends StatelessWidget {
  const EduNJobWidget({
    Key key,
    @required this.size,
    @required this.profileController,
  }) : super(key: key);

  final Size size;
  final UserProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: size.height * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.5,
              child: Column(
                children: [
                  Container(
                    width: size.width * 0.07,
                    height: size.width * 0.07,
                    child: Image.asset("assets/images/Profile/mortarboard.png"),
                  ),
                  // Icon(Icons.school,
                  //     size: size.height * 0.035,
                  //     color: Colors.black.withOpacity(0.7)),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Text(
                        profileController
                                .currentUserProfileUser.placeOfEdu.isEmpty
                            ? "N/A"
                            : profileController
                                .currentUserProfileUser.placeOfEdu,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width * 0.5,
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size.width * 0.07,
                    height: size.width * 0.07,
                    child: Image.asset("assets/images/Profile/suitcase.png"),
                  ),
                  // Icon(Icons.work,
                  //     size: size.height * 0.035,
                  //     color: Colors.black.withOpacity(0.7)),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Text(
                        profileController
                                .currentUserProfileUser.placeOfWork.isEmpty
                            ? "N/A"
                            : profileController
                                .currentUserProfileUser.placeOfWork,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.height * 0.019,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
