import 'package:JumpIn/core/utils/handle_screen_orientation.dart';
import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/features/plans_home/data/model_plan.dart';
import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_plan/edit_plan_info_list.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_plan/list_of_plans_photos.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_plan/upload_photo.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenCreatePublicPlanProfile extends StatefulWidget {
  @override
  _ScreenCreatePublicPlanProfileState createState() =>
      _ScreenCreatePublicPlanProfileState();
}

class _ScreenCreatePublicPlanProfileState
    extends State<ScreenCreatePublicPlanProfile> {
  ConnectionChecker cc = ConnectionChecker();
  EditPublicPlanController editPublicPlanController =
      Get.put(EditPublicPlanController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final mediaQueryData = MediaQuery.of(context);

    if (mediaQueryData.orientation == Orientation.landscape) {
      return HandleLandscapeChange();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: JumpinAppBar(context, 'Public Plan'),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListOfPlanPhotos(),
          EditUserPlanInfoList(size: size),
          const SizedBox(height: 10),
          RaisedButton(
            onPressed: () {
              if (editPublicPlanController.isLoading.value == true) {
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
                editPublicPlanController.checkForEmptyFields(context);
                if (editPublicPlanController.nullExists == false &&
                    editPublicPlanController.dontAskForPhotos == true) {
                  editPublicPlanController.setIsLoading(true);
                  editPublicPlanController.updatePlanOnDatabase(context);
                }
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Obx(() {
                  return editPublicPlanController.isLoading.value == false
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
