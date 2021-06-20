import 'package:JumpIn/core/utils/home_jumpin_app_bar.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/search_provider.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/arrow_for_next_page.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/list_user_cards.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/controller/people_profile_controller.dart';
import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:emoji_feedback/emoji_feedback.dart';
import 'widgets/search_bar.dart';
import 'widgets/filter_widget.dart';

JumpinUser _currentUser = JumpinUser();
LocationPermission permissionLocal;
PeopleProfileController peopleProfileController = PeopleProfileController();

class ScreenPeopleHome extends StatefulWidget {
  static List<Map<String, List<ConnectionUser>>> peopleConnections = [];
  @override
  _ScreenPeopleHomeState createState() => _ScreenPeopleHomeState();
}

class _ScreenPeopleHomeState extends State<ScreenPeopleHome> {
  ConnectionChecker cc = ConnectionChecker();
  int isShuffled = 0;
  List<JumpinUser> shuffledUsers = [];
  Stream<QuerySnapshot> _stream;
  bool _location = false;

  Future _getList;

  @override
  void initState() {
    isShuffled += 1;
    super.initState();
    cc.checkConnection(context);
    _stream = FirebaseFirestore.instance.collection("users").snapshots();
    print("inside refractor");
    _getList = Provider.of<ServiceJumpinPeopleHome>(context, listen: false)
        .getUsersList();
  }

  @override
  void dispose() {
    isShuffled = 0;
    cc.listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final homeScreenProv =
        Provider.of<ServiceJumpinPeopleHome>(context, listen: false);
    final AppBar _appBar = HomeJumpinAppBar(context, "Jumpin");
    print(
        "homeScreenProv.locationAfterEnablingPermission =============> ${homeScreenProv.locationAfterEnablingPermission}");
    return WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: _appBar,
            drawer: const JumpinNavDrawer(),
            body: Stack(children: [
              FutureBuilder(
                  future: _getList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return circularProgressIndicator();
                    }
                    return Container(
                      width: width,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Consumer<ServiceJumpinPeopleHome>(
                            builder: (context, homeProv, child) {
                          return Column(
                            children: [
                              SizedBox(
                                height: constraints.maxHeight * 0.09,
                              ),
                              Container(
                                  height: constraints.maxHeight * 0.08,
                                  width: constraints.maxWidth,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: constraints.maxHeight * 0.06),
                                  // color: Colors.black12,
                                  child: SwitchPeopleAndPlan(
                                    constraints: constraints,
                                  )),
                              if (homeProv.getSelectedList == "People")
                                Expanded(
                                  child: ListUserCards(
                                    height: constraints.maxHeight * 0.8,
                                    width: constraints.maxWidth,
                                    list: homeProv.getFiltersSelectionStatus ==
                                            false
                                        ? homeProv.jumpinUser
                                        : homeProv.getFilteredList,
                                    currentUser: _currentUser,
                                  ),
                                )
                              else
                                PlanWidget(
                                  height: height,
                                  width: width,
                                  constraints: constraints,
                                ),
                            ],
                          );
                        });
                      }),
                    );
                  }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.9,
                    child: SearchBar(height: height, width: width),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: height * 0.02, left: width * 0.01),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FilterWidget();
                            },
                          );
                        },
                        child: Icon(Icons.filter_list_rounded)),
                  )
                ],
              ),
              Consumer<ServiceJumpinPeopleHome>(
                  builder: (context, homeProv, child) {
                if (homeScreenProv.locationAfterEnablingPermission == false)
                  return Positioned(
                      bottom: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          AppSettings.openAppSettings();
                        },
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: Colors.blue[100],
                          child: Container(
                            width: width,
                            height: height * 0.07,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                CircleAvatar(
                                    child: Padding(
                                  padding: EdgeInsets.all(height * 0.01),
                                  child: Image.asset(
                                      "assets/images/Profile/location-error.png"),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.015),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: height * 0.03,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "Enable location to see distance from potential connections",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: height * 0.018),
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                else if (sharedPrefs.appOpenCount % 3 == 0 ||
                    ((DateTime.now().hour -
                            DateTime.parse(sharedPrefs.appOpenLastTime).hour) >=
                        24))
                  return Positioned(
                      bottom: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(rRateUs);
                        },
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: Colors.blue[100],
                          child: Container(
                            width: width,
                            height: height * 0.07,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                CircleAvatar(
                                    child: Padding(
                                  padding: EdgeInsets.all(height * 0.01),
                                  child: Image.asset(
                                      "assets/images/SideNav/rating.png"),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.015),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: height * 0.03,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "We would love to hear about the app. Give us your kind feedback by pressing here",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: height * 0.018),
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                else
                  return Container();
              }),
              Consumer<ServiceJumpinPeopleHome>(
                  builder: (context, homeProv, child) {
                if (homeScreenProv.getLocationLoadingStatus == true)
                  return Container(
                    width: width,
                    height: height,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        circularProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.023),
                          child: Text(
                              "Please wait while your location is being loaded",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: height * 0.023,
                                  fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                  );
                else
                  return Container();
              })
            ])));
  }
}

