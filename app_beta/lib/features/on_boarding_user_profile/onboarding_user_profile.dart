import 'dart:async';
import 'dart:convert';
import 'package:JumpIn/core/utils/handle_screen_orientation.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/user_signup/presentation/phone_verification.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../on_boarding_user_profile/domain/user_profile_provider.dart';

String onboardingUserFullName = "";
final _fullNameformKey = GlobalKey<FormState>();
String onboardingUserName = "";
final _userNameformKey = GlobalKey<FormState>();
DateTime dob;
String gender = "";
JumpinUser _onboardingSubmittingUser;
submit() {
  _fullNameformKey.currentState.save();
  _userNameformKey.currentState.save();
}

valueNotEnrered(BuildContext context, String title) {
  String dialogbartext = title == null ? "value not enterd" : title;
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text(
            dialogbartext,
          )));
}

bool checkEntry(BuildContext context) {
  if (gender == "") {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Gender Not Selected",
        )));
    return false;
  } else {
    print("from check $gender");
  }
  if (dob == null) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Date of Birth Not Entered",
        )));
    return false;
  } else {
    print("from check $dob");
  }
  return true;
}

storeUserInFireStoreDatabase(
    BuildContext context, List<String> userInterests) async {
  await Firebase.initializeApp();

  final userRef = FirebaseFirestore.instance.collection('users');

  DocumentSnapshot doc = await userRef.doc(sharedPrefs.userid).get();
  //creating the user in firestore

  List interests = (json.decode(sharedPrefs.myInterests) as List<dynamic>)
      .map<String>((item) => item as String)
      .toList();

  print("interests here $interests");

  userRef.doc(sharedPrefs.userid).set({
    "interestList": interests,
    "id": sharedPrefs.userid,
    "fullname": onboardingUserFullName == null
        ? sharedPrefs.fullname
        : onboardingUserFullName,
    "gender": gender,
    "username": onboardingUserName,
    "dob": dob,
    "profession": "",
    "placeOfWork": "",
    "placeOfEdu": "",
    "acadCourse": "",
    "wtfDesc": "",
    "userProfileAbout": "",
    "inJumpinFor": "",
    "photoLists": [sharedPrefs.photoUrl],
    "myConnections": [],
    "geoPoint": const GeoPoint(0.0, 0.0),
    "requestReceivedFrom": [],
    "requestSentTo": [],
    "timeStamp": DateTime.now(),
    "photoUrl": sharedPrefs.photoUrl,
    "email": sharedPrefs.email,
    "phoneNo": sharedPrefs.phoneNo,
    "facebookLoggedIn": false,
    "userNameSearchIndex": onboardingUserName.substring(0, 1)
  }).whenComplete(() async {
    DocumentSnapshot doc1 = await userRef.doc(sharedPrefs.userid).get();
    JumpinUser user =
        JumpinUser.fromDocument(doc1.data() as Map<String, dynamic>);

//updating user data for local use
    sharedPrefs.userName = user?.username;
    sharedPrefs.gender = user?.gender;
    sharedPrefs.dobYear = dob?.year;
    sharedPrefs.dobMonth = dob?.month;
    sharedPrefs.dobDay = dob?.day;
    sharedPrefs.fullname = user?.fullname;

    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorsJumpin.kPrimaryColor,
        content: Text(
          "Welcome To Jumpin ${sharedPrefs.fullname}",
        )));
    sharedPrefs.okToNavigateFromOnboardingUser = true;
    sharedPrefs.isSignedUp = true;
    sharedPrefs.isLoggedIn = true;
    sharedPrefs.isFacebookLoggedIn = false;

    Navigator.of(context).pushNamed(rOnboardingScreen);
  });
}

class OnboardingUserProfile extends StatefulWidget {
  OnboardingUserProfile({Key key, @required this.userInterests})
      : super(key: key);

  final List<String> userInterests;
  @override
  _OnboardingUserProfileState createState() => _OnboardingUserProfileState();
}

