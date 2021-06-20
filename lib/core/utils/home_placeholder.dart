import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:JumpIn/core/network/chat_service.dart';
import 'package:JumpIn/core/network/notification_counter.dart';
import 'package:JumpIn/core/utils/home_placeholder_provider.dart';
import 'package:JumpIn/core/utils/web_view.dart';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/people_home/presentation/screen_people_home.dart';
import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:JumpIn/features/people_profile/presentation/screens/people_profile.dart';
import 'package:JumpIn/features/plans_home/presentation/plans_home.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_notifications/presentation/screens/notifications.dart';
import 'package:JumpIn/features/user_profile/presentation/screens/user_profile.dart';
import 'package:JumpIn/features/user_signup/domain/service_signup.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location/location.dart' as location;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:JumpIn/core/constants/constants.dart';

import 'message_handler.dart';
import 'route_constants.dart';
import 'sharedpref.dart';
import 'utils.dart';

class HomePlaceHolder extends StatefulWidget {
  @override
  _HomePlaceHolderState createState() => _HomePlaceHolderState();
}

class _HomePlaceHolderState extends State<HomePlaceHolder>
    with WidgetsBindingObserver {
  int _current = 0;
  Future myFuture;

  final List<Widget> _children = [
    ScreenPeopleHome(),
    ScreenJumpinNotifications(),
    ScreenUserProfile()
  ];

  final pages = [ScreenPeopleHome(), ScreenPlansHome()];

  Timer _timerLink;

  @override
  void initState() {
    NotificationCounter.getNotificationCount();
    NotificationCounter.getConnectionCount();
    NotificationCounter.getRequestCount();
    MessageHandler.configuringFirebase(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onLaunchDynamicLink();
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    myFuture = prelims();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("inside applifecycle");
      _timerLink = Timer(const Duration(milliseconds: 1000), () {
        retrieveDynamicLink();
      });
      if ((await Permission.location.isGranted ||
              await Permission.location.isLimited) &&
          (sharedPrefs.myLatitude == "0.0" &&
              sharedPrefs.myLongitude == "0.0")) {
        await determinePosition();
      }

      if ((await Permission.contacts.isGranted ||
              await Permission.contacts.isLimited) &&
          Provider.of<HomePlaceHolderProvider>(context, listen: false)
                  .contactsSyncedStatus ==
              false) {
        await determineContacts();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  void vibeCalculationAndStoreLocally() async {
    QuerySnapshot collection =
        await FirebaseFirestore.instance.collection('users').get();

    JumpinUser user;
    List<JumpinUser> peopleData = [];
    List userContacts = [];
    List<dynamic> vibeList = [];
    List peopleContactsList = [];

    collection.docs.forEach((doc) {
      if (doc.id == sharedPrefs.userid) {
        user = JumpinUser.fromDocumentForConnection(
            doc.data() as Map<String, dynamic>);
        if ((doc.data() as Map).containsKey("contacts")) {
          userContacts = doc["contacts"];
        }
      } else {
        peopleData.add(JumpinUser(
            id: doc['id'] as String,
            fullname: doc['fullname'] as String,
            gender: doc['gender'] as String,
            username: doc['username'] as String,
            dob: doc['dob'] as Timestamp,
            profession: doc['profession'] as String,
            placeOfWork: doc['placeOfWork'] as String,
            placeOfEdu: doc['placeOfEdu'] as String,
            acadCourse: doc['acadCourse'] as String,
            wtfDesc: doc['wtfDesc'] as String,
            photoUrl: doc['photoUrl'] as String,
            photoLists:
                List<String>.from(doc['photoLists'] as Iterable<dynamic>),
            email: doc['email'] as String,
            requestSentTo: doc['requestSentTo'] as List<dynamic>,
            requestReceivedFrom: doc['requestReceivedFrom'] as List<dynamic>,
            phoneNo: doc['phoneNo'] as String,
            interestList:
                List<String>.from(doc['interestList'] as Iterable<dynamic>),
            userProfileAbout: doc['userProfileAbout'] as String,
            geoPoint: doc['geoPoint'] as GeoPoint ?? const GeoPoint(0.0, 0.0),
            inJumpinFor: doc['inJumpinFor'] as String,
            myConnections: doc['myConnections'] as List<dynamic>));
        if ((doc.data() as Map).containsKey("contacts")) {
          peopleContactsList
              .add({"id": doc['id'], "contacts": doc["contacts"]});
        }
      }
    });

    peopleData.forEach((element) {
      print(element.id);
    });
    print(user.id);

    peopleData.forEach((people) {
      List usersConnections = user.myConnections
          .map((connection) =>
              ConnectionUser.fromJson(connection as Map<String, dynamic>))
          .toList();

      List peopleConnections = people.myConnections
          .map((connection) =>
              ConnectionUser.fromJson(connection as Map<String, dynamic>))
          .toList();

      List mutualFriends = [];

      usersConnections.forEach((userConnection) {
        peopleConnections.forEach((peopleConnection) {
          if (peopleConnection.id == userConnection.id) {
            mutualFriends.add(peopleConnection);
          }
        });
      });

      double distance = LocationUtils.getDistance(
          user.geoPoint.latitude, user.geoPoint.longitude);

      print(distance);

      print("\n vibe calculation for ${user.fullname}");
      Vibemeter vm = Vibemeter(
          myInterestList: user.interestList,
          peopleInterestlist: people.interestList,
          distance: distance,
          myWorkPlace: user.placeOfWork,
          peopleWorkPlace: people.placeOfWork,
          myConnectionsNo: sharedPrefs.myNoOfConnections,
          peopleConnectionsNo: peopleConnections.length,
          myAge: Utils.calculateAge(user.dob.toDate()),
          peopleAge: Utils.calculateAge(people.dob.toDate()),
          myAcadInstituition: user.placeOfEdu,
          peopleAcadInstituition: people.placeOfEdu,
          mutualConnections: mutualFriends.length);

      vibeList.add({
        "peopleId": people.id,
        "peopleVibe": vm.calculateVibe(),
      });
    });

    sharedPrefs.setVibeWithPeopleList = jsonEncode(vibeList);
    print(vibeList);

    List mutualList = [];
    peopleContactsList.forEach((element) {
      List peopleContacts = element["contacts"];
      List _mutualFriends = [];
      if (userContacts.length > 0 && peopleContacts.length > 0)
        peopleContacts.forEach((profilePhoneNos) {
          userContacts.forEach((userPhoneNos) {
            if ((profilePhoneNos["phoneNumbers"] as List).any((element) =>
                    (userPhoneNos["phoneNumbers"] as List).contains(element)) &&
                !_mutualFriends.contains(userPhoneNos["name"])) {
              _mutualFriends.add(userPhoneNos["name"]);
            }
          });
        });
      print(_mutualFriends);
      mutualList.add({"id": element["id"], "length": _mutualFriends.length});
    });
    sharedPrefs.setMutualFriends = jsonEncode(mutualList);
    print(sharedPrefs.getMutualFriends);
  }

  Future<void> onLaunchDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      String userId;
      if (queryParams.length > 0) {
        userId = queryParams['userId'];
      }
      print(userId);

      print("here");
      Navigator.pushNamed(context, rPeopleProfile,
          arguments: [userId, "shareLink"]);
    }
  }

  Future retrieveDynamicLink() async {
    print("inside dynamic");

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      final queryParams = deepLink.queryParameters;
      String userId;
      if (queryParams.length > 0) {
        userId = queryParams['userId'];
      }
      print(userId);
      if (deepLink != null) {
        print("here");
        Navigator.pushNamed(context, rPeopleProfile,
            arguments: [userId, "shareLink"]);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future determinePosition() async {
    location.Location loc = location.Location();

    final homeProv =
        Provider.of<ServiceJumpinPeopleHome>(context, listen: false);

    homeProv.setLocationLoadingStatus = true;

    bool _serviceEnabled;
    // location.PermissionStatus _permissionGranted;
    // location.LocationData _locationData;

    _serviceEnabled = await loc.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await loc.requestService();
      if (!_serviceEnabled) {
        sharedPrefs.myLatitude = "0.0";
        sharedPrefs.myLongitude = "0.0";
        await vibeCalculationAndStoreLocally();
        homeProv.locationAfterEnablingPermission = false;
        homeProv.setLocationLoadingStatus = false;
        return;
      }
    }
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.deniedForever:
        print("denier forever");
        sharedPrefs.myLatitude = "0.0";
        sharedPrefs.myLongitude = "0.0";
        homeProv.locationAfterEnablingPermission = false;
        break;
      case LocationPermission.denied:
        print("denied");
        sharedPrefs.myLatitude = "0.0";
        sharedPrefs.myLongitude = "0.0";
        homeProv.locationAfterEnablingPermission = false;
        break;
      case LocationPermission.always:
        print("always");
        homeProv.locationAfterEnablingPermission = true;
        await calDistance();
        break;
      case LocationPermission.whileInUse:
        print(LocationPermission.whileInUse);
        homeProv.locationAfterEnablingPermission = true;
        await calDistance();
        break;
      default:
        sharedPrefs.myLatitude = "0.0";
        sharedPrefs.myLongitude = "0.0";
        homeProv.locationAfterEnablingPermission = false;
        break;
    }
    print("loc cal is done");
    print(sharedPrefs.myLatitude);
    print(sharedPrefs.myLongitude);
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .update({
      "geoPoint": GeoPoint(double.parse(sharedPrefs.myLatitude),
          double.parse(sharedPrefs.myLongitude))
    });
    homeProv.setLocationLoadingStatus = false;
  }

  Future<void> calDistance() async {
    Position pos;

    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    if (pos != null) {
      sharedPrefs.myLatitude = pos.latitude.toString();
      sharedPrefs.myLongitude = pos.longitude.toString();
    } else {
      pos = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true,
      );
      if (pos != null) {
        sharedPrefs.myLatitude = pos.latitude.toString();
        sharedPrefs.myLongitude = pos.longitude.toString();
      }
    }
  }

  Future determineContacts() async {
    if (await Permission.contacts.isGranted) {
      final prov =
          Provider.of<ServicePeopleProfileController>(context, listen: false);
      prov.mutualFriendsLoadingStatus = true;

      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPrefs.userid)
          .get();

      if (!(snap.data() as Map).containsKey("contacts")) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPrefs.userid)
            .set({"contacts": []}, SetOptions(merge: true));
      }

      ContactsService.getContacts(
              withThumbnails: false, photoHighResolution: false)
          .then((contacts) {
        List contactList = [];
        print("Contacts");
        contacts.forEach((user) {
          List<String> phNumbers = [];
          user.phones.forEach((number) {
            String ph = number.value.replaceAll(" ", "");
            ph = ph.replaceAll("-", "");
            if (ph.startsWith("+91")) {
              List numb = ph.split('');
              numb.removeRange(0, 3);
              ph = numb.join();
            }
            if (ph.startsWith("91")) {
              List numb = ph.split('');
              numb.removeRange(0, 2);
              ph = numb.join();
            }
            if (!phNumbers.contains(ph) &&
                (ph.startsWith("9") ||
                    ph.startsWith("8") ||
                    ph.startsWith("7") ||
                    ph.startsWith("6"))) phNumbers.add(ph);
          });
          if (phNumbers.isNotEmpty) {
            contactList
                .add({"name": user.displayName, "phoneNumbers": phNumbers});
          }
        });
        print(contactList);
        var len = contactList.length;
        int count = 1;
        // var db = FirebaseFirestore.instance.batch();
        for (var i = 0; i < len; i += 500) {
          if (i + 500 > len) {
            List list = contactList.getRange(i, len).toList();
            print(list.length);
            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPrefs.userid)
                .update({"contacts": FieldValue.arrayUnion(list)});
            print(contactList.getRange(i, len));
          } else {
            List list = contactList.getRange(i, count * 500).toList();
            print(list.length);
            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPrefs.userid)
                .update({"contacts": FieldValue.arrayUnion(list)});
            print(contactList.getRange(i, count * 50));
          }
          print("------------------------------------");
          count += 1;
        }
      });
      prov.setContactPermStatus = true;
      prov.mutualFriendsLoadingStatus = false;
      Provider.of<HomePlaceHolderProvider>(context, listen: false)
          .contactsSyncedStatus = true;
    }
  }

  Future prelims() async {
    await [
      Permission.location,
      Permission.contacts,
    ].request();

    await determinePosition();

    await vibeCalculationAndStoreLocally();

    print("inside contacts");
    await determineContacts();

    if (await Permission.location.isGranted ||
        await Permission.location.isLimited) {
      Provider.of<ServiceJumpinPeopleHome>(context, listen: false)
          .locationAfterEnablingPermission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homePlaceHolderProv = Provider.of<HomePlaceHolderProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const JumpinNavDrawer(),
      body: FutureBuilder(
          future: myFuture,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  circularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.023),
                    child: Text("Please wait for a while...",
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: size.height * 0.023,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              );
            }
            return _children[homePlaceHolderProv.getCurrentIndex];
          }),
      bottomNavigationBar: SizedBox(
        height: size.height * 0.08,
        child: BottomNavigationBar(
          currentIndex: homePlaceHolderProv.getCurrentIndex,
          backgroundColor: ColorsJumpin.kPrimaryColorLite,
          unselectedItemColor: ColorsJumpin.kSecondaryColor,
          selectedItemColor: ColorsJumpin.kPrimaryColor,
          type: BottomNavigationBarType.shifting,
          selectedLabelStyle: TextStyle(
              fontSize: size.height * 0.017, fontWeight: FontWeight.w600),
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                  AssetImage('assets/images/Onboarding/logo_final.png'),
                  size: size.height * 0.024),
              label: 'JumpIn',
            ),
            BottomNavigationBarItem(
                icon: sharedPrefs.myPendingNotification != null &&
                        sharedPrefs.myPendingNotification > 0
                    ? Badge(
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          "${sharedPrefs.myPendingNotification}",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.015),
                        ),
                        badgeColor: ColorsJumpin.kPrimaryColor,
                        child:
                            Icon(Icons.notifications, size: size.height * 0.03))
                    : Icon(Icons.notifications, size: size.height * 0.03),
                label: 'Notification'),
            BottomNavigationBarItem(
              icon: Icon(Icons.face_sharp, size: size.height * 0.03),
              label: 'User',
            )
          ],
          onTap: (index) {
            homePlaceHolderProv.setCurrentIndex = index;
          },
        ),
      ),
    );
  }
}

