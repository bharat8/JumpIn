//firestore
import 'dart:async';
import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

CollectionReference userRefFS = FirebaseFirestore.instance.collection('users');
//get document using ID
Future<bool> checkDocExists(String documentId) async {
  final DocumentSnapshot doc = await userRefFS.doc(documentId).get();
  // ignore: prefer_typing_uninitialized_variables
  var exist = false;
  if (doc.exists) {
    exist = true;
  }
  return exist;
}

class Utils {
  static StreamTransformer transformer<T>(
          T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
          final snaps = data.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          final users = snaps.map((json) => fromJson(json)).toList();

          sink.add(users);
        },
      );

  static DateTime toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static int calculateAge(DateTime dob) {
    if (DateTime.now().month - dob.month > 0) {
      return DateTime.now().year - dob.year;
    } else if (DateTime.now().month - dob.month < 0) {
      return (DateTime.now().year - dob.year) - 1;
    } else {
      if (DateTime.now().day - dob.day >= 0) {
        return DateTime.now().year - dob.year;
      } else {
        return (DateTime.now().year - dob.year) - 1;
      }
    }
  }

  static String calculateTimeElapsed(DateTime dt) {
    DateTime currentTime = DateTime.now();
    if (dt.year != currentTime.year) {
      final int diff = (dt.year - currentTime.year).abs();
      return "$diff year ago";
    }
    if (dt.month != currentTime.month) {
      final int diff = (dt.month - currentTime.month).abs();
      return "$diff month ago";
    }
    if (dt.day != currentTime.day) {
      final int diff = (dt.day - currentTime.day).abs();
      return "$diff day ago";
    }
    if (dt.hour != currentTime.hour) {
      final int diff = (dt.hour - currentTime.hour).abs();
      return "$diff hour ago";
    }
    final int diff = (dt.minute - currentTime.minute).abs();
    return "$diff minute ago";
  }

  static int calculateTimeElapsedInteger(DateTime dt) {
    DateTime currentTime = DateTime.now();
    if (dt.year != currentTime.year) {
      final int diff = (dt.year - currentTime.year).abs();
      return diff;
    }
    if (dt.month != currentTime.month) {
      final int diff = (dt.month - currentTime.month).abs();
      return diff;
    }
    if (dt.day != currentTime.day) {
      final int diff = (dt.day - currentTime.day).abs();
      return diff;
    }
    if (dt.hour != currentTime.hour) {
      final int diff = (dt.hour - currentTime.hour).abs();
      return diff;
    }
    final int diff = (dt.minute - currentTime.minute).abs();
    return diff;
  }
}

class ArgumentsForPeopleProfile {
  JumpinUser jumpinUser;

  ArgumentsForPeopleProfile({@required this.jumpinUser});
}

class Vibemeter {
  String myWorkPlace;
  String peopleWorkPlace;
  int myConnectionsNo;
  double distance;
  int peopleConnectionsNo;
  int myAge;
  int peopleAge;
  String myAcadInstituition;
  String peopleAcadInstituition;
  int mutualConnections;
  List myInterestList;
  List peopleInterestlist;

  Vibemeter(
      {@required this.myInterestList,
      @required this.peopleInterestlist,
      @required this.myWorkPlace,
      @required this.peopleWorkPlace,
      @required this.myConnectionsNo,
      @required this.peopleConnectionsNo,
      @required this.myAge,
      @required this.distance,
      @required this.peopleAge,
      @required this.myAcadInstituition,
      @required this.peopleAcadInstituition,
      @required this.mutualConnections});

  double workplacePoint() {
    double wp = myWorkPlace == peopleWorkPlace ? 10 : 8;
    //print("\n\n workplace point-> $wp");
    return wp;
  }

  double acadPlacePoint() {
    double app = myAcadInstituition == peopleAcadInstituition ? 10 : 8;
    //print("\n\n Acad place point -> $app");
    return app;
  }

  double agePoint() {
    double diff = (myAge - peopleAge).abs().toDouble();
    //print("\n\n age diff is $diff with myAge-> $myAge, peopleAge->$peopleAge");
    if (diff == 0)
      return 20;
    else if (diff == 1)
      return 18;
    else if (diff == 2)
      return 16;
    else if (diff == 3)
      return 14;
    else if (diff == 4) return 12;
    return 10;
  }

  double mutualConnectionPoint() {
    //print("\n\n numbr of mutual connections -> ${mutualConnections}");

    if (mutualConnections >= 20)
      return 10;
    else if (mutualConnections >= 16)
      return 9;
    else if (mutualConnections >= 12)
      return 8;
    else if (mutualConnections >= 8)
      return 7;
    else if (mutualConnections >= 4) return 6;
    return 5;
  }

