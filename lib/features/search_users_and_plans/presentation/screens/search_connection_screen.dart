import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchConnectionScreen extends StatefulWidget {
  @override
  _SearchConnectionScreenState createState() => _SearchConnectionScreenState();
}

class _SearchConnectionScreenState extends State<SearchConnectionScreen> {
  Future<List<JumpinUser>> search(String search) async {
    List<JumpinUser> listOfusers = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: search)
        .get();

    return listOfusers = snapshot.docs
        .map((doc) => JumpinUser.fromDocument(doc.data()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<JumpinUser>(
            emptyWidget: Column(
              children: [
                Lottie.asset("assets/animations/page-not-found.json",
                    height: 100, repeat: true, animate: true, reverse: true),
                Center(
                  child: Text("Not found",
                      style: TextStyle(
                          fontFamily: font1,
                          fontSize: SizeConfig.blockSizeHorizontal * 4)),
                ),
              ],
            ),
            hintText: "Search by username",
            loader: circularProgressIndicator(),
            onSearch: search,
            onItemFound: (JumpinUser user, int index) {
              return ListTile(
                onTap: () {
                  String source = "connection";

                  Navigator.pushNamed(context, rPeopleProfile,
                      arguments: [user.id, source]);
                },
                leading: Container(
                  height: SizeConfig.blockSizeHorizontal * 10,
                  width: SizeConfig.blockSizeHorizontal * 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      scale: 1.0,
                      image: NetworkImage(user.photoUrl),
                    ),
                  ),
                ),
                title: Text(user.fullname),
                subtitle: Text(user.username),
              );
            },
          ),
        ),
      ),
    );
  }
}