class PlanWidget extends StatelessWidget {
  const PlanWidget({
    Key key,
    @required this.height,
    @required this.width,
    @required this.constraints,
  }) : super(key: key);

  final double height;
  final double width;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: constraints.maxHeight * 0.8,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            "Coming very soon...",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: height * 0.023,
                fontWeight: FontWeight.w700),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.05, horizontal: width * 0.1),
            margin: EdgeInsets.symmetric(horizontal: width * 0.1),
            decoration:
                BoxDecoration(color: Colors.deepPurple[100], boxShadow: [
              BoxShadow(
                  color: Colors.deepPurple[100],
                  blurRadius: 20,
                  offset: Offset(0, 3),
                  spreadRadius: 2)
            ]),
            child: Text(
              "Join plans nearby for activities you love!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: height * 0.023,
                color: Colors.deepPurple[700],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.05, horizontal: width * 0.1),
            margin: EdgeInsets.symmetric(
                vertical: height * 0.025, horizontal: width * 0.1),
            decoration: BoxDecoration(color: Colors.cyan[200], boxShadow: [
              BoxShadow(
                  color: Colors.cyan[200],
                  blurRadius: 20,
                  offset: Offset(0, 3),
                  spreadRadius: 2)
            ]),
            child: Text(
              "Easily organise plans with friends by letting everyone vote!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: height * 0.023,
                  color: Colors.cyan[800]),
            ),
          ),
        ]));
  }
}

class SwitchPeopleAndPlan extends StatelessWidget {
  const SwitchPeopleAndPlan({this.constraints});

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final homeScreenProv = Provider.of<ServiceJumpinPeopleHome>(context);
    return Row(children: [
      GestureDetector(
        onTap: () {
          homeScreenProv.setSelectedList = "People";
        },
        child: Container(
          decoration: homeScreenProv.getSelectedList == "People"
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[900], Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                )
              : BoxDecoration(
                  border: Border.all(color: Colors.blue[900]),
                  borderRadius: BorderRadius.circular(10),
                ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: constraints.maxHeight * 0.01,
                horizontal: constraints.maxWidth * 0.04),
            child: Text("People",
                style: TextStyle(
                    color: homeScreenProv.getSelectedList == "People"
                        ? Colors.white
                        : Colors.black.withOpacity(0.7),
                    fontSize: constraints.maxHeight * 0.025,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: constraints.maxWidth * 0.04),
        child: GestureDetector(
          onTap: () {
            homeScreenProv.setSelectedList = "Plan";
          },
          child: Container(
            decoration: homeScreenProv.getSelectedList == "People"
                ? BoxDecoration(
                    border: Border.all(color: Colors.blue[900]),
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[900], Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.01,
                  horizontal: constraints.maxWidth * 0.04),
              child: Text("Plans",
                  style: TextStyle(
                      color: homeScreenProv.getSelectedList == "People"
                          ? Colors.black.withOpacity(0.7)
                          : Colors.white,
                      fontSize: constraints.maxHeight * 0.025,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    ]);
  }
}
