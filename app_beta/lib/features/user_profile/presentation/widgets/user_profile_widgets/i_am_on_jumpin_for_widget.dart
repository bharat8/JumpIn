import 'package:JumpIn/features/user_profile/domain/user_profile_controller.dart';
import 'package:flutter/material.dart';

class IAmOnJumpinFor extends StatelessWidget {
  const IAmOnJumpinFor({
    Key key,
    @required this.size,
    @required this.profileController,
    @required this.jumpinFocusNode,
  }) : super(key: key);

  final Size size;
  final UserProfileController profileController;
  final FocusNode jumpinFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      color: Colors.blue[50],
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.025),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: size.width * 0.025),
                child: Text("I am on Jumpin for",
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w600)),
              ),
              if (profileController.currentUserProfileUser.inJumpinFor == null)
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(jumpinFocusNode);
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
            width: size.width * 0.8,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.015),
            child: profileController.currentUserProfileUser.inJumpinFor == null
                ? TextField(
                    textAlign: TextAlign.center,
                    focusNode: jumpinFocusNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                      hintText: "You are on jumpin for",
                      hintStyle: TextStyle(fontSize: size.height * 0.02),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: size.width * 0.025),
                    child: Center(
                      child: Text(
                        profileController.currentUserProfileUser.inJumpinFor,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
