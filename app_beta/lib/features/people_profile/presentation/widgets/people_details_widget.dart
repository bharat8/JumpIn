import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_stack/image_stack.dart';

class PeopleDetailsWidget extends StatefulWidget {
  const PeopleDetailsWidget({
    Key key,
    @required this.size,
    @required this.profileController,
  }) : super(key: key);

  final Size size;
  final ServicePeopleProfileController profileController;

  @override
  _PeopleDetailsWidgetState createState() => _PeopleDetailsWidgetState();
}

class _PeopleDetailsWidgetState extends State<PeopleDetailsWidget> {
  List<String> mutualFriendsImages = [];
  int age;
  @override
  void initState() {
    super.initState();
    (widget.profileController.user.myConnections).forEach((connection) {
      // print(connection);
      ConnectionUser cu =
          ConnectionUser.fromJson(connection as Map<String, dynamic>);
      mutualFriendsImages.add(cu.avatarImageUrl);
    });

    if (DateTime.now().month -
            widget.profileController.user.dob.toDate().month >
        0) {
      age =
          DateTime.now().year - widget.profileController.user.dob.toDate().year;
    } else if (DateTime.now().month -
            widget.profileController.user.dob.toDate().month <
        0) {
      age = (DateTime.now().year -
              widget.profileController.user.dob.toDate().year) -
          1;
    } else {
      if (DateTime.now().day - widget.profileController.user.dob.toDate().day >=
          0) {
        age = DateTime.now().year -
            widget.profileController.user.dob.toDate().year;
      } else {
        age = (DateTime.now().year -
                widget.profileController.user.dob.toDate().year) -
            1;
      }
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
              child: Column(
                children: [
                  Container(
                    width: widget.size.width * 0.06,
                    height: widget.size.height * 0.06,
                    child: Image.asset("assets/images/SideNav/placeholder.png"),
                  ),
                  if (widget.profileController.getUserLocation == null)
                    FutureBuilder<String>(
                      future: widget.profileController.determinePosition(),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SpinKitCircle(
                            color: Colors.blue,
                          );
                        }
                        if (!snapshot.hasData) {
                          return SpinKitCircle(
                            color: Colors.blue,
                          );
                        }
                        return Text(widget.profileController.getUserLocation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: widget.size.height * 0.02,
                                fontWeight: FontWeight.w500));
                      },
                    )
                  else
                    Text(widget.profileController.getUserLocation,
                        textAlign: TextAlign.center,
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