class _OnboardingUserProfileState extends State<OnboardingUserProfile> {
  @override
  Widget build(BuildContext context) {
    print("user's interest list -> ${widget.userInterests}");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final mediaQueryData = MediaQuery.of(context);
    if (mediaQueryData.orientation == Orientation.landscape) {
      return HandleLandscapeChange();
    }
    return WillPopScope(
      onWillPop: () {
        return Future(() {
          Navigator.of(context).pop();
          return true;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            BackgroundImage(
              topValue: 30.0,
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.03),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: width * 0.4,
                        color: Colors.blue[100],
                        padding: EdgeInsets.all(width * 0.02),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.edit,
                              size: height * 0.025,
                            ),
                            Text(
                              "Edit Interests",
                              style: TextStyle(fontSize: height * 0.02),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width * 0.5,
                    height: height * 0.09,
                  ),
                  AppProgressBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getScreenSize(context).height * 0.021),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => selectImage(),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: 10,
                              surfaceIntensity: 0.5,
                              lightSource: LightSource.top,
                              intensity: 0.8,
                              color: Colors.blue[100],
                            ),
                            child: Consumer<UserProfileProvider>(
                                builder: (context, userProfileProvider, child) {
                              return Container(
                                width: getScreenSize(context).width * 0.3,
                                height: getScreenSize(context).width * 0.3,
                                child: userProfileProvider
                                            .getImageSelectedStatus ==
                                        false
                                    ? Image.asset(
                                        "assets/images/Profile/avatar.png",
                                        fit: BoxFit.cover)
                                    : Image.file(
                                        userProfileProvider.getImageFile,
                                        fit: BoxFit.cover),
                              );
                            }),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => selectImage(),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.circle(),
                                  depth: 10,
                                  surfaceIntensity: 0.3,
                                  lightSource: LightSource.bottomRight,
                                  intensity: 0.8,
                                  color: Colors.blue[100],
                                ),
                                child: Container(
                                  width: getScreenSize(context).width * 0.1,
                                  height: getScreenSize(context).width * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(
                                      getScreenSize(context).width * 0.02),
                                  child:
                                      FittedBox(child: Icon(Icons.camera_alt)),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: getScreenSize(context).height * 0.02,
                    ),
                    child: UserFullNameEntry(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: getScreenSize(context).height * 0.02,
                    ),
                    child: UserNameEntry(),
                  ),
                  GenderEntry(bgColor: Colors.grey[200]),
                  DOBEntry(
                    bgColor: Colors.grey[200],
                  ),
                  TnC_AllEntrySubmission(
                    userInterests: widget.userInterests,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectImage() {
    final size = MediaQuery.of(context).size;
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: size.width,
          height: size.height * 0.15,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.04),
                    child: Text(
                      "Select image from",
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      userProfileProvider.selectImage("camera");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        width: size.width * 0.5,
                        height: size.height * 0.1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.black54,
                            ),
                            Text("Camera",
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54))
                          ],
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      userProfileProvider.selectImage("gallery");
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        width: size.width * 0.5,
                        height: size.height * 0.1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              color: Colors.black54,
                            ),
                            Text("Gallery",
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54))
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.03,
        width: size.width,
        child: Image.asset('assets/images/Onboarding/onboardingProgress3.png'));
  }
}

class TnC_AllEntrySubmission extends StatefulWidget {
  TnC_AllEntrySubmission({
    Key key,
    @required this.userInterests,
  }) : super(key: key);

  final List<String> userInterests;
  @override
  _TnC_AllEntrySubmissionState createState() => _TnC_AllEntrySubmissionState();
}

class _TnC_AllEntrySubmissionState extends State<TnC_AllEntrySubmission> {
  InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.beenhere_sharp,
                    color: Colors.green,
                    size: SizeConfig.blockSizeHorizontal * 5,
                  )),
              Text('Accept all',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: SizeConfig.blockSizeHorizontal * 2.3)),
              GestureDetector(
                onTap: () {
                  // webViewController.loadUrl(
                  //     urlRequest: URLRequest(
                  //         url: Uri.parse(
                  //             "https://drive.google.com/file/d/1dKsDCDmE6Wrv5Rmd-xxUTbOQR1JB1z8q/view?usp=sharing")));
                },
                child: Text(
                  ' Terms and Conditons',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue[300],
                      fontSize: SizeConfig.blockSizeHorizontal * 2.3),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (Provider.of<UserProfileProvider>(context, listen: false)
                      .getErrorStatus ==
                  true) {
                showError();
              } else {
                // closing the keyboard
                FocusScope.of(context).requestFocus(FocusNode());
                submit();
                if (_fullNameformKey.currentState.validate() &&
                    _userNameformKey.currentState.validate() &&
                    checkEntry(context)) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                        'Processing Data...',
                      )));
                  await storeUserInFireStoreDatabase(
                      context, widget.userInterests);
                  Provider.of<UserProfileProvider>(context, listen: false)
                      .uploadToDatabase();
                }
              }
            },
            child: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 10,
                surfaceIntensity: 0.1,
                lightSource: LightSource.top,
                intensity: 0.8,
                color: Colors.blue[100],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Start Vibing!',
                  style: TextStyle(
                      fontFamily: 'TrebuchetMS',
                      fontSize: SizeConfig.blockSizeHorizontal * 4),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showError() {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: size.width,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          child: Text(
            "Please select a photo before proceeding!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red[800].withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontSize: size.height * 0.02),
          ),
        );
      },
    );
  }
}

