import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/features/people_profile/presentation/screens/people_profile.dart';
import 'package:JumpIn/features/user_utilities/domain/service_bookmarks.dart';
import 'package:JumpIn/core/utils/home_placeholder.dart';

import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScreenMyBookmarks extends StatelessWidget {
  final bookmarksContoller = ServiceBookmarks();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: JumpinAppBar(context, 'Bookmarks'),
        drawer: const JumpinNavDrawer(),
        body: FutureBuilder(
            future: bookmarksContoller.modelBookmarks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: circularProgressIndicator());
              }
              print(bookmarksContoller.isBookMarkConnection);
              return bookmarksContoller.allUsers.isNotEmpty
                  ? Container(
                      width: getScreenSize(context).width,
                      child: GridView.count(
                          physics: const BouncingScrollPhysics(),
                          primary: true,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 12,
                          crossAxisCount: 3,
                          children: List.generate(
                              bookmarksContoller.allUsers.length,
                              (index) => GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, rPeopleProfile, arguments: [
                                        bookmarksContoller.allUsers[index].id,
                                        "bookMark"
                                      ]);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: CircleAvatar(
                                            radius:
                                                SizeConfig.blockSizeHorizontal *
                                                    6,
                                            backgroundImage: NetworkImage(
                                                bookmarksContoller
                                                    .allUsers[index].photoUrl),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(5.0),
                                          child: Text(
                                            bookmarksContoller
                                                            .isBookMarkConnection[
                                                        bookmarksContoller
                                                            .allUsers[index]
                                                            .id] ==
                                                    true
                                                ? bookmarksContoller
                                                    .allUsers[index].fullname
                                                : bookmarksContoller
                                                    .allUsers[index].username,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    4),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(2.0),
                                          child: Text(
                                            "Tap to know more",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    2),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "You haven't bookmarked anything yet.",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          ),
                        )
                      ],
                    );
            }));
  }
}
