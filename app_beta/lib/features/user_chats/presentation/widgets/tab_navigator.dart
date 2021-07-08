import 'package:JumpIn/features/user_chats/domain/chat_list.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/plan_Inbox.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/people_Inbox.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  ConnectionChecker cc = ConnectionChecker();

  @override
  void initState() {
    cc.checkConnection(context);
    super.initState();
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: ColorsJumpin.kSecondaryColor,
            ),
          ),
          title: Text('Chats',
              style: TextStyle(
                  fontFamily: font1,
                  fontSize: 20,
                  color: ColorsJumpin.kSecondaryColor,
                  fontWeight: FontWeight.bold)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  child: const Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 30,
              )),
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('People',
                    style: TextStyle(
                        fontFamily: font1,
                        color: ColorsJumpin.kSecondaryColor)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Plan',
                    style: TextStyle(
                        fontFamily: font1,
                        color: ColorsJumpin.kSecondaryColor)),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider<InboxChatList>(
                create: (context) => InboxChatList(), child: PeopleInbox()),
            PlanInbox()
          ],
        ),
      ),
    );
  }
}
