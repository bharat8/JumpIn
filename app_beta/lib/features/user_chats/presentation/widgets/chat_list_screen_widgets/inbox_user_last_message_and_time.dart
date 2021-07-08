import 'package:JumpIn/features/user_chats/data/model_message.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';

class InboxUserLastMessageNtime extends StatelessWidget {
  const InboxUserLastMessageNtime(
      {Key key,
      this.messages,
      this.lastMessage,
      this.createdAt,
      this.lastMessageSeen})
      : super(key: key);
  final List<Message> messages;
  final String lastMessage;
  final DateTime createdAt;
  final bool lastMessageSeen;
  @override
  Widget build(BuildContext context) {
    String time = "";
    if (createdAt != null) {
      time = Utils.calculateTimeElapsed(createdAt);
    }
    return lastMessage.isEmpty || createdAt == null
        ? Container(
            margin: const EdgeInsets.only(left: 1, right: 1),
            // width: 800,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Start a conversation',
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontFamily: font1, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.only(left: 1, right: 1),
            // width: 800,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      lastMessage,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: font1,
                          fontWeight: lastMessageSeen == true
                              ? FontWeight.w300
                              : FontWeight.w600,
                          color: lastMessageSeen == true
                              ? Colors.grey[500]
                              : Colors.black),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      time,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.withOpacity(0.6)),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
