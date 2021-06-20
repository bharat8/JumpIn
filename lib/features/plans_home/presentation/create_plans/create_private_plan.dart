import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/features/plans_home/data/model_plan.dart';
import 'package:JumpIn/features/plans_home/domain/edit_private_plan_controller.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_private_plan/edit_plan_info_list.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_private_plan/list_of_plans_photos.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

import 'package:JumpIn/core/utils/utils.dart';
import 'package:get/get.dart';

class ScreenCreatePrivatePlanProfile extends StatefulWidget {
  @override
  _ScreenCreatePrivatePlanProfileState createState() =>
      _ScreenCreatePrivatePlanProfileState();
}

class _ScreenCreatePrivatePlanProfileState
    extends State<ScreenCreatePrivatePlanProfile> {
  ConnectionChecker cc = ConnectionChecker();
  EditPrivatePlanController editPrivatePlanController =
      Get.put(EditPrivatePlanController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: JumpinAppBar(context, 'Private Plan'),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListOfPlanPhotos(),
          EditUserPlanInfoList(size: size),
          const SizedBox(height: 10),
          RaisedButton(
            onPressed: () {
              if (editPrivatePlanController.isLoading.value == true) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Processing... Please Wait",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 3,
                              color: Colors.greenAccent),
                        ),
                      );
                    });
              } else {
                print("inside else");
                //Navigator.pushNamed(context, rPlanProfile);
                editPrivatePlanController.checkForEmptyFields(context);
                if (editPrivatePlanController.nullExists == false &&
                    editPrivatePlanController.dontAskForPhotos == true) {
                  editPrivatePlanController.setIsLoading(true);
                  editPrivatePlanController.updatePlanOnDatabase(context);
                }
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Obx(() {
                  return editPrivatePlanController.isLoading.value == false
                      ? Text(
                          'Create'.toUpperCase(),
                          style: TextStyle(
                              fontFamily: font1,
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeHorizontal * 5),
                        )
                      : Text(
                          'Loading...',
                          style: TextStyle(
                              fontFamily: font1,
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeHorizontal * 4),
                        );
                })),
            color: Colors.green[600],
            elevation: 10,
          )
        ],
      )),
    );
  }
}
