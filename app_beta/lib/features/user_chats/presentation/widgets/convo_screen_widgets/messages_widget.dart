import 'package:JumpIn/features/user_chats/data/model_message.dart';
import 'package:JumpIn/features/user_chats/presentation/widgets/convo_screen_widgets/message_widget.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesWidget extends StatelessWidget {
  final String uniqueChatId;
  final ConnectionUser connectionUser;

  const MessagesWidget({
    @required this.uniqueChatId,
    @required this.connectionUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(uniqueChatId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return buildText('Something Went Wrong Try later');
            } else {
              if (!snapshot.data.exists) {
                ConnectionUser cu = ConnectionUser(
                    id: sharedPrefs.userid,
                    username: sharedPrefs.userName,
                    fullname: sharedPrefs.fullname,
                    avatarImageUrl: sharedPrefs.photoUrl);
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(uniqueChatId)
                    .set({
                  'messages': [],
                  'users': FieldValue.arrayUnion(
                      [cu.toJson(), connectionUser.toJson()])
                });
              }

              List<Message> messages = [];

              snapshot.data['messages'].forEach((json) {
                Message msg = Message.fromJson(json as Map<String, dynamic>);
                messages.add(msg);
              });

              messages = List.from(messages.reversed);
              return messages.isEmpty
                  ? buildText('Start a conversation')
                  : ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return MessageWidget(
                          message: message,
                          connectionUser: connectionUser,
                          isMe: message.idUser == sharedPrefs.userid,
                        );
                      },
                    );
            }
        }
      },
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
