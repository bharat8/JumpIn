import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_plan/desc_plan_textfield.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_plan/edit_plan_start.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_plan/edit_textfield_template.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_plan/select_category.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserPlanInfoList extends StatefulWidget {
  const EditUserPlanInfoList({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _EditUserPlanInfoListState createState() => _EditUserPlanInfoListState();
}

class _EditUserPlanInfoListState extends State<EditUserPlanInfoList> {
  Color isOnlineCheckBoxColor = ColorsJumpin.kSecondaryColor;
  Color isMultiplanCheckBoxColor = ColorsJumpin.kSecondaryColor;
  Color isAgeRestrictedCheckBoxColor = ColorsJumpin.kSecondaryColor;
  Color isFeeEnabledCheckBoxColor = ColorsJumpin.kSecondaryColor;
  TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);
  EditPublicPlanController editPublicPlanController =
      Get.put(EditPublicPlanController());

  bool isMultiDay = false;
  bool isOnline = false;
  bool isAgeRestricted = false;
  bool isFeeEnabled = false;

  Widget enterLocationWidget;
  Widget enterFinishDateOfEvent;
  Widget enterAgeRestriction;
  Widget enterFee;

  TextEditingController _planNameEditformKey;

  TextEditingController _planLocationEditformKey;

  TextEditingController _dateOfPlanEditformKey;

  TextEditingController _startTimeEditformKey;

  TextEditingController _endTimeformKeyEdit;

  TextEditingController _planDescformKeyEdit;

  TextEditingController _ageformKeyEdit;

  TextEditingController _feeformKeyEdit;

  @override
  void initState() {
    _planDescformKeyEdit = TextEditingController();
    _planNameEditformKey = TextEditingController();
    _planLocationEditformKey = TextEditingController();
    _dateOfPlanEditformKey = TextEditingController();
    _startTimeEditformKey = TextEditingController();
    _endTimeformKeyEdit = TextEditingController();
    _ageformKeyEdit = TextEditingController();
    _feeformKeyEdit = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _planNameEditformKey.dispose();
    _planDescformKeyEdit.dispose();
    _planLocationEditformKey.dispose();
    _dateOfPlanEditformKey.dispose();
    _startTimeEditformKey.dispose();
    _endTimeformKeyEdit.dispose();
    _ageformKeyEdit.dispose();
    _feeformKeyEdit.dispose();
    super.dispose();
  }

  void onTimeChanged(TimeOfDay newTime) {
    editPublicPlanController.assignTime(newTime, 5);
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    enterFinishDateOfEvent = isMultiDay == false
        ? Container()
        : PlanEventDateEntry(
            assigningCode: 4,
            width: getScreenSize(context).width * 0.6,
          );
    enterLocationWidget = isOnline == false
        ? EditPlanProfileTextField(
            isEnabled: true,
            assigningCode: 2,
            formKey: _planLocationEditformKey,
            width: widget.size.width * 0.4,
            hint: 'Enter Location')
        : EditPlanProfileTextField(
            isEnabled: false,
            formKey: _planLocationEditformKey,
            assigningCode: 2,
            width: widget.size.width * 0.4,
            hint: 'Enter Location');

    enterAgeRestriction = isAgeRestricted == true
        ? EditPlanProfileTextField(
            isEnabled: true,
            formKey: _ageformKeyEdit,
            assigningCode: 7,
            width: widget.size.width * 0.4,
            hint: 'Enter Age')
        : EditPlanProfileTextField(
            isEnabled: false,
            assigningCode: 7,
            formKey: _ageformKeyEdit,
            width: widget.size.width * 0.4,
            hint: 'Enter Age');
    enterFee = isFeeEnabled == true
        ? EditPlanProfileTextField(
            isEnabled: true,
            assigningCode: 8,
            formKey: _feeformKeyEdit,
            width: widget.size.width * 0.4,
            hint: 'Entry Fee')
        : EditPlanProfileTextField(
            isEnabled: false,
            formKey: _feeformKeyEdit,
            assigningCode: 8,
            width: widget.size.width * 0.4,
            hint: 'Entry Fee');

    return Container(
      margin: const EdgeInsets.all(10),
      width: widget.size.width,
      decoration: BoxDecoration(
        color: ColorsJumpin.kPrimaryColorLite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const SelectCategory(),
            Align(
              alignment: Alignment.centerLeft,
              child: EditPlanProfileTextField(
                  isEnabled: true,
                  assigningCode: 1,
                  formKey: _planNameEditformKey,
                  width: widget.size.width * 0.4,
                  hint: 'Enter Plan Title'),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              enterLocationWidget,
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isOnlineCheckBoxColor =
                          isOnlineCheckBoxColor == Colors.green
                              ? Colors.black
                              : Colors.green;

                      if (isOnline == null) {
                        isOnline = true;
                      } else {
                        isOnline = !isOnline;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.check_box, color: isOnlineCheckBoxColor),
                      const Text('Online')
                    ],
                  ))
            ]),
            Row(children: [
              PlanEventDateEntry(
                assigningCode: 3,
                width: getScreenSize(context).width * 0.55,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isMultiplanCheckBoxColor =
                          isMultiplanCheckBoxColor == Colors.green
                              ? Colors.black
                              : Colors.green;
                      if (isMultiDay == null) {
                        isMultiDay = true;
                      } else {
                        isMultiDay = !isMultiDay;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.check_box, color: isMultiplanCheckBoxColor),
                      const Text('Multi-day')
                    ],
                  ))
            ]),
            enterFinishDateOfEvent,
            Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: _time,
                          onChange: onTimeChanged,
                        ),
                      );
                    },
                    child: Container(
                        margin:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                        width: getScreenSize(context).width / 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white70),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  _time == TimeOfDay.now().replacing(hour: 1)
                                      ? 'Choose Start Time'
                                      : "${_time.hour}:${_time.minute}",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3,
                                      fontFamily: font1,
                                      color: _time == null
                                          ? Colors.grey
                                          : Colors.black),
                                )))))),
            Align(
              alignment: Alignment.centerLeft,
              child: DescribePlanTextField(
                  assigningValue: 6,
                  formKey: _planDescformKeyEdit,
                  width: getScreenSize(context).width * 0.5,
                  hint: 'Describe Your Plan'),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              enterAgeRestriction,
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isAgeRestrictedCheckBoxColor =
                          isAgeRestrictedCheckBoxColor == Colors.green
                              ? Colors.black
                              : Colors.green;

                      isAgeRestricted = !isAgeRestricted;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.check_box,
                          color: isAgeRestrictedCheckBoxColor),
                      Text(
                        " Age Restricted",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                            color: Colors.black),
                      )
                    ],
                  ))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              enterFee,
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isFeeEnabledCheckBoxColor =
                          isFeeEnabledCheckBoxColor == Colors.green
                              ? Colors.black
                              : Colors.green;

                      if (isFeeEnabled == null) {
                        isFeeEnabled = true;
                      } else {
                        isFeeEnabled = !isFeeEnabled;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.check_box, color: isFeeEnabledCheckBoxColor),
                    ],
                  ))
            ]),
            Align(
              alignment: Alignment.centerLeft,
              child: EditPlanProfileTextField(
                  isEnabled: true,
                  assigningCode: 9,
                  formKey: _planNameEditformKey,
                  width: widget.size.width * 0.4,
                  hint: 'Total Spots'),
            )
          ],
        ),
      ),
    );
  }
}
