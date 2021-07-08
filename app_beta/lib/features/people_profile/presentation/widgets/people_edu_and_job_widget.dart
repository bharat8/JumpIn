import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:flutter/material.dart';

class EduNJobWidget extends StatelessWidget {
  const EduNJobWidget({
    Key key,
    @required this.size,
    @required this.profileController,
  }) : super(key: key);

  final Size size;
  final ServicePeopleProfileController profileController;

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
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Text(
                        profileController.user.placeOfEdu.isEmpty
                            ? "N/A"
                            : profileController.user.placeOfEdu,
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
                children: [
                  Container(
                    width: size.width * 0.07,
                    height: size.width * 0.07,
                    child: Image.asset("assets/images/Profile/suitcase.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Text(
                        profileController.user.placeOfWork.isEmpty
                            ? "N/A"
                            : profileController.user.placeOfWork,
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
