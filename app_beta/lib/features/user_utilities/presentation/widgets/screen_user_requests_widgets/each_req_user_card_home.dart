import 'package:JumpIn/core/network/service_people_profile.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_profile/presentation/screens/people_profile.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/features/user_utilities/domain/service_requests.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EachReqUserCardHome extends StatefulWidget {
  const EachReqUserCardHome(
      {Key key,
      @required this.user,
      @required this.mutualConnections,
      @required this.mutualInterests})
      : super(key: key);

  final JumpinUser user;
  final List<String> mutualInterests;
  final List<ConnectionUser> mutualConnections;

  @override
  _EachReqUserCardHomeState createState() => _EachReqUserCardHomeState();
}

class _EachReqUserCardHomeState extends State<EachReqUserCardHome> {
  final ServiceRequests requestsController = ServiceRequests();

  @override
  void initState() {
    requestsController.doSomeRoundUps(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              flex: 6,
              child: Container(
                margin:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                child: Column(
                  children: [
                    //username
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('@${widget.user.username}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: font2,
                              fontWeight: FontWeight.bold,
                              color: ColorsJumpin.kPrimaryColor,
                              fontSize: SizeConfig.blockSizeHorizontal * 4)),
                    ),
                    //location
                    Row(
                      children: [
                        ImageIcon(
                            const AssetImage(
                                'assets/images/Home/location_icon.png'),
                            size: SizeConfig.blockSizeHorizontal * 5),
                        requestsController.distance != null
                            ? Text("${requestsController.distance} km",
                                style: TextStyle(
                                    fontFamily: font2,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold))
                            : Text("N/A",
                                style: TextStyle(
                                    fontFamily: font2,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //vibe meter
            Expanded(
                flex: 4,
                child: FutureBuilder(
                    future: calculateVibeForPeople(widget.user.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return circularProgressIndicator();
                      }
                      double vibemeterValue = snapshot.data as double;
                      return Row(
                        children: [
                          CircularPercentIndicator(
                              radius: SizeConfig.blockSizeHorizontal * 13,
                              lineWidth: 8.0,
                              percent: vibemeterValue / 100,
                              center: Text(
                                  vibemeterValue.toInt().toString() + "%",
                                  style: TextStyle(
                                      fontSize: SizeConfig.blockSizeHorizontal *
                                          3.6)),
                              backgroundColor: Colors.transparent,
                              linearGradient: LinearGradient(
                                  colors: [Colors.black, Colors.green])),
                          Column(
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    " Vibe",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 4,
                                        color: Colors.green),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Matched",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  2,
                                          color: Colors.lightGreen),
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      );
                    }))
          ]),
          Container(
            margin: const EdgeInsets.only(top: 3),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("Tap To Know More",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3))),
          ),
          GestureDetector(
            onTap: () {
              String userid = widget.user.id;
              Navigator.pushNamed(context, rPeopleProfile,
                  arguments: [userid, "connectionRequest"]);
            },
            child: Container(
              height: getScreenSize(context).height * 0.39,
              width: getScreenSize(context).width * 0.72,
              decoration: BoxDecoration(
                  color: ColorsJumpin.innerCardBackgroundGrey,
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: getScreenSize(context).height * 0.34,
                width: getScreenSize(context).width * 0.7,
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 5),
                decoration: BoxDecoration(
                    color: ColorsJumpin.innerCardBackgroundGrey,
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(6, 2),
                                blurRadius: 10,
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          height: getScreenSize(context).height * 0.15,
                          width: getScreenSize(context).width * 0.26,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              shadowColor: Colors.black,
                              elevation: 2.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.black26),
                                    borderRadius: BorderRadius.circular(10)),
                                child:
                                    //age and gender -> top left

                                    Container(
                                  padding: const EdgeInsets.all(3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                    Utils.calculateAge(widget
                                                                .user.dob
                                                                .toDate())
                                                            .toString() +
                                                        " Years",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            font2semibold,
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            3,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                )),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                    widget.user.gender
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            font2semibold,
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            3,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      //gendericon
                                      Expanded(
                                        flex: 5,
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: ImageIcon(
                                              widget.user.gender == 'female'
                                                  ? AssetImage(
                                                      'assets/images/Home/female_black.png')
                                                  : AssetImage(
                                                      'assets/images/Home/male_blue.png'),
                                              size: SizeConfig
                                                      .blockSizeHorizontal *
                                                  9,
                                              color: Colors.black,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //top right -> work/study
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(6, 2),
                                  blurRadius: 10,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                            height: getScreenSize(context).height * 0.15,
                            width: getScreenSize(context).width * 0.26,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                shadowColor: Colors.black,
                                elevation: 2.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.black26),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: AutoSizeText(
                                              requestsController
                                                  .decideStudyWork(
                                                      widget.user.placeOfWork,
                                                      widget.user.placeOfEdu),
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      3,
                                                  fontFamily: font2semibold,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: ImageIcon(
                                                  widget.user.placeOfWork
                                                          .isEmpty
                                                      ? AssetImage(
                                                          'assets/images/Home/college.png')
                                                      : AssetImage(
                                                          'assets/images/Home/work.png'),
                                                  size: SizeConfig
                                                          .blockSizeHorizontal *
                                                      9)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                    //bottom right interest list
                    Positioned(
                      right: 0,
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(6, 2),
                                blurRadius: 10,
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          height: getScreenSize(context).height * 0.15,
                          width: getScreenSize(context).width * 0.26,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              shadowColor: Colors.black,
                              elevation: 2.0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.black26),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: ImageIcon(
                                              const AssetImage(
                                                  'assets/images/Home/interest_home.png'),
                                              size: SizeConfig
                                                      .blockSizeHorizontal *
                                                  9)),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                              widget.user.interestList[0]
                                                      .toString() +
                                                  ',' +
                                                  widget.user.interestList[1]
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      2.5,
                                                  fontFamily: font2semibold,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //bottom left -> mutual friend
                    Positioned(
                        bottom: 20,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(6, 2),
                                  blurRadius: 10,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                            height: getScreenSize(context).height * 0.15,
                            width: getScreenSize(context).width * 0.26,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                shadowColor: Colors.black,
                                elevation: 2.0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.black26),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: ImageIcon(
                                              AssetImage(
                                                  'assets/images/Home/mutual_friend.png'),
                                              size: SizeConfig
                                                      .blockSizeHorizontal *
                                                  9),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: AutoSizeText(
                                            '${widget.mutualConnections.length} Mutual Friends',
                                            style: TextStyle(
                                                fontFamily: font2semibold,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    3,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                    // center image
                    Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: getScreenSize(context).height * 0.08,
                                backgroundImage: AssetImage(
                                    'assets/images/Home/people_background_blue_shades.png'),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: getScreenSize(context).height * 0.058,
                                backgroundImage:
                                    NetworkImage(widget.user.photoUrl),
                              ),
                            ),
                          ],
                        )),
                    // requestReceived == false
                    //     ? Container()
                    //     //  Align(
                    //     //     alignment: Alignment.bottomCenter,
                    //     //     child: Text("Double Tap To Jumpin",
                    //     //         style: TextStyle(
                    //     //             fontSize:
                    //     //                 SizeConfig.blockSizeHorizontal * 2.4)))
                    //     : Align(
                    //         alignment: Alignment.bottomCenter,
                    //         child: Text(
                    //             "Double Tap To Accept | Longpress To Reject",
                    //             style: TextStyle(
                    //                 fontSize:
                    //                     SizeConfig.blockSizeHorizontal * 2.4)))
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                  heroTag: null,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.green,
                  mini: true,
                  //highlightElevation: 50.0,
                  onPressed: () {
                    //storing "a request is sent to X user" in the current user's database
                    Navigator.pushNamed(context, rNotification);
                    //acceptJumpinRequest(user, context);
                    // updateReceiverDatabase(user.id);
                  },
                  child: Icon(Icons.check,
                      color: Colors.white,
                      size: SizeConfig.blockSizeHorizontal * 4)),
              FloatingActionButton(
                  heroTag: null,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.red,
                  mini: true,
                  onPressed: () {
                    //storing "a request is sent to X user" in the current user's database
                    Navigator.pushNamed(context, rNotification);
                    //rejectJumpinRequest(user, context);
                    // updateReceiverDatabase(user.id);
                  },
                  child: const Center(
                      child: Text('X', style: TextStyle(color: Colors.white))))
            ],
          )
        ],
      ),
    );
  }
}
