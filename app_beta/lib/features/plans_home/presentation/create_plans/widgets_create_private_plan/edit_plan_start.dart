import 'package:JumpIn/features/plans_home/domain/edit_private_plan_controller.dart';
import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/features/user_signup/presentation/phone_verification.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

class PlanEventDateEntry extends StatefulWidget {
  const PlanEventDateEntry(
      {Key key, @required this.width, @required this.assigningCode})
      : super(key: key);

  final double width;
  final int assigningCode;
  @override
  _PlanEventDateEntryState createState() => _PlanEventDateEntryState();
}

class _PlanEventDateEntryState extends State<PlanEventDateEntry> {
  String dateValue = 'Enter Date Of Event';
  EditPrivatePlanController editPrivatePlanController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white70),
      child: TextFieldContainer(
        width: widget.width,
        bgColor: offWhite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateValue,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: SizeConfig.blockSizeHorizontal * 3,
                  fontFamily: 'TrebuchetMS'),
            ),
            GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  editPrivatePlanController.assignDate(
                      date, widget.assigningCode);
                  setState(() {
                    dateValue = "${date.year}/${date.month}/${date.day}";
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
