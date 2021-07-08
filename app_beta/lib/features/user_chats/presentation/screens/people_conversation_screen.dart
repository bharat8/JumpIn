import 'package:JumpIn/core/network/chat_service.dart';
import 'package:JumpIn/features/user_chats/domain/chat_list.dart';
import 'package:JumpIn/features/user_chats/presentation/widgets/convo_screen_widgets/messages_widget.dart';
import 'package:JumpIn/features/user_chats/presentation/widgets/convo_screen_widgets/new_message_widget.dart';
import 'package:JumpIn/features/user_chats/presentation/widgets/convo_screen_widgets/profile_header_widget.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeopleConversationScreen extends StatefulWidget {
  final ConnectionUser connectionUser;
  final String navigatorRoute;

  const PeopleConversationScreen({
    Key key,
    @required this.connectionUser,
    @required this.navigatorRoute,
  }) : super(key: key);

  @override
  _PeopleConversationScreenState createState() =>
      _PeopleConversationScreenState();
}

class _PeopleConversationScreenState extends State<PeopleConversationScreen> {
  String uniqueChatId = '';

  ConnectionChecker cc = ConnectionChecker();

  @override
  void initState() {
    uniqueChatId = ChatService()
        .getUniqueChatId(sharedPrefs.userid, widget.connectionUser.id);
    cc.checkConnection(context);
    super.initState();
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (widget.navigatorRoute == "notification" ||
            widget.navigatorRoute == "connection") {
          Navigator.of(context).pop();
          return true;
        } else {
          final InboxChatList inboxChatList =
              Provider.of<InboxChatList>(context, listen: false);
          await inboxChatList.changeUnseenStatus(widget.connectionUser.id);
          Navigator.of(context).pop();
          return true;
        }
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          body: uniqueChatId.isNotEmpty
              ? SafeArea(
                  child: Column(
                    children: [
                      ProfileHeaderWidget(
                        userid: widget.connectionUser.id,
                        name: widget.connectionUser.fullname,
                        username: widget.connectionUser.username,
                        routeType: widget.navigatorRoute,
                        image: widget.connectionUser.avatarImageUrl,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: MessagesWidget(
                              uniqueChatId: uniqueChatId,
                              connectionUser: widget.connectionUser),
                        ),
                      ),
                      NewMessageWidget(
                          uniqueChatId: uniqueChatId,
                          connectionUser: widget.connectionUser)
                    ],
                  ),
                )
              : circularProgressIndicator()),
    );
  }
}
