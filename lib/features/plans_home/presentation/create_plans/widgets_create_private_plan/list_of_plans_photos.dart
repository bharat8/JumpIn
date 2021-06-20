import 'package:JumpIn/features/plans_home/data/model_plan.dart';
import 'package:JumpIn/features/plans_home/domain/edit_private_plan_controller.dart';
import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/widgets_create_private_plan/plan_photo_placeholder.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfPlanPhotos extends StatefulWidget {
  ListOfPlanPhotos({
    Key key,
  }) : super(key: key);

  @override
  _ListOfPlanPhotosState createState() => _ListOfPlanPhotosState();
}

class _ListOfPlanPhotosState extends State<ListOfPlanPhotos> {
  final EditPrivatePlanController editPrivatePlanController = Get.find();

  @override
  void initState() {
    editPrivatePlanController.resetFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "photo lists as got from state -> ${editPrivatePlanController.listOfPlanPhotos} ");
    SizeConfig().init(context);
    return Column(
      children: [
        Container(
          height: getScreenSize(context).height * 0.218,
          width: getScreenSize(context).width,
          child: Obx(
            () => GridView.count(
                crossAxisCount: 3,
                children: List.generate(
                    editPrivatePlanController.listOfPlanPhotos.length,
                    (index) => PlanPhotoPlaceholder(
                        imageURL: editPrivatePlanController
                            .listOfPlanPhotos[index] as String))),
          ),
        ),
        Obx(() {
          return editPrivatePlanController.isPhotoUploading.value == false
              ? RaisedButton(
                  color: Colors.white,
                  elevation: 0,
                  onPressed: () async {
                    editPrivatePlanController.isPhotoUploading.value = true;
                    print("upload a new photo tapped with upload progress as ");

                    await editPrivatePlanController.pickImageForPrivatePlan();
                  },
                  //margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                          size: SizeConfig.blockSizeHorizontal * 4),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          'Upload New Photo',
                          style: TextStyle(
                              fontFamily: font1,
                              fontSize: SizeConfig.blockSizeHorizontal * 4),
                        ),
                      )
                    ],
                  ),
                )
              : circularProgressIndicator();
        })
      ],
    );
  }
}