class DOBEntry extends StatefulWidget {
  const DOBEntry({Key key, @required this.bgColor}) : super(key: key);

  final Color bgColor;
  @override
  _DOBEntryState createState() => _DOBEntryState();
}

class _DOBEntryState extends State<DOBEntry> {
  String dateValue = "Date Of Birth";
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.symmetric(
          horizontal: getScreenSize(context).width * 0.08,
          vertical: getScreenSize(context).height * 0.02),
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 10,
        surfaceIntensity: 0.1,
        lightSource: LightSource.top,
        intensity: 0.8,
        color: widget.bgColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getScreenSize(context).width * 0.05,
        vertical: getScreenSize(context).height * 0.02,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              dateValue,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 3, 5),
                    maxTime: DateTime(2020, 12, 31), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  setState(() {
                    dateValue = date.year.toString() +
                        '/' +
                        date.month.toString() +
                        '/' +
                        date.day.toString();
                    dob = date;
                  });
                });
              },
              child: ImageIcon(
                const AssetImage('assets/images/Home/calendar_cicon.png'),
                color: ColorsJumpin.kPrimaryColor,
                size: SizeConfig.blockSizeHorizontal * 7,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GenderEntry extends StatefulWidget {
  const GenderEntry({
    Key key,
    @required this.bgColor,
  }) : super(key: key);

  final Color bgColor;

  @override
  _GenderEntryState createState() => _GenderEntryState();
}

class _GenderEntryState extends State<GenderEntry> {
  bool _isMaleSelected;
  bool _isFemaleSelected;
  bool _isNonBinarySelected;

  void assignGenderAsPassed() {
    String assigningCode = sharedPrefs.gender;
    if (assigningCode == "female") {
      _isFemaleSelected = true;
      _isMaleSelected = false;
      _isNonBinarySelected = false;
    } else if (assigningCode == "male") {
      _isMaleSelected = true;
      _isFemaleSelected = false;
      _isNonBinarySelected = false;
    } else if (assigningCode == "nonbinary") {
      _isNonBinarySelected = true;
      _isMaleSelected = false;
      _isFemaleSelected = false;
    } else {
      _isMaleSelected = false;
      _isFemaleSelected = false;
      _isNonBinarySelected = false;
    }
  }

  @override
  void initState() {
    assignGenderAsPassed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.symmetric(
          horizontal: getScreenSize(context).width * 0.08,
          vertical: getScreenSize(context).height * 0.02),
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 10,
        surfaceIntensity: 0.1,
        lightSource: LightSource.top,
        intensity: 0.8,
        color: widget.bgColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getScreenSize(context).width * 0.05,
        vertical: getScreenSize(context).height * 0.02,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              'Gender',
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    print('female tapped');
                    setState(() {
                      _isFemaleSelected = true;
                      gender = "female";
                      _isMaleSelected = false;
                      _isNonBinarySelected = false;
                    });
                    print(_isFemaleSelected);
                  },
                  child: _isFemaleSelected
                      ? ImageIcon(
                          AssetImage(
                              'assets/images/Onboarding/gender_female.png'),
                          color: Colors.blue,
                          size: SizeConfig.blockSizeHorizontal * 6)
                      : ImageIcon(
                          AssetImage(
                              'assets/images/Onboarding/gender_female.png'),
                          size: SizeConfig.blockSizeHorizontal * 6),
                ),
                InkWell(
                  onTap: () {
                    print('male tapped');
                    setState(() {
                      _isMaleSelected = true;
                      gender = "male";
                      _isFemaleSelected = false;
                      _isNonBinarySelected = false;
                    });
                    print(_isMaleSelected);
                  },
                  child: _isMaleSelected
                      ? ImageIcon(
                          AssetImage(
                              'assets/images/Onboarding/gender_male.png'),
                          size: SizeConfig.blockSizeHorizontal * 6,
                          color: Colors.blue,
                        )
                      : ImageIcon(
                          AssetImage(
                              'assets/images/Onboarding/gender_male.png'),
                          size: SizeConfig.blockSizeHorizontal * 6),
                ),
                InkWell(
                  onTap: () {
                    print('non-binary tapped');
                    setState(() {
                      _isNonBinarySelected = true;
                      gender = "nonbinary";
                      _isMaleSelected = false;
                      _isFemaleSelected = false;
                    });
                  },
                  child: _isNonBinarySelected
                      ? ImageIcon(
                          const AssetImage(
                              'assets/images/Onboarding/gender_non_binary.png'),
                          color: Colors.blue,
                          size: SizeConfig.blockSizeHorizontal * 6)
                      : ImageIcon(
                          const AssetImage(
                              'assets/images/Onboarding/gender_non_binary.png'),
                          size: SizeConfig.blockSizeHorizontal * 6),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserNameEntry extends StatelessWidget {
  const UserNameEntry({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<UserProfileProvider>(builder: (context, prov, child) {
      return Container(
        margin: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 8,
            right: SizeConfig.blockSizeHorizontal * 8),
        child: Form(
          key: _userNameformKey,
          child: TextFormField(
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 3.8,
                fontWeight: FontWeight.w500),
            validator: (value) {
              if (value.isEmpty) {
                return 'Username can not be empty';
              }
              if (prov.getUserNameErrorStatus == true) {
                return prov.getUserNameErrorText;
              }
              return null;
            },
            onSaved: (val) {
              onboardingUserName = val;
            },
            onChanged: (value) {
              prov.searchUserName(value);
            },
            decoration: InputDecoration(
                hintText: 'Potential connections will only see your username!',
                hintMaxLines: 1,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.6),
                )),
                hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: SizeConfig.blockSizeHorizontal * 3.3),
                labelText: 'Username(Eg: @sassyaisha, @reddevil)',
                labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: SizeConfig.blockSizeHorizontal * 4.2),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                errorText: prov.getUserNameErrorStatus == false
                    ? null
                    : prov.getUserNameErrorText,
                errorStyle:
                    TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3)),
          ),
        ),
      );
    });
  }
}

