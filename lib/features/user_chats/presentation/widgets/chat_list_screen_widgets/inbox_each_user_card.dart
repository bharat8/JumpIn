import 'package:JumpIn/features/user_chats/data/model_message.dart';
import 'package:JumpIn/features/user_chats/domain/chat_list.dart';
import 'package:JumpIn/features/user_chats/presentation/screens/people_conversation_screen.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inbox_user_last_message_and_time.dart';
import 'inbox_user_name_status.dart';
import 'inbox_user_profile_photo.dart';

class InboxEachUserCard extends StatelessWidget {
  const InboxEachUserCard(
      {Key key,
      @required this.size,
      @required this.index,
      @required this.messages,
      @required this.chatUser,
      this.unSeenCount})
      : super(key: key);

  final Size size;
  final int index;
  final ConnectionUser chatUser;
  final List<Message> messages;
  final int unSeenCount;

  @override
  Widget build(BuildContext context) {
    Message lastMessageObject;
    String lastMessage;
    DateTime createdAt;
    bool isSeen;
    if (messages.isNotEmpty) {
      lastMessageObject = messages[messages.length - 1];
      lastMessage = lastMessageObject.message;
      createdAt = lastMessageObject.createdAt;
      isSeen = lastMessageObject.seenByReceiver;
    } else {
      lastMessage = "";
      createdAt = DateTime.now();
    }
    return GestureDetector(
        onTap: () {
          final InboxChatList inboxChatList =
              Provider.of<InboxChatList>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ListenableProvider<InboxChatList>.value(
                      value: inboxChatList,
                      child: PeopleConversationScreen(
                        connectionUser: chatUser,
                        navigatorRoute: "normal",
                      ),
                    )),
          );
        },
        child: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                InboxUserProfilePhoto(imageURL: chatUser.avatarImageUrl),
                if (unSeenCount != null && unSeenCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(unSeenCount.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ),
                    ),
                  ),
              ],
            )),
            Expanded(
                child: InboxUserNameNStatus(
                    name: chatUser.fullname, status: true)),
            Expanded(
              child: InboxUserLastMessageNtime(
                messages: messages,
                lastMessage: lastMessage,
                createdAt: createdAt,
                lastMessageSeen: isSeen,
              ),
            ),
          ],
        ));
  }
}
