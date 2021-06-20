import 'dart:core';

import 'package:JumpIn/features/user_profile/domain/user_profile_controller.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/user_profile_widgets/about_user_widget.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/user_profile_widgets/edu_and_job_widget.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/user_profile_widgets/i_am_on_jumpin_for_widget.dart';
import 'package:JumpIn/features/user_profile/presentation/widgets/user_profile_widgets/image_slider_widget.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import '../widgets/user_profile_widgets/user_interests_list_widget.dart';
import '../widgets/user_profile_widgets/user_details_widget.dart';
import '../widgets/user_profile_widgets/academic_widget.dart';

class ScreenUserProfile extends StatefulWidget {
  @override
  _ScreenUserProfileState createState() => _ScreenUserProfileState();
}

class _ScreenUserProfileState extends State<ScreenUserProfile> {
  ConnectionChecker cc = ConnectionChecker();

  FocusNode bioFocusNode;
  FocusNode jumpinFocusNode;

  @override
  void initState() {
    bioFocusNode = FocusNode();
    jumpinFocusNode = FocusNode();
    super.initState();
    cc.checkConnection(context);
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileController =
        Provider.of<UserProfileController>(context, listen: false);
    return KeyboardDismisser(
        gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
        child: Scaffold(
          body: SafeArea(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(sharedPrefs.userid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return circularProgressIndicator();
                  } else if (snapshot.hasError) {
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text('Network Error'),
                            ));
                  }
                  profileController.getUserDocumentSnapshot(
                      context, snapshot.data);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: size.width,
                          height: size.height * 0.27,
                          // color: Colors.black12,
                          child: Stack(
                            children: [
                              Container(
                                width: size.width,
                                height: size.height * 0.17,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [Colors.blue[900], Colors.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                              ),
                              Positioned(
                                  left: size.width * 0.34,
                                  top: size.height * 0.07,
                                  child: Stack(
                                    children: [
                                      Container(
                                          width: size.height * 0.18,
                                          height: size.height * 0.18,
                                          child: imageSlider(context,
                                              profileController.getImageURLs)),
                                      Positioned(
                                        bottom: size.height * 0.005,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(rEditUserProfile),
                                          child: Container(
                                              // color: Colors.white,
                                              width: size.height * 0.04,
                                              height: size.height * 0.04,
                                              alignment: Alignment.topLeft,
                                              child: Image.asset(
                                                  "assets/images/Profile/edit.png")),
                                        ),
                                      )
                                    ],
                                  )),
                              Positioned(
                                bottom: size.height * 0.03,
                                left: (size.width * 0.5) / 8,
                                child: Column(
                                  children: [
                                    Text("Connections",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        sharedPrefs.myNoOfConnections
                                            .toString(),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: size.height * 0.025,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: size.height * 0.03,
                                left: size.width - size.width * 0.2,
                                child: Column(
                                  children: [
                                    Text("Plans",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w500)),
                                    Text(0.toString(),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: size.height * 0.025,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: Text(
                              profileController.currentUserProfileUser.username
                                      .startsWith("@")
                                  ? profileController
                                      .currentUserProfileUser.username
                                  : "@${profileController.currentUserProfileUser.username}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005),
                          child: Text(
                              profileController.currentUserProfileUser.fullname,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: size.height * 0.035,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005),
                          child: Text(
                              profileController.currentUserProfileUser
                                          .profession.length ==
                                      0
                                  ? "Jumpin User"
                                  : profileController
                                      .currentUserProfileUser.profession,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.w700)),
                        ),
                        UserDetailsWidget(
                            size: size, profileController: profileController),
                        EduNJobWidget(
                            size: size, profileController: profileController),
                        AcademicWidget(
                            size: size, profileController: profileController),
                        UserAboutWidget(
                            size: size,
                            profileController: profileController,
                            bioFocusNode: bioFocusNode),
                        IAmOnJumpinFor(
                            size: size,
                            profileController: profileController,
                            jumpinFocusNode: jumpinFocusNode),
                        UserInterestsListWidget(
                            size: size, profileController: profileController)
                      ],
                    ),
                  );
                }),
          ),
        ));
  }
}

// final UserProfileController profileController =
//     Get.put(UserProfileController());

// @override
// Widget build(BuildContext context) {
//   Size size = MediaQuery.of(context).size;

//   return WillPopScope(
//     onWillPop: () {
//       return Future(() => false);
//     },
//     child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: JumpinAppBar(context, 'User Profile'),
//         body: StreamBuilder(
// stream: profileController.getUserDocs(),
// builder: (context, snapshot) {
//   if (!snapshot.hasData) {
//     return circularProgressIndicator();
//   } else if (snapshot.hasError) {
//     showDialog(
//         context: context,
//         builder: (context) => const AlertDialog(
//               title: Text('Network Error'),
//             ));
//   }
//   profileController.getUserDocumentSnapshot(snapshot.data);
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       margin: const EdgeInsets.all(10),
//                       width: size.width,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Container(
//                                   margin: const EdgeInsets.all(10),
//                                   child: Column(
//                                     children: [
//                                       Text(
// sharedPrefs.myNoOfConnections
//     .toString(),
//                                           style: TextStyle(
//                                               fontFamily: font1,
//                                               fontSize: SizeConfig
//                                                       .blockSizeHorizontal *
//                                                   5)),
//                                       Text('People',
//                                           style: TextStyle(
//                                               fontSize: SizeConfig
//                                                       .blockSizeHorizontal *
//                                                   5))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                   height: SizeConfig.blockSizeHorizontal * 25,
//                                   width: SizeConfig.blockSizeVertical * 17,
//                                   margin: const EdgeInsets.only(bottom: 20),
//                                   decoration: const BoxDecoration(
//                                       shape: BoxShape.circle),
//                                   child: Stack(children: [
//                                     Positioned(child: imageSlider(context)),
//                                   ])),
//                               Container(
//                                 margin: const EdgeInsets.all(10),
//                                 child: Column(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.center,
//                                       child: Text('0',
//                                           style: TextStyle(
//                                               fontFamily: font1,
//                                               fontSize: SizeConfig
//                                                       .blockSizeHorizontal *
//                                                   5)),
//                                     ),
//                                     Align(
//                                         alignment: Alignment.center,
//                                         child: Text('Plans',
//                                             style: TextStyle(
//                                                 fontSize: SizeConfig
//                                                         .blockSizeHorizontal *
//                                                     5)))
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           TOPUserInfoCard(size: getScreenSize(context))
//                         ],
//                       )),
//                   About(
//                     size: size,
//                     interests: profileController
//                         .currentUserProfileUser.interestList as List<String>,
//                   ),
//                 ],
//               ),
//             );
//           },
//         )),
//   );
// }
// }
