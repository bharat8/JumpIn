import 'package:JumpIn/core/utils/home_jumpin_app_bar.dart';
import 'package:JumpIn/features/people_home/presentation/screen_people_home.dart';
import 'package:JumpIn/features/plans_home/presentation/fab_create_plan.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/arrow_for_people_page.dart';
import 'package:JumpIn/features/plans_home/presentation/widgets/list_plans_cards.dart';
import 'package:JumpIn/features/user_notifications/presentation/screens/notifications.dart';
import 'package:JumpIn/features/user_profile/presentation/screens/user_profile.dart';
import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenPlansHome extends StatefulWidget {
  @override
  _ScreenPlansHomeState createState() => _ScreenPlansHomeState();
}

class _ScreenPlansHomeState extends State<ScreenPlansHome> {
  double opacity = 1.0;
  int _current = 0;
  final List<Widget> _children = [
    ScreenPeopleHome(),
    ScreenJumpinNotifications(),
    ScreenUserProfile()
  ];

  @override
  void initState() {
    super.initState();
    changeOpacity();
  }

  changeOpacity() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
        changeOpacity();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: HomeJumpinAppBar(context, 'JUMPIN'),
        drawer: const JumpinNavDrawer(),
        body: Center(
          child: Column(
            children: [
              // SizedBox(height: mediaQueryData.size.height * 0.05),
              // Expanded(
              //     flex: 48,
              //     child: ListPlansCards(height: height, width: width)),
              const ArrowForPeoplePage(),
              // const Spacer(),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    child: Stack(children: <Widget>[
                  AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(seconds: 1),
                    child: Text(''),
                  ),
                  AnimatedOpacity(
                    opacity: opacity == 1 ? 0 : 1,
                    duration: Duration(seconds: 1),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30, right: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Create a plan',
                              style:
                                  (TextStyle(fontFamily: font1, fontSize: 20))),
                          const Icon(Icons.arrow_forward_sharp, size: 20),
                        ],
                      ),
                    ),
                  ),
                ])),
              )
            ],
          ),
        ),
        floatingActionButton: FancyFab(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current,
          backgroundColor: ColorsJumpin.kPrimaryColorLite,
          unselectedItemColor: ColorsJumpin.kSecondaryColor,
          selectedItemColor: ColorsJumpin.kPrimaryColor,
          type: BottomNavigationBarType.shifting,
          items: [
            const BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage('assets/images/Onboarding/logo_final.png'),
                    size: 20),
                label: 'Jumpin'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notification'),
            const BottomNavigationBarItem(
              icon: Icon(Icons.face_sharp),
              label: 'User',
            )
          ],
          onTap: (index) {
            print(_current);
            setState(() {
              _current = index;
            });
          },
        ));
  }
}

// class ExplorePlansNearby extends StatelessWidget {
//   const ExplorePlansNearby({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           color: ColorsJumpin.kSecondaryColor),
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text("Explore Plans Nearby",
//               style: TextStyle(
//                   fontSize: 20, fontFamily: font1, color: Colors.white)),
//         )
//       ]),
//     );
//   }
// }

// class SearchPeople extends StatelessWidget {
//   const SearchPeople({
//     Key key,
//     @required this.width,
//   }) : super(key: key);

//   final double width;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SizedBox(
//         height: size.height * 0.046,
//         width: width,
//         child: Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 5),
//                 child: Icon(Icons.search),
//               ),
//               SizedBox(
//                 width: width * 0.7,
//                 child: TextField(
//                     decoration: InputDecoration(
//                         hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
//                         hintText: 'Search for Plans(e.g sports,concerts)')),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Icon(Icons.filter_list_outlined),
//               )
//             ],
//           ),
//         ));
//   }
// }

// class ScreenPlansHome extends StatefulWidget {
//   @override
//   _ScreenPlansHomeState createState() => _ScreenPlansHomeState();
// }

// class _ScreenPlansHomeState extends State<ScreenPlansHome> {
//   bool thumbsUpSelected = false;
//   bool thumbsDownSelected = false;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   void _displaySnackBar(BuildContext context, String title, Color color) {
//     final snackBar = SnackBar(
//       content: Text(title),
//       duration: const Duration(seconds: 1),
//       backgroundColor: color,
//     );
//     _scaffoldKey.currentState.showSnackBar(snackBar);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQueryData = MediaQuery.of(context);
//     if (mediaQueryData.orientation == Orientation.landscape) {
//       return HandleLandscapeChange();
//     }

//     return Scaffold(
//         key: _scaffoldKey,
//         resizeToAvoidBottomInset: false,
//         resizeToAvoidBottomPadding: false,
//         appBar: JumpinAppBar(context, 'Jumpin'),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: getScreenSize(context).height * 0.15,
//                 child: Center(
//                   child: Text(
//                     'JUMPIN with Plans',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: ColorsJumpin.kPrimaryColor,
//                         fontFamily: font2,
//                         fontSize: 30),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: getScreenSize(context).height * 0.1,
//                 child: Center(
//                   child: Text(
//                     'Coming Very Soon...',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontFamily: font2,
//                         fontSize: 20,
//                         fontStyle: FontStyle.italic),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(10),
//                 height: getScreenSize(context).height * 0.2,
//                 color: const Color(0xffCBDDFD),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       'Join plans nearby for \n activities you love!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: font1,
//                           fontSize: 20,
//                           color: const Color(0xff6f7dc4)),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(10),
//                 height: getScreenSize(context).height * 0.2,
//                 color: const Color(0xffcdf2fb),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       'Easily organize plans with friends \n by letting everyone vote!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: font1,
//                           fontSize: 20,
//                           color: const Color(0xff30a6c4)),
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           thumbsUpSelected = !thumbsUpSelected;
//                           if (thumbsUpSelected) {
//                             thumbsDownSelected = false;
//                             _displaySnackBar(context, "Thank You For Voting",
//                                 Colors.lightGreen);
//                           }
//                         });
//                       },
//                       child: thumbsUpSelected
//                           ? const Icon(Icons.thumb_up_rounded,
//                               color: Colors.green, size: 50)
//                           : const Icon(Icons.thumb_up_outlined, size: 50)),
//                   GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           thumbsDownSelected = !thumbsDownSelected;
//                           if (thumbsDownSelected) {
//                             thumbsUpSelected = false;

//                             _displaySnackBar(context, "Thank You For Voting",
//                                 Colors.redAccent);
//                           }
//                         });
//                       },
//                       child: thumbsDownSelected
//                           ? Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: const Icon(Icons.thumb_down_rounded,
//                                   color: Colors.red, size: 50),
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: const Icon(Icons.thumb_down_outlined,
//                                   size: 50),
//                             )),
//                 ],
//               )
//             ],
//           ),
//         ));
// //         drawer: const JumpinNavDrawer(),;
//   }
// }
