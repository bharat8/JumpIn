import 'package:JumpIn/features/plans_home/domain/edit_private_plan_controller.dart';
import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DescribePlanTextField extends StatefulWidget {
  const DescribePlanTextField(
      {Key key,
      @required this.hint,
      @required this.width,
      this.assigningValue,
      this.formKey,
      this.leftMargin,
      this.isEnabled})
      : super(key: key);

  final String hint;
  final double width;
  final double leftMargin;
  final bool isEnabled;
  final int assigningValue;
  final TextEditingController formKey;

  @override
  _DescribePlanTextFieldState createState() => _DescribePlanTextFieldState();
}

class _DescribePlanTextFieldState extends State<DescribePlanTextField> {
  bool _isValEmpty = true;
  EditPrivatePlanController editPrivatePlanController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
      width: widget.width,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white70),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 10,
            onChanged: (val) {
              editPrivatePlanController.assignValue(widget.assigningValue, val);
              setState(() {
                _isValEmpty = val.isEmpty;
              });
            },
            decoration: InputDecoration(
                enabled:
                    widget.isEnabled == null || widget.isEnabled ? true : false,
                hintText: widget.hint,
                errorText: _isValEmpty ? "Can't be empty" : "",
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
