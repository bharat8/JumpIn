import 'package:JumpIn/features/user_profile/domain/edit_user_profile_controller.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserProfileTextFieldDesc extends StatelessWidget {
  EditUserProfileTextFieldDesc(
      {Key key,
      @required this.size,
      @required this.hint,
      @required this.assigningCode,
      @required this.formKey})
      : super(key: key);
  final String hint;
  final Size size;
  final TextEditingController formKey;
  final int assigningCode;

  final EditUserProfileController editUserProfileController = Get.find();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.all(10),
      width: size.width * 0.7,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white70),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: formKey,
            maxLines: 10,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
            onChanged: (val) => editUserProfileController.assignValue(
                assigningCode, formKey.text),
            decoration:
                InputDecoration(hintText: hint, border: InputBorder.none),
          )),
    );
  }
}
