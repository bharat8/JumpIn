import 'package:JumpIn/features/user_chats/domain/chat_list.dart';
import 'package:JumpIn/features/user_chats/presentation/widgets/chat_list_screen_widgets/inbox_chat_list_layout.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PeopleInbox extends StatefulWidget {
  @override
  _PeopleInboxState createState() => _PeopleInboxState();
}

class _PeopleInboxState extends State<PeopleInbox> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inboxChatList = Provider.of<InboxChatList>(context, listen: false);
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Column(
                children: [
                  Icon(Icons.warning,
                      size: SizeConfig.blockSizeHorizontal * 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Network Error",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: SizeConfig.blockSizeHorizontal * 6)),
                  )
                ],
              ));
            }
            inboxChatList.sortDataAccToChats(snapshot);
            return inboxChatList.sortedChatUsers.isEmpty
                ? Center(
                    child: Text('No Chats yet',
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 6)))
                : InboxChatListLayout(size: size);
          }),
    );
  }
}
