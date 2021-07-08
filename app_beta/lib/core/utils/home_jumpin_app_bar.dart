import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'route_constants.dart';
import 'package:JumpIn/core/constants/constants.dart';

AppBar HomeJumpinAppBar(BuildContext context, String title) {
  SizeConfig().init(context);
  return AppBar(
    title: Row(
      children: [
        Container(
            margin: const EdgeInsets.only(right: 10),
            child: Image.asset('assets/images/Onboarding/logo_final.png',
                height: SizeConfig.blockSizeHorizontal * 6)),
        Text('$title'.toUpperCase(),
            style: TextStyle(
                fontFamily: font2,
                fontSize: SizeConfig.blockSizeHorizontal * 5,
                fontWeight: FontWeight.bold)),
      ],
    ),
    actions: [
      // Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: GestureDetector(
      //     onTap: () {
      //       Navigator.pushNamed(context, rSearch);
      //       print("Search tapped");
      //     },
      //     child: Container(
      //         height: SizeConfig.blockSizeHorizontal * 3,
      //         width: SizeConfig.blockSizeHorizontal * 8,
      //         // color: Colors.black26,
      //         margin: const EdgeInsets.all(3),
      //         child: const Icon(Icons.search)),
      //   ),
      // ),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, rListOfChat);
        },
        child: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeHorizontal * 10,
              width: SizeConfig.blockSizeHorizontal * 10,
              // color: Colors.black12,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(6),
              child: Image.asset(
                'assets/images/Home/chatIcon1.png',
              ),
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("chats").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  int count = 0;
                  return FutureBuilder(
                    future: fetchChatUnSeenCount(snapshot)
                        .then((value) => count = value),
                    builder: (context, snapshot) => Positioned(
                      right: SizeConfig.blockSizeHorizontal,
                      top: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(count.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    ],
  );
}

Future<int> fetchChatUnSeenCount(AsyncSnapshot<QuerySnapshot> docSnap) async {
  final List<String> docIds = [];

  docSnap.data.docs.forEach((doc) {
    final List usersList = doc["users"] as List;
    usersList.forEach((user) {
      if (user["id"] == sharedPrefs.userid) {
        docIds.add(doc.id);
      }
    });
  });

  int countOfUnSeenMessages = 0;

  for (int j = 0; j < docIds.length; j++) {
    final DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("chats")
        .doc(docIds[j])
        .get();
    (docSnap["messages"] as List).forEach((message) {
      if (message["idUser"] != sharedPrefs.userid) {
        if (message["seenByReceiver"] == false) countOfUnSeenMessages += 1;
      }
    });
  }

  return countOfUnSeenMessages;
}
