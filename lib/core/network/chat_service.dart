import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/features/user_chats/data/model_message.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final Stream<DocumentSnapshot> connectionsDocumentsnapshotStream =
      FirebaseFirestore.instance
          .collection('users')
          .doc(sharedPrefs.userid)
          .snapshots();

  static final Stream<QuerySnapshot> allUsersQuerysnapshotStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  String getUniqueChatId(String currentUserId, String connectionUserid) {
    return (<String>[currentUserId, connectionUserid]..sort())
        .join()
        .hashCode
        .toString();
  }

  Future<void> uploadMessage(
      {String uniqueChatId,
      String message,
      ConnectionUser connectionUser,
      bool seenByReceiver}) async {
    final doc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(uniqueChatId)
        .get();

    if (!doc.exists) {
      ConnectionUser currentUser = ConnectionUser(
          id: sharedPrefs.userid,
          username: sharedPrefs.userName,
          fullname: sharedPrefs.fullname,
          avatarImageUrl: sharedPrefs.photoUrl);
      Message newMessage = Message(
          idUser: sharedPrefs.userid,
          message: message,
          createdAt: DateTime.now(),
          seenByReceiver: seenByReceiver);

      FirebaseFirestore.instance.collection('chats').doc(uniqueChatId).set({
        "users": FieldValue.arrayUnion(
            [currentUser.toJson(), connectionUser.toJson()]),
        "messages": FieldValue.arrayUnion([newMessage.toJson()])
      }).whenComplete(() => print('sent'));
    } else {
      Message newMessage = Message(
        idUser: sharedPrefs.userid,
        message: message,
        createdAt: DateTime.now(),
        seenByReceiver: seenByReceiver,
      );

      FirebaseFirestore.instance.collection('chats').doc(uniqueChatId).update({
        "messages": FieldValue.arrayUnion([newMessage.toJson()])
      }).whenComplete(() => print('updated and sent'));
    }
  }

  static Stream<QuerySnapshot> allChatGroupIds =
      FirebaseFirestore.instance.collection('chats').snapshots();
}
