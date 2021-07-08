import 'package:JumpIn/features/plans_home/domain/edit_private_plan_controller.dart';
import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPlanProfileTextFieldDesc extends StatefulWidget {
  const EditPlanProfileTextFieldDesc(
      {Key key, @required this.size, @required this.hint})
      : super(key: key);
  final String hint;
  final Size size;

  @override
  _EditPlanProfileTextFieldDescState createState() =>
      _EditPlanProfileTextFieldDescState();
}

class _EditPlanProfileTextFieldDescState
    extends State<EditPlanProfileTextFieldDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: widget.size.width * 0.7,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white70),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration:
              InputDecoration(hintText: widget.hint, border: InputBorder.none),
        ),
      ),
    );
  }
}

class EditPlanProfileTextField extends StatefulWidget {
  const EditPlanProfileTextField(
      {Key key,
      @required this.hint,
      @required this.width,
      @required this.formKey,
      @required this.assigningCode,
      @required this.isEnabled})
      : super(key: key);

  final String hint;
  final double width;
  final bool isEnabled;
  final int assigningCode;
  final TextEditingController formKey;

  @override
  _EditPlanProfileTextFieldState createState() =>
      _EditPlanProfileTextFieldState();
}

class _EditPlanProfileTextFieldState extends State<EditPlanProfileTextField> {
  final EditPrivatePlanController editPrivatePlanController = Get.find();
  bool _isValEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
      width: widget.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white70),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (val) {
              editPrivatePlanController.assignValue(widget.assigningCode, val);
              setState(() {
                _isValEmpty = val.isEmpty;
              });
            },
            decoration: InputDecoration(
                enabled: widget.isEnabled,
                hintText: widget.hint,
                errorText: _isValEmpty ? "Can't be Empty" : "",
                hintStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 3,
                    fontFamily: font1,
                    color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