  double interestPoint() {
    final List<String> mutualInterests = [];

    myInterestList.forEach((myInterest) {
      peopleInterestlist.forEach((pI) {
        if (myInterest == pI) mutualInterests.add(myInterest as String);
      });
    });

    int mutualInterestNo = mutualInterests.length;
    //print("\n\n numbr of mutual interests -> ${mutualInterests.length}");
    if (mutualInterestNo >= 10)
      return 30;
    else if (mutualInterestNo >= 4)
      return 28;
    else if (mutualInterestNo >= 3)
      return 26;
    else if (mutualInterestNo >= 2)
      return 24;
    else if (mutualInterestNo >= 1) return 22;
    return 20;
  }

  double calculateDistance() {
    if (distance < 10)
      return 10;
    else if (distance < 20)
      return 9;
    else if (distance < 30)
      return 8;
    else if (distance < 40) return 7;
    return 6;
  }

  double calculateVibe() =>
      workplacePoint() +
      acadPlacePoint() +
      interestPoint() +
      mutualConnectionPoint() +
      agePoint() +
      calculateDistance();
}

class ConnectionChecker {
  StreamSubscription<DataConnectionStatus> listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"))
              ]);
        });
  }

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          InternetStatus = "Connected to the Internet";
          contentmessage = "Connected to the Internet";
          // _showDialog(InternetStatus, contentmessage, context);
          break;
        case DataConnectionStatus.disconnected:
          InternetStatus =
              "You are either disconnected from the Internet or the connection is very slow";
          contentmessage = "Please check your internet connection";
          _showDialog(InternetStatus, contentmessage, context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }
}

class LocationUtils {
  static Future<Position> getLocation() async {
    var currentLocation;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permissionLocal = await Geolocator.checkPermission();
    if (permissionLocal == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permissionLocal == LocationPermission.denied) {
      permissionLocal = await Geolocator.checkPermission();

      if (permissionLocal != LocationPermission.whileInUse &&
          permissionLocal != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permissionLocal).');
      }
    }
    try {
      currentLocation = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation as Position;
  }

  static Future<Address> getAddress(Position position) async {
    Coordinates coordinates =
        Coordinates(position.latitude, position.longitude);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = addresses.first;
    return first;
  }

  static Future updateLocationInDatabase(Position position) async {
    GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .update({"geoPoint": geoPoint}).whenComplete(
            () => print('value updated'));
  }

  static double getDistance(double endLatPassed, double endLongPassed) {
    final double startLat = double.parse(sharedPrefs.myLatitude);
    final double startLong = double.parse(sharedPrefs.myLongitude);
    final double endLat = double.parse(endLatPassed.toString());
    final double endLong = double.parse(endLongPassed.toString());
    //return 234.6543;
    if (endLat == 0.0 || endLong == 0.0) return 0.0;
    double distance = GeolocatorPlatform.instance
        .distanceBetween(startLat, startLong, endLat, endLong);
    distance.truncateToDouble();
    return distance / 1000;
  }
}

class EnsureVisibleWhenFocused extends StatefulWidget {
  const EnsureVisibleWhenFocused({
    Key key,
    @required this.child,
    @required this.focusNode,
    this.curve: Curves.ease,
    this.duration: const Duration(milliseconds: 100),
  }) : super(key: key);

  /// The node we will monitor to determine if the child is focused
  final FocusNode focusNode;

  /// The child widget that we are wrapping
  final Widget child;

  /// The curve we will use to scroll ourselves into view.
  ///
  /// Defaults to Curves.ease.
  final Curve curve;

  /// The duration we will use to scroll ourselves into view
  ///
  /// Defaults to 100 milliseconds.
  final Duration duration;

  EnsureVisibleWhenFocusedState createState() =>
      new EnsureVisibleWhenFocusedState();
}

class EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(_ensureVisible);
  }

  Future<Null> _ensureVisible() async {
    // Wait for the keyboard to come into view
    // TODO: position doesn't seem to notify listeners when metrics change,
    // perhaps a NotificationListener around the scrollable could avoid
    // the need insert a delay here.
    await new Future.delayed(const Duration(milliseconds: 600));

    if (!widget.focusNode.hasFocus) return;

    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    ScrollableState scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    ScrollPosition position = scrollableState.position;
    double alignment;
    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0.0;
    } else {
      if (position.pixels < viewport.getOffsetToReveal(object, 1.0).offset) {
        // Move up to the bottom of the viewport
        alignment = 1.0;
      } else {
        // No scrolling is necessary to reveal the child
        return;
      }
    }
    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  Widget build(BuildContext context) => widget.child;
}
