import 'package:JumpIn/features/people_home/presentation/widgets/list_user_cards.dart';
import 'package:JumpIn/features/user_utilities/domain/service_requests.dart';
import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenMyPeopleReqReq extends StatefulWidget {
  @override
  _ScreenMyPeopleReqReqState createState() => _ScreenMyPeopleReqReqState();
}

class _ScreenMyPeopleReqReqState extends State<ScreenMyPeopleReqReq> {
  final ServiceRequests requestsController = ServiceRequests();

  @override
  void initState() {
    requestsController.getLocationLatLong(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: JumpinAppBar(context, 'Requests'),
        drawer: const JumpinNavDrawer(),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: circularProgressIndicator());
              if (snapshot.hasError) {
                return const Center(child: Text('Network Error'));
              }
              requestsController.fetchRequetsUserID(snapshot);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListUserCards(
                      height: height,
                      width: width,
                      currentUser: requestsController.currentUser,
                      list: requestsController.requestingUsers,
                    ),
                  ),
                ],
              );
            }));
  }
}
