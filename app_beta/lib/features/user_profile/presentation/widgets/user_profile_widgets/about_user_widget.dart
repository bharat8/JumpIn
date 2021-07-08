import 'package:JumpIn/features/user_profile/domain/user_profile_controller.dart';
import 'package:flutter/material.dart';

class UserAboutWidget extends StatelessWidget {
  const UserAboutWidget({
    Key key,
    @required this.size,
    @required this.profileController,
    @required this.bioFocusNode,
  }) : super(key: key);

  final Size size;
  final UserProfileController profileController;
  final FocusNode bioFocusNode;

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
              if (profileController.currentUserProfileUser.userProfileAbout ==
                  null)
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(bioFocusNode);
                  },
                  child: Container(
                    width: size.width * 0.1,
                    height: size.width * 0.1,
                    padding: EdgeInsets.all(size.width * 0.025),
                    // color: Colors.black26,
                    child: FittedBox(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey[600],
                        size: size.height * 0.03,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.015),
            // color: Colors.black12,
            child: profileController.currentUserProfileUser.userProfileAbout ==
                    null
                ? TextField(
                    focusNode: bioFocusNode,
                    textAlign: TextAlign.center,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                        hintText: "Write short Bio about yourself",
                        hintStyle: TextStyle(fontSize: size.height * 0.02)),
                  )
                : Center(
                    child: Text(
                      profileController.currentUserProfileUser.userProfileAbout,
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
