import 'package:JumpIn/features/user_chats/domain/chat_list.dart';
import 'package:JumpIn/features/user_chats/presentation/widgets/chat_list_screen_widgets/inbox_each_user_card.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class InboxChatListLayout extends StatelessWidget {
  InboxChatListLayout({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final inboxChatList = Provider.of<InboxChatList>(context);
    return Column(
      children: [
        SizedBox(height: getScreenSize(context).height * 0.05),
        Expanded(
            child: SizedBox(
                //height: size.height * 0.65,
                width: size.width,
                child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    primary: true,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: List.generate(
                        inboxChatList.sortedChatUsers.length, (index) {
                      return SizedBox(
                        width: size.width / 2,
                        child: InboxEachUserCard(
                          size: size,
                          index: index,
                          messages: inboxChatList.mapOfMsgListUserSpecific[
                              inboxChatList.sortedChatUsers[index].id],
                          chatUser: inboxChatList.sortedChatUsers[index],
                          unSeenCount: inboxChatList.unSeenCount[
                              inboxChatList.sortedChatUsers[index].id],
                        ),
                      );
                    })))),
      ],
    );
  }
}
