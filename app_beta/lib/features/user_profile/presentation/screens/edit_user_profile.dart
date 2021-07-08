import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/features/user_profile/domain/edit_user_profile_controller.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/edit_user_profile_widgets/user_photos_list_widget.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/edit_user_profile_widgets/user_profile_edit_text_desc_widget.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/edit_user_profile_widgets/user_profile_edit_text_widget.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenEditUserProfile extends StatefulWidget {
  @override
  _ScreenEditUserProfileState createState() => _ScreenEditUserProfileState();
}

class _ScreenEditUserProfileState extends State<ScreenEditUserProfile> {
  ConnectionChecker cc = ConnectionChecker();

  TextEditingController _fullNameEditformKey;

  TextEditingController _userNameEditformKey;

  TextEditingController _genderEditformKey;

  TextEditingController _dobEditformKey;

  TextEditingController _professionEditformKey;

  TextEditingController _placeOfWorkformKeyEdit;

  TextEditingController _placeOfEduformKeyEdit;

  TextEditingController _acadCourseformKeyEdit;

  TextEditingController _wtfDescformKeyEdit;

  TextEditingController _aboutformKeyEdit;

  TextEditingController _imInJumpinForformKeyEdit;

  @override
  void initState() {
    cc.checkConnection(context);
    _fullNameEditformKey = TextEditingController();
    _userNameEditformKey = TextEditingController();
    _dobEditformKey = TextEditingController();
    _genderEditformKey = TextEditingController();
    _professionEditformKey = TextEditingController();
    _placeOfEduformKeyEdit = TextEditingController();
    _placeOfWorkformKeyEdit = TextEditingController();
    _acadCourseformKeyEdit = TextEditingController();
    _wtfDescformKeyEdit = TextEditingController();
    _aboutformKeyEdit = TextEditingController();
    _imInJumpinForformKeyEdit = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    cc.listener.cancel();
    _acadCourseformKeyEdit.dispose();
    _fullNameEditformKey.dispose();
    _userNameEditformKey.dispose();
    _dobEditformKey.dispose();
    _genderEditformKey.dispose();
    _placeOfEduformKeyEdit.dispose();
    _placeOfWorkformKeyEdit.dispose();
    _wtfDescformKeyEdit.dispose();
    _aboutformKeyEdit.dispose();
    _imInJumpinForformKeyEdit.dispose();
    super.dispose();
  }

  //Future<List<String>> getUserPhotos() async {}
  final EditUserProfileController editUserProfileController =
      Get.put(EditUserProfileController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    final mediaQueryData = MediaQuery.of(context);

    return Scaffold(
        appBar: JumpinAppBar(context, 'Edit'),
        body: Obx(
          () => editUserProfileController.isUpdatingUserData.value == false
              ? FutureBuilder(
                  future: editUserProfileController.getUserDocumentSnapshot(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return circularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Could not fetch data.Check Network!'),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListOfUserPhotos(size: size),
                          Container(
                            margin: EdgeInsets.all(10),
                            width: size.width,
                            decoration: BoxDecoration(
                              color: ColorsJumpin.kPrimaryColorLite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 30),
                                EditUserProfileTextField(
                                  formKey: _fullNameEditformKey,
                                  assigningCode: 0,
                                  size: size,
                                  hint: editUserProfileController
                                          .currentEditUser.fullname.isEmpty
                                      ? "Enter Full Name"
                                      : "Your full name is ${editUserProfileController.currentEditUser.fullname}",
                                ),
                                EditUserProfileTextField(
                                  formKey: _userNameEditformKey,
                                  assigningCode: 1,
                                  size: size,
                                  hint: editUserProfileController
                                          .currentEditUser.username.isEmpty
                                      ? "Enter username"
                                      : "Your username is ${editUserProfileController.currentEditUser?.username}",
                                ),
                                EditUserProfileTextField(
                                  formKey: _professionEditformKey,
                                  size: size,
                                  assigningCode: 4,
                                  hint: editUserProfileController
                                          .currentEditUser.profession.isEmpty
                                      ? "Enter your profession"
                                      : "Your profession is ${editUserProfileController.currentEditUser?.profession}",
                                ),
                                EditUserProfileTextField(
                                    formKey: _placeOfWorkformKeyEdit,
                                    size: size,
                                    assigningCode: 5,
                                    hint: editUserProfileController
                                            .currentEditUser.placeOfWork.isEmpty
                                        ? "Enter Place Of Work"
                                        : "Place where you work is ${editUserProfileController.currentEditUser?.placeOfWork}"),
                                EditUserProfileTextField(
                                  formKey: _placeOfEduformKeyEdit,
                                  size: size,
                                  assigningCode: 6,
                                  hint: editUserProfileController
                                          .currentEditUser.placeOfEdu.isEmpty
                                      ? "Enter Place Of Education"
                                      : "Your place of education " +
                                          editUserProfileController
                                              .currentEditUser?.placeOfEdu,
                                ),
                                EditUserProfileTextField(
                                    formKey: _acadCourseformKeyEdit,
                                    size: size,
                                    assigningCode: 7,
                                    hint: editUserProfileController
                                            .currentEditUser.acadCourse.isEmpty
                                        ? "Enter Academic Course"
                                        : "Academic Course you enrolled is" +
                                            editUserProfileController
                                                .currentEditUser.acadCourse),
                                EditUserProfileTextFieldDesc(
                                    formKey: _aboutformKeyEdit,
                                    assigningCode: 9,
                                    size: size,
                                    hint: editUserProfileController
                                            .currentEditUser
                                            .userProfileAbout
                                            .isEmpty
                                        ? "Enter About You"
                                        : "Your About Me section contains\n\n" +
                                            editUserProfileController
                                                .currentEditUser
                                                .userProfileAbout),
                                EditUserProfileTextFieldDesc(
                                    formKey: _imInJumpinForformKeyEdit,
                                    assigningCode: 10,
                                    size: size,
                                    hint: editUserProfileController
                                            .currentEditUser.inJumpinFor.isEmpty
                                        ? "Why are you on Jumpin"
                                        : "The reason you are on Jumpin is \n\n " +
                                            editUserProfileController
                                                .currentEditUser?.inJumpinFor)
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            width: getScreenSize(context).width * 0.5,
                            height: getScreenSize(context).height * 0.1,
                            child: RaisedButton(
                              onPressed: () async {
                                editUserProfileController
                                    .isUpdatingUserData.value = true;

                                await editUserProfileController
                                    .updateUserOnDatabase()
                                    .then((value) {
                                  editUserProfileController
                                      .isUpdatingUserData.value = false;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                                'User Successfully Updated'),
                                          ));
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              color: Colors.lightGreen,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Update",
                                    style: TextStyle(
                                        fontFamily: font1,
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                4)),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
              : circularProgressIndicator(),
        ));
  }
}
