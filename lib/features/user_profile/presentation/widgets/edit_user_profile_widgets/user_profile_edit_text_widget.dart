import 'package:JumpIn/features/user_profile/domain/edit_user_profile_controller.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserProfileTextField extends StatelessWidget {
  EditUserProfileTextField(
      {Key key,
      @required this.hint,
      @required this.size,
      @required this.formKey,
      @required this.assigningCode})
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
      margin: EdgeInsets.all(10),
      width: size.width * 0.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white70),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: formKey,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
            onChanged: (val) => editUserProfileController.assignValue(
                assigningCode, formKey.text),
            decoration:
                InputDecoration(hintText: hint, border: InputBorder.none),
          )),
    );
  }
}
