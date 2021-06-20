import 'dart:convert';

import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/people_home/presentation/widgets/each_user_template.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ListUserCards extends StatefulWidget {
  const ListUserCards(
      {Key key,
      @required this.height,
      @required this.width,
      this.currentUser,
      @required this.list})
      : super(key: key);

  final double height;
  final double width;
  final List<JumpinUser> list;
  final JumpinUser currentUser;

  @override
  _ListUserCardsState createState() => _ListUserCardsState();
}

class _ListUserCardsState extends State<ListUserCards> {
  List vibeForPeople = [];
  @override
  void initState() {
    super.initState();
    vibeForPeople = jsonDecode(sharedPrefs.getVibeWithPeopleList);
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ServiceJumpinPeopleHome>(context, listen: false);
    if (widget.list.isEmpty && prov.getFiltersSelectionStatus == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/images/Home/no-results.png"),
          Column(
            children: [
              Text(
                "No results found!",
                textScaleFactor: 1,
                style: TextStyle(
                    fontSize: widget.height * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45),
              ),
              Padding(
                padding: EdgeInsets.only(top: widget.height * 0.04),
                child: NeumorphicButton(
                  onPressed: () {
                    prov.resetFiltersData();
                  },
                  style: NeumorphicStyle(
                      depth: 10,
                      intensity: 0.5,
                      boxShape: NeumorphicBoxShape.stadium(),
                      color: Colors.blue[400],
                      shadowDarkColor: Colors.blue[400]),
                  child: Text(
                    "Refresh",
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontSize: widget.height * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    } else {
      return Container(
        height: widget.height * 0.95,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return EachUserCard(
                  width: widget.width,
                  parentContext: context,
                  height: widget.height,
                  vibeWithUser: vibeForPeople[vibeForPeople.indexWhere(
                          (element) =>
                              element["peopleId"] == widget.list[index].id)]
                      ["peopleVibe"],
                  user: widget.list[index]);
            }),
      );
    }
  }
}
