import 'package:JumpIn/core/network/service_user_profile.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class UserPhotoPlaceHolder extends StatefulWidget {
  const UserPhotoPlaceHolder({Key key, @required this.imageURL})
      : super(key: key);

  final String imageURL;

  @override
  _UserPhotoPlaceHolderState createState() => _UserPhotoPlaceHolderState();
}

class _UserPhotoPlaceHolderState extends State<UserPhotoPlaceHolder> {
  bool isPhotoTapped = false;
  String imageUrl = "dummyUrl";

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
                            deleteImageFromFirebaseStorage(widget.imageURL);
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