class JumpinNavDrawer extends StatelessWidget {
  const JumpinNavDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: NavDrawerChildren(
          myConnectionNo: sharedPrefs.myNoOfConnections,
          myPlansNo: 0,
          myPeopleReqNo: sharedPrefs.myNoOfConnectionRequests,
          myPlanInvitesNo: 0,
          myRecommendationNo: 0),
    );
  }
}

class NavDrawerChildren extends StatelessWidget {
  const NavDrawerChildren({
    Key key,
    this.myConnectionNo,
    this.myPlansNo,
    this.myPeopleReqNo,
    this.myPlanInvitesNo,
    this.myRecommendationNo,
  }) : super(key: key);

  final int myConnectionNo;
  final int myPlansNo;
  final int myPeopleReqNo;
  final int myPlanInvitesNo;
  final int myRecommendationNo;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeaderWidget(),
        ListTile(
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6,
            height: SizeConfig.blockSizeHorizontal * 6,
            child: Image.asset("assets/images/SideNav/link.png"),
          ),
          // leading: Icon(Icons.link,
          //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
          title: Text(
            'Link Accounts',
            textScaleFactor: 1,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
                fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.pushNamed(context, rLinkingAccounts);
          },
        ),
        ListTile(
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6,
            height: SizeConfig.blockSizeHorizontal * 6,
            child: Image.asset("assets/images/SideNav/placeholder.png"),
          ),
          // leading: ImageIcon(
          //     const AssetImage('assets/images/Home/location_icon.png'),
          //     color: Colors.blue,
          //     size: SizeConfig.blockSizeHorizontal * 7),
          title: Text(
            'Location',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.55,
            ),
          ),
          onTap: () {
            print("Location pressed");
            Navigator.pushNamed(context, rMyLocation);
          },
        ),
        ListTile(
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6.5,
            height: SizeConfig.blockSizeHorizontal * 6.5,
            child: Image.asset("assets/images/SideNav/connection.png"),
          ),
          title: Text(
            'My Connections ($myConnectionNo)',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.55,
            ),
          ),
          onTap: () {
            print("Connection pressed");
            Navigator.pushNamed(context, rMyConnections);
          },
        ),
        ListTile(
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6,
            height: SizeConfig.blockSizeHorizontal * 6,
            child: Image.asset("assets/images/SideNav/plan.png"),
          ),
          // leading: Icon(Icons.local_activity,
          //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
          title: Text(
            'My Plans ($myPlansNo)',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.55,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, rMyPlans);
          },
        ),
        ListTile(
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6,
            height: SizeConfig.blockSizeHorizontal * 6,
            child: Image.asset("assets/images/SideNav/request.png"),
          ),
          // leading: Icon(
          //   Icons.person_add_rounded,
          //   color: Colors.blue,
          //   size: SizeConfig.blockSizeHorizontal * 7,
          // ),
          title: Text(
            sharedPrefs.myNoOfConnectionRequests == null
                ? 'People Requests(0)'
                : 'People Requests(${myPeopleReqNo})',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.55,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, rMyPeopleReq);
          },
        ),
        ListTile(
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6,
            height: SizeConfig.blockSizeHorizontal * 6,
            child: Image.asset("assets/images/SideNav/plan-invite.png"),
          ),
          // leading: Icon(Icons.mail,
          //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
          title: Text(
            'Plan Invites',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.55,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, rMyPlanInvites);
          },
        ),
        // ListTile(
        //     leading: Container(
        //       width: SizeConfig.blockSizeHorizontal * 6,
        //       height: SizeConfig.blockSizeHorizontal * 6,
        //       child: Image.asset("assets/images/SideNav/recommend.png"),
        //     ),
        //     // leading: Icon(Icons.recommend,
        //     //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
        //     title: Text(
        //       'Recommendations',
        //       style: TextStyle(
        //         fontSize: SizeConfig.blockSizeVertical * 2.55,
        //       ),
        //     ),
        //     trailing: RichText(text: TextSpan(text: '($myRecommendationNo)'))),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, rMyBookmarks);
          },
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6,
            height: SizeConfig.blockSizeHorizontal * 6,
            child: Image.asset("assets/images/SideNav/bookmark.png"),
          ),
          // leading: Icon(Icons.bookmark,
          //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
          title: Text(
            'Bookmarks',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.55,
            ),
          ),
        ),
        ListTile(
            onTap: () {
              urlFileShare(context);
            },
            // leading: Icon(Icons.send_and_archive,
            //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 5.5,
              height: SizeConfig.blockSizeHorizontal * 5.5,
              margin:
                  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 0.5),
              child: Image.asset("assets/images/SideNav/suggest.png"),
            ),
            title: Text(
              'Suggest Jumpin',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            )),
        ListTile(
          // leading: Icon(Icons.settings,
          //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 6,
            height: SizeConfig.blockSizeHorizontal * 6,
            child: Image.asset("assets/images/SideNav/settings.png"),
          ),
          title: Text('Settings',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              )),
          onTap: () {
            Navigator.pushNamed(context, rSettings);
          },
        ),
        ListTile(
          leading: Container(
            width: SizeConfig.blockSizeHorizontal * 5.5,
            height: SizeConfig.blockSizeHorizontal * 5.5,
            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
            child: Image.asset("assets/images/SideNav/log-out.png"),
          ),
          // leading: Icon(Icons.logout,
          //     color: Colors.blue, size: SizeConfig.blockSizeHorizontal * 7),
          title: Text(
            'Log Out',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.55,
            ),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text(
                        "Are you sure you want to log out?",
                        textScaleFactor: 1,
                      ),
                      actions: [
                        RaisedButton(
                            onPressed: () async {
                              signOutGoogle(context).then((value) {
                                print(value);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    rSplash, (Route<dynamic> route) => false);
                              });
                            },
                            child: const Text(
                              'Yes',
                              textScaleFactor: 1,
                            )),
                        RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'No',
                              textScaleFactor: 1,
                            ))
                      ],
                    ));
          },
        ),
        const Divider(color: Colors.black26),
        ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 5.5,
              height: SizeConfig.blockSizeHorizontal * 5.5,
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
              child: Image.asset("assets/images/SideNav/rating.png"),
            ),
            title: Text(
              'Rate Us',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(rRateUs);
            }),
        ListTile(
            leading: Container(
              width: SizeConfig.blockSizeHorizontal * 5.5,
              height: SizeConfig.blockSizeHorizontal * 5.5,
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
              child: Image.asset("assets/images/SideNav/information.png"),
            ),
            title: Text(
              'About Jumpin',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical * 2.55,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      WebView("https://www.jumpin.co.in/", "About JumpIn")));
            }),
      ],
    );
  }

  Future<Null> urlFileShare(BuildContext context) async {
    if (Platform.isAndroid) {
      var url =
          'https://drive.google.com/file/d/1WOmwr-OFEJNc1iiUc-C55MnnpBXvJkeh/view?usp=sharing';
      var response = await get(Uri.parse(url));
      final documentDirectory = (await getExternalStorageDirectory()).path;
      File imgFile = new File('$documentDirectory/jumpin-logo.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      Share.shareFiles(['$documentDirectory/jumpin-logo.png'],
          subject: 'Share JumpIn',
          text:
              "I'm enjoying my time at JUMPIN and want you to join the party. Use the link https://play.google.com/store/apps/details?id=com.antizero.JumpIn to download JUMPIN - the app that discovers interest-twins near you.");
      //sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share(
        'Hello, check your share files!',
        subject: 'URL File Share',
      );
      //sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, rUserProfile);
        },
        child: Container(
            height: size.height * 0.35,
            // color: Colors.black12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(2000)),
                        depth: 10,
                        surfaceIntensity: 0.1,
                        lightSource: LightSource.top,
                        intensity: 1,
                      ),
                      child: Container(
                        width: size.height * 0.14,
                        height: size.height * 0.14,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2000),
                            gradient: LinearGradient(
                                colors: [Colors.blue[200], Colors.blue[400]],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                      ),
                    ),
                    Positioned(
                      left: size.height * 0.01,
                      top: size.height * 0.01,
                      child: Container(
                        width: size.height * 0.12,
                        height: size.height * 0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2000),
                            image: DecorationImage(
                                image: NetworkImage(sharedPrefs.photoUrl),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Hello!",
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            color: Colors.black.withOpacity(0.7))),
                    Text(sharedPrefs.fullname,
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size.height * 0.035,
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const Divider(color: Colors.black26)

                // CircleAvatar(
                //     radius: size.height * 0.08,
                //     backgroundColor: ColorsJumpin.interestCategorySelectedColor,
                //     child: CircleAvatar(
                //         radius: size.height * 0.07,
                //         backgroundImage: NetworkImage(sharedPrefs.photoUrl))),
              ],
            )),
      ),
    );
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, rUserProfile);
      }, //redirect to user's profile},
      child: Column(
        children: [
          CircleAvatar(
              radius: 45,
              backgroundColor: ColorsJumpin.interestCategorySelectedColor,
              child: CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(sharedPrefs.photoUrl))),
          Container(
            margin: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                sharedPrefs.fullname,
                style: TextStyle(
                    fontFamily: font1,
                    fontSize: SizeConfig.blockSizeVertical * 2.2,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
