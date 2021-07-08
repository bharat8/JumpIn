import 'package:JumpIn/features/plans_home/domain/edit_private_plan_controller.dart';
import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanPhotoPlaceholder extends StatefulWidget {
  const PlanPhotoPlaceholder({Key key, @required this.imageURL})
      : super(key: key);

  final String imageURL;

  @override
  _PlanPhotoPlaceholderState createState() => _PlanPhotoPlaceholderState();
}

class _PlanPhotoPlaceholderState extends State<PlanPhotoPlaceholder> {
  bool isPhotoTapped = false;
  String imageUrl = "dummyUrl";
  EditPrivatePlanController editPrivatePlanController = Get.find();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: imageUrl == ""
            ? Container()
            : isPhotoTapped == false
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isPhotoTapped = true;
                      });
                    },
                    child: CircleAvatar(
                      radius: SizeConfig.blockSizeHorizontal * 10,
                      backgroundImage: NetworkImage(widget.imageURL),
                    ))
                : Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            print(
                                "widget imageURL to be deleted -> ${widget.imageURL} ");
                            editPrivatePlanController
                                .deletePrivatePlanImageFromFirebaseStorage(
                                    widget.imageURL);

                            setState(() {
                              imageUrl = "";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Delete Photo',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 2,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isPhotoTapped = false;
                            });
                          },
                          child: CircleAvatar(
                            radius: SizeConfig.blockSizeHorizontal * 10,
                            backgroundImage: NetworkImage(widget.imageURL),
                          ))
                    ],
                  ));
  }
}
