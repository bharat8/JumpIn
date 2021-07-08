import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

AppBar NotificationJumpinAppBar(BuildContext context, String title) {
  SizeConfig().init(context);
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        Container(
            margin: const EdgeInsets.only(right: 10),
            child: Image.asset('assets/images/Onboarding/logo_final.png',
                height: SizeConfig.blockSizeHorizontal * 7)),
        Text('$title'.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: font2,
                fontSize: SizeConfig.blockSizeHorizontal * 5,
                fontWeight: FontWeight.bold)),
      ],
    ),
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, rListOfChat);
        },
        child: Stack(
          children: [
            Container(
              height: SizeConfig.blockSizeHorizontal * 12,
              width: SizeConfig.blockSizeHorizontal * 12,
              // color: Colors.black12,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(6),
              child: Image.asset(
                'assets/images/Home/chatIcon1.png',
              ),
            ),
            FutureBuilder(
                future: fetchChatUnSeenCount(),
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Positioned(
                    right: SizeConfig.blockSizeHorizontal,
                    top: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(snapshot.data.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
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

Future<int> fetchChatUnSeenCount() async {
  final List<String> docIds = [];
  final QuerySnapshot docSnap =
      await FirebaseFirestore.instance.collection("chats").get();
  docSnap.docs.forEach((doc) {
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
