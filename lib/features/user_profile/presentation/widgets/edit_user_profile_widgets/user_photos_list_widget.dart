import 'package:JumpIn/features/user_profile/domain/edit_user_profile_controller.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/edit_user_profile_widgets/user_photo_placeholder_widget.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfUserPhotos extends StatelessWidget {
  ListOfUserPhotos({Key key, @required this.size}) : super(key: key);

  final Size size;

  final EditUserProfileController editUserProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(sharedPrefs.userid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgressIndicator();
              }
              List listOfUserPhotos = [];
              //print(snapshot.data.data()['photoLists']);
              List.from(snapshot.data.data()['photoLists'] as Iterable)
                  .forEach((element) {
                listOfUserPhotos.add(element);
              });
              return Container(
                height: size.height * 0.218,
                width: size.width,
                child: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(
                        listOfUserPhotos.length == null
                            ? 0
                            : listOfUserPhotos.length,
                        (index) => UserPhotoPlaceHolder(
                            imageURL: listOfUserPhotos[index] as String))),
              );
            }),
        RaisedButton(
          color: Colors.white,
          elevation: 0,
          onPressed: () async {
            print("upload a new photo tapped");
            await editUserProfileController.pickImage();
          },
          //margin: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: SizeConfig.blockSizeHorizontal * 4),
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
      ],
    );
  }
}
