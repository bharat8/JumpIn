import 'package:JumpIn/core/network/chat_service.dart';
import 'package:JumpIn/features/user_chats/data/model_message.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class InboxChatList extends ChangeNotifier {
  List<ConnectionUser> _sortedChatUsers = <ConnectionUser>[];

  List<ConnectionUser> tempList = <ConnectionUser>[];

  Map<String, List<Message>> _mapOfMsgListUserSpecific =
      <String, List<Message>>{};

  List<ConnectionUser> get sortedChatUsers => _sortedChatUsers;

  set setSortedChatUsers(List<ConnectionUser> list) {
    _sortedChatUsers = list;
  }

  set setMapOfMsgListUserSpecific(Map<String, List<Message>> map) {
    _mapOfMsgListUserSpecific = map;
  }

  Map<String, List<Message>> get mapOfMsgListUserSpecific =>
      _mapOfMsgListUserSpecific;

  Map<String, int> unSeenCount = {};

  void sortDataAccToChats(AsyncSnapshot snapshot) {
    List<ConnectionUser> chatUsers = [];

    //store messages of each specific user
    List<List<Message>> messageListUserSpecific = [];

    //store map of messages with key=userid,value=listOfMessagesWithThatUser
    snapshot.data.docs.forEach((doc) {
      List<ConnectionUser> cus = [];
      List<Message> messages = [];
      doc["users"].forEach((json) {
        ConnectionUser cu =
            ConnectionUser.fromJson(json as Map<String, dynamic>);
        cus.add(cu);
      });
      if (cus[0].id == sharedPrefs.userid) {
        chatUsers.add(cus[1]);
        doc["messages"].forEach((json) {
          Message msg = Message.fromJson(json as Map<String, dynamic>);
          messages.add(msg);
        });
        mapOfMsgListUserSpecific[cus[1].id] = messages;
        messageListUserSpecific.add(messages);
      } else if (cus[1].id == sharedPrefs.userid) {
        chatUsers.add(cus[0]);
        doc["messages"].forEach((json) {
          Message msg = Message.fromJson(json as Map<String, dynamic>);
          messages.add(msg);
        });
        mapOfMsgListUserSpecific[cus[0].id] = messages;
        messageListUserSpecific.add(messages);
      }
    });

    chatUsers.forEach((user) {
      final String uniqueChatId =
          ChatService().getUniqueChatId(sharedPrefs.userid, user.id);
      FirebaseFirestore.instance
          .collection("chats")
          .doc(uniqueChatId)
          .get()
          .then((docSnap) {
        int count = 0;
        (docSnap["messages"]).forEach((json) {
          Message msg = Message.fromJson(json as Map<String, dynamic>);
          if (msg.idUser != sharedPrefs.userid) {
            if (msg.seenByReceiver == false) count += 1;
            unSeenCount[msg.idUser] = count;
          }
          notifyListeners();
        });
      });
    });
    // List<ConnectionUser> sortedChatUsers = [];

    messageListUserSpecific.forEach((messages) {
      DateTime dateTime = DateTime.now();
      if (messages.length > 0)
        dateTime = messages[messages.length - 1].createdAt;

      //get the id of chatUsers!=sharedPrefs.userid
      String currentID = "";
      for (Message msg in messages) {
        if (msg.idUser != sharedPrefs.userid) {
          currentID = msg.idUser;
          break;
        }
      }
      if (currentID.isEmpty)
        currentID = chatUsers[messageListUserSpecific.indexOf(messages)].id;

      if (_sortedChatUsers.isEmpty && chatUsers.isNotEmpty) {
        ConnectionUser cu = chatUsers[0];
        cu.timestamp = Timestamp.fromDate(dateTime);
        _sortedChatUsers.add(cu);
      } else {
        if (dateTime.isAfter(_sortedChatUsers[0].timestamp.toDate())) {
          int index = chatUsers.indexWhere((user) => user.id == currentID);

          ConnectionUser cu = chatUsers[index];
          cu.timestamp = Timestamp.fromDate(dateTime);
          _sortedChatUsers.insert(0, cu);
        } else if (dateTime.isBefore(_sortedChatUsers[0].timestamp.toDate())) {
          print("\n\nbefore\n\n");
          int index = chatUsers.indexWhere((user) => user.id == currentID);

          ConnectionUser cu = chatUsers[index];
          cu.timestamp = Timestamp.fromDate(dateTime);
          _sortedChatUsers.insert(_sortedChatUsers.length, cu);
        }
      }
    });

    _sortedChatUsers.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    _sortedChatUsers = _sortedChatUsers.reversed.toList();

    List<ConnectionUser> tempOne = [];
    List<ConnectionUser> tempTwo = [];
    mapOfMsgListUserSpecific.forEach((key, value) {
      if (value.length > 0) {
        tempOne.add(_sortedChatUsers[
            _sortedChatUsers.indexWhere((element) => element.id == key)]);
      } else {
        tempTwo.add(_sortedChatUsers[
            _sortedChatUsers.indexWhere((element) => element.id == key)]);
      }
    });
    tempOne.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    tempOne.addAll(tempTwo);
    print(tempOne);
    _sortedChatUsers = tempOne;

    // Map<String, bool> map = {};
    // _sortedChatUsers.forEach((user) {
    //   tempList.add(user);
    //   map[user.id] = false;
    // });

    // tempList.forEach((user1) {
    //   if (map[user1.id] == false) {
    //     _sortedChatUsers.add(user1);
    //     map[user1.id] = true;
    //   }
    // });
  }

  Future<void> changeUnseenStatus(String id) async {
    // print(unSeenCount);
    if (unSeenCount.containsKey(id)) {
      final String uniqueChatId =
          ChatService().getUniqueChatId(sharedPrefs.userid, id);
      List oldMessages = [];
      List newMessages = [];
      FirebaseFirestore.instance
          .collection("chats")
          .doc(uniqueChatId)
          .get()
          .then((docSnap) {
        docSnap["messages"].forEach((json) {
          Message msg = Message.fromJson(json as Map<String, dynamic>);
          oldMessages.add(msg.toJson());
          if (msg.seenByReceiver == false) msg.seenByReceiver = true;
          newMessages.add(msg.toJson());
        });
        print(oldMessages);
        print(newMessages);
      }).then((_) async {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(uniqueChatId)
            .set({
          "messages": FieldValue.arrayRemove(oldMessages),
        }, SetOptions(merge: true));

        await FirebaseFirestore.instance
            .collection("chats")
            .doc(uniqueChatId)
            .set({
          "messages": FieldValue.arrayUnion(newMessages),
        }, SetOptions(merge: true));
      }).then((_) {
        unSeenCount[id] = 0;
        notifyListeners();
      });
    }
  }
}