class UserFullNameEntry extends StatefulWidget {
  const UserFullNameEntry({
    Key key,
  }) : super(key: key);

  @override
  _UserFullNameEntryState createState() => _UserFullNameEntryState();
}

class _UserFullNameEntryState extends State<UserFullNameEntry> {
  var labelTextvalue = 'Hey! So your name is';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 8,
          right: SizeConfig.blockSizeHorizontal * 8),
      child: Form(
        key: _fullNameformKey,
        child: TextFormField(
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 3.8,
              fontWeight: FontWeight.w500),
          validator: (value) {
            if (value.isEmpty) {
              return 'Fullname can not be empty';
            }
            return null;
          },
          initialValue: sharedPrefs.fullname,
          onSaved: (val) => onboardingUserFullName = val,
          onTap: () {
            setState(() {
              labelTextvalue = 'My Name is';
            });
          },
          decoration: InputDecoration(
              labelText: labelTextvalue,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black.withOpacity(0.6),
              )),
              labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: SizeConfig.blockSizeHorizontal * 4.2),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hoverColor: ColorsJumpin.kPrimaryColorLite),
        ),
      ),
    );
  }
}

class UserImageUploadDisplay extends StatefulWidget {
  const UserImageUploadDisplay({
    Key key,
  }) : super(key: key);

  @override
  _UserImageUploadDisplayState createState() => _UserImageUploadDisplayState();
}

class _UserImageUploadDisplayState extends State<UserImageUploadDisplay> {
  //File _userImage;
  final picker = ImagePicker();

  // Future _uploadImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //   final File imageFile = File(pickedFile.path);
  //   setState(() {
  //     if (pickedFile != null) _userImage = File(pickedFile);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: size.width * 0.4,
              height: size.height * 0.2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black.withOpacity(0.1)),
            ),
          ),
          Positioned(
              top: 30,
              bottom: 30,
              right: 30,
              left: 30,
              child: CircleAvatar(
                backgroundImage: NetworkImage(sharedPrefs.photoUrl),
              )),
          Positioned(
              bottom: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  //_uploadImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ImageIcon(
                        AssetImage('assets/images/Onboarding/edit_icon.png'),
                        size: 25),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
