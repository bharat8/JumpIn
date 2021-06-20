import 'package:JumpIn/features/user_chats/data/model_message.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;
  final ConnectionUser connectionUser;

  const MessageWidget(
      {@required this.message,
      @required this.isMe,
      @required this.connectionUser});

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(12);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        isMe != true
            ? CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(connectionUser.avatarImageUrl))
            : Container(),
        Container(
          margin: const EdgeInsets.all(6),
          constraints: const BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[100],
            borderRadius: isMe
                ? borderRadius
                    .subtract(const BorderRadius.only(bottomRight: radius))
                : borderRadius
                    .subtract(const BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(message),
        ),
      ],
    );
  }

  Widget buildMessage(Message message) {
    String minute;
    message.createdAt.minute < 10
        ? minute = "0${message.createdAt.minute}"
        : minute = message.createdAt.minute.toString();
    return message.message.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                child: Text(
                  message.message,
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontWeight: isMe ? FontWeight.w500 : FontWeight.w400),
                  textAlign: TextAlign.start,
                ),
              ),
              isMe
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5),
                            child: Text("${message.createdAt.hour}:$minute",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: isMe ? Colors.white : Colors.black,
                                    fontWeight: isMe
                                        ? FontWeight.w500
                                        : FontWeight.w400)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5),
                            child: Text(
                                "${message.createdAt.day}/${message.createdAt.month}/${message.createdAt.year}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: isMe ? Colors.white : Colors.black,
                                    fontWeight: isMe
                                        ? FontWeight.w500
                                        : FontWeight.w400)),
                          )
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5),
                            child: Text("${message.createdAt.hour}:$minute",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: isMe ? Colors.white : Colors.black,
                                    fontWeight: isMe
                                        ? FontWeight.w500
                                        : FontWeight.w400)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5),
                            child: Text(
                                "${message.createdAt.day}/${message.createdAt.month}/${message.createdAt.year}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: isMe ? Colors.white : Colors.black,
                                    fontWeight: isMe
                                        ? FontWeight.w500
                                        : FontWeight.w400)),
                          )
                        ],
                      ),
                    )
            ],
          );
  }
}
