import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionController {
  final List<ConnectionUser> _userConnections = [];

  List<ConnectionUser> get userConnections => _userConnections;

  Stream<DocumentSnapshot> getConnectionsList() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .snapshots();
  }

  Future fetchUserConnections() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(sharedPrefs.userid)
          .get()
          .then((DocumentSnapshot snapshot) {
        snapshot['myConnections'].forEach((json) {
          ConnectionUser cu =
              ConnectionUser.fromJson(json as Map<String, dynamic>);

          _userConnections.add(cu);
        });
      });
      sharedPrefs.myNoOfConnections = _userConnections.length;

      if (_userConnections.isNotEmpty) {
        sharedPrefs.myConnectionListasString =
            ConnectionUser.encode(_userConnections);
      }
    } catch (e) {
      print("Error is $e");
    }
  }
}
