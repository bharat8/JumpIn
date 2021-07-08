import 'package:JumpIn/features/user_profile/domain/edit_user_profile_controller.dart';
import 'package:JumpIn/features/user_signup/presentation/phone_verification.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

class UserEditsDOB extends StatefulWidget {
  const UserEditsDOB({Key key, @required this.bgColor}) : super(key: key);

  final Color bgColor;
  @override
  _UserEditsDOBState createState() => _UserEditsDOBState();
}

class _UserEditsDOBState extends State<UserEditsDOB> {
  String dateValue = sharedPrefs.dobYear.toString() +
      '/' +
      sharedPrefs.dobMonth.toString() +
      '/' +
      sharedPrefs.dobDay.toString();

  final EditUserProfileController editUserProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: getScreenSize(context).width * 0.8,
      bgColor: widget.bgColor,
      child: Container(
        height: getScreenSize(context).height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateValue,
              style: TextStyle(color: Colors.black, fontFamily: 'TrebuchetMS'),
            ),
            GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1950, 3, 5),
                    maxTime: DateTime(2007, 12, 31), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  setState(() {
                    dateValue = date.year.toString() +
                        '/' +
                        date.month.toString() +
                        '/' +
                        date.day.toString();
                    editUserProfileController.setDob = date;
                  });
                });
              },
              child: const ImageIcon(
                AssetImage('assets/images/Home/calendar_cicon.png'),
                color: ColorsJumpin.kPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
