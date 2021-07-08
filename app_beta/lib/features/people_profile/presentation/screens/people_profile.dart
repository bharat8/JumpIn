import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:JumpIn/features/people_profile/presentation/widgets/fab_send_jumpin_widget.dart';
import 'package:JumpIn/features/people_profile/presentation/widgets/swiper_widget.dart';
import 'package:JumpIn/features/people_profile/presentation/widgets/vibe_meter_people.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:provider/provider.dart';

import '../widgets/i_am_on_jumpin_for_widget.dart';
import '../widgets/people_about_widget.dart';
import '../widgets/people_details_widget.dart';
import '../widgets/people_edu_and_job_widget.dart';
import '../widgets/people_interests_list_widget.dart';
import '../widgets/mutual_people_less.dart';
import '../widgets/academic_widget.dart';
import '../widgets/jumpin_appbar.dart';

class ScreenPeopleProfile extends StatefulWidget {
  const ScreenPeopleProfile(
      {Key key, @required this.userid, @required this.source})
      : super(key: key);

  final String userid;
  final String source;

  @override
  _ScreenPeopleProfileState createState() => _ScreenPeopleProfileState();
}

class _ScreenPeopleProfileState extends State<ScreenPeopleProfile> {
  ConnectionChecker cc = ConnectionChecker();

  @override
  void initState() {
    cc.checkConnection(context);
    super.initState();
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final prov =
        Provider.of<ServicePeopleProfileController>(context, listen: false);
    return Scaffold(
      appBar: JumpinAppBar(context, 'JumpIn'),
      bottomNavigationBar: FABSendJumpin(source: widget.source),
      body: WillPopScope(
        onWillPop: () async {
          final prov = Provider.of<ServicePeopleProfileController>(context,
              listen: false);
          prov.clearData();
          Navigator.pop(context);
          return true;
        },
        child: FutureBuilder<bool>(
            future: prov.getUserDetails(context, widget.userid),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return circularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Center(
                    child: Text("Error loading! Try again later"));
              }
              return SingleChildScrollView(
                child: prov.getLoadingStatus == false
                    ? Column(
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
                                            child: imageSlider(
                                                context, prov.getImageURLs)),
                                        if (widget.userid != sharedPrefs.userid)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: VibeMeterPeople(
                                                    userid: widget.userid)),
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
                                          prov.user.myConnections.length
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
                          if (widget.source != "connection")
                            Padding(
                              padding: EdgeInsets.only(top: size.height * 0.01),
                              child: Text(
                                  prov.user.username.startsWith("@")
                                      ? prov.user.username
                                      : "@${prov.user.username}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: size.height * 0.030,
                                      fontWeight: FontWeight.w700)),
                            )
                          else
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.01),
                                  child: Text(
                                      prov.user.username.startsWith("@")
                                          ? prov.user.username
                                          : "@${prov.user.username}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: size.height * 0.025,
                                          fontWeight: FontWeight.w800)),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.005),
                                  child: Text(prov.user.fullname,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: size.height * 0.035,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.005),
                            child: Text(
                                prov.user.profession.length == 0
                                    ? "Jumpin User"
                                    : prov.user.profession,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w700)),
                          ),
                          PeopleDetailsWidget(
                              size: size, profileController: prov),
                          EduNJobWidget(size: size, profileController: prov),
                          AcademicWidget(size: size, profileController: prov),
                          MutualPeopleLess(size: size),
                          InterestsListWidget(
                            size: size,
                            interestsList: prov.mutualInterests,
                            interestsListName: "Mutual Interests",
                          ),
                          InterestsListWidget(
                            size: size,
                            interestsList: prov.interestsList,
                            interestsListName: "Other Interests",
                          ),
                          PeopleAboutWidget(
                              size: size, profileController: prov),
                          IAmOnJumpinFor(size: size, profileController: prov),
                        ],
                      )
                    : Center(
                        child: circularProgressIndicator(),
                      ),
              );
            }),
      ),
    );
  }
}
