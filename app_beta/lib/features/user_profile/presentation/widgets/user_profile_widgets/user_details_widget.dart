import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/user_profile/domain/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserDetailsWidget extends StatefulWidget {
  const UserDetailsWidget({
    Key key,
    @required this.size,
    @required this.profileController,
  }) : super(key: key);

  final Size size;
  final UserProfileController profileController;

  @override
  _UserDetailsWidgetState createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget>
    with WidgetsBindingObserver {
  int age;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (DateTime.now().month -
            widget.profileController.currentUserProfileUser.dob.toDate().month >
        0) {
      age = DateTime.now().year -
          widget.profileController.currentUserProfileUser.dob.toDate().year;
    } else if (DateTime.now().month -
            widget.profileController.currentUserProfileUser.dob.toDate().month <
        0) {
      age = (DateTime.now().year -
              widget.profileController.currentUserProfileUser.dob
                  .toDate()
                  .year) -
          1;
    } else {
      if (DateTime.now().day -
              widget.profileController.currentUserProfileUser.dob
                  .toDate()
                  .day >=
          0) {
        age = DateTime.now().year -
            widget.profileController.currentUserProfileUser.dob.toDate().year;
      } else {
        age = (DateTime.now().year -
                widget.profileController.currentUserProfileUser.dob
                    .toDate()
                    .year) -
            1;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.size.width * 0.04,
          vertical: widget.size.height * 0.025),
      child: Container(
        width: widget.size.width,
        child: Row(
          children: [
            Container(
              width: widget.size.width * 0.458,
              // color: Colors.black12,
              child: sharedPrefs.savedLocationCity != null
                  ? Column(
                      children: [
                        Container(
                          width: widget.size.width * 0.06,
                          height: widget.size.height * 0.06,
                          child: Image.asset(
                              "assets/images/SideNav/placeholder.png"),
                        ),
                        Text(sharedPrefs.savedLocationCity,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: widget.size.height * 0.02,
                                fontWeight: FontWeight.w500)),
                      ],
                    )
                  : widget.profileController.getUserLocation == null
                      ? FutureBuilder<String>(
                          future: widget.profileController.determinePosition(),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SpinKitCircle(
                                color: Colors.blue,
                              );
                            }
                            if (!snapshot.hasError) {
                              print(snapshot.error);
                            }
                            print(widget.profileController.getUserLocation);
                            return snapshot.data != null
                                ? Column(
                                    children: [
                                      Container(
                                        width: widget.size.width * 0.06,
                                        height: widget.size.height * 0.06,
                                        child: Image.asset(
                                            "assets/images/SideNav/placeholder.png"),
                                      ),
                                      Text(snapshot.data,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize:
                                                  widget.size.height * 0.02,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      widget.profileController
                                          .calDistanceAfterReject(context)
                                          .then((_) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      width: widget.size.width * 0.06,
                                      height: widget.size.height * 0.06,
                                      child: Image.asset(
                                          "assets/images/Profile/location-error.png"),
                                    ),
                                  );
                          },
                        )
                      : Column(
                          children: [
                            Container(
                              width: widget.size.width * 0.06,
                              height: widget.size.height * 0.06,
                              child: Image.asset(
                                  "assets/images/SideNav/placeholder.png"),
                            ),
                            Text(widget.profileController.getUserLocation,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: widget.size.height * 0.02,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
            ),
            Container(
              height: widget.size.height * 0.08,
              child: VerticalDivider(
                color: Colors.black12,
                thickness: widget.size.width * 0.004,
                width: widget.size.width * 0.004,
              ),
            ),
            Container(
              width: widget.size.width * 0.458,
              // color: Colors.black26,
              child: Column(
                children: [
                  Container(
                    width: widget.size.width * 0.06,
                    height: widget.size.height * 0.06,
                    child: Image.asset("assets/images/Profile/age.png"),
                  ),
                  Text(age.toString(),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: widget.size.height * 0.02,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
