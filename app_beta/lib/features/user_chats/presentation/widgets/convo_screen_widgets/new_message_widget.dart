import 'package:JumpIn/core/network/chat_service.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  final String uniqueChatId;
  final ConnectionUser connectionUser;

  const NewMessageWidget({
    @required this.uniqueChatId,
    @required this.connectionUser,
    Key key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';
  List<String> icebreakers = [
    'Hey',
    'How are you?',
    'Interesting',
    'Vacation plans?'
  ];

  Future<void> sendMessage() async {
    FocusScope.of(context).unfocus();
    print('unique chat id: ${widget.uniqueChatId}');
    await ChatService().uploadMessage(
        uniqueChatId: widget.uniqueChatId,
        message: message,
        connectionUser: widget.connectionUser,
        seenByReceiver: false);

    _controller.clear();
  }

  Future<void> sendIcebreaker(String icebreaker) async {
    FocusScope.of(context).unfocus();
    print('unique chat id: ${widget.uniqueChatId}');
    await ChatService().uploadMessage(
        uniqueChatId: widget.uniqueChatId,
        message: icebreaker,
        connectionUser: widget.connectionUser,
        seenByReceiver: false);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: getScreenSize(context).height * 0.07,
            width: getScreenSize(context).width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: icebreakers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await sendIcebreaker(icebreakers[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          icebreakers[index],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            width: size.width,
            height: size.height * 0.09,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.01),
            // color: Colors.black12,
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.85,
                    decoration: BoxDecoration(
                        color: Color(0xffe9edf5),
                        borderRadius: BorderRadius.circular(40)),
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration.collapsed(
                          hintText: "Write a reply ...",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                          fontSize: size.height * 0.019,
                          fontWeight: FontWeight.w400),
                      enableSuggestions: true,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) => setState(() {
                        message = value;
                      }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (message.trim().isNotEmpty) await sendMessage();
                    },
                    child: Container(
                      width: constraints.maxWidth * 0.08,
                      // color: Colors.black12,
                      child: Image.asset("assets/images/chats/send.png"),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
