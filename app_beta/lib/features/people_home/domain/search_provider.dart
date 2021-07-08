import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchProvider extends ChangeNotifier {
  List _userNamesWithIds = [];
  List get userNamesWithIds => _userNamesWithIds;

  List _tempUserNamesWithIds = [];
  List get tempUserNamesWithIds => _tempUserNamesWithIds;

  bool _isLoading = false;
  bool get getLoadingStatus => _isLoading;

  Future updateDatabseWithIndex() async {
    FirebaseFirestore.instance.collection("users").get().then((docSnap) {
      docSnap.docs.forEach((element) {
        if (element.data()["userNameSearchIndex"] == null) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(element.id)
              .update({
            "userNameSearchIndex":
                (element.data()["username"] as String).substring(0, 1)
          });
        }
      });
    });
  }

  Future searchUserName(String searchText) async {
    if (searchText.isEmpty) {
      _userNamesWithIds = [];
      _tempUserNamesWithIds = [];
      notifyListeners();
    }
    String queryText;
    if (searchText.isNotEmpty) {
      queryText =
          searchText.substring(0, 1).toLowerCase() + searchText.substring(1);
    }

    if (_userNamesWithIds.isEmpty && searchText.length == 1) {
      _isLoading = true;
      notifyListeners();
      FirebaseFirestore.instance
          .collection("users")
          .where("userNameSearchIndex",
              isEqualTo: searchText.substring(0, 1).toLowerCase())
          .get()
          .then((result) {
        _isLoading = false;
        notifyListeners();
        result.docs.forEach((element) {
          _userNamesWithIds.add({
            "id": element["id"],
            "userName": element["username"],
            "photoUrl": element["photoUrl"]
          });
          notifyListeners();
        });
      });
      FirebaseFirestore.instance
          .collection("users")
          .where("userNameSearchIndex",
              isEqualTo: searchText.substring(0, 1).toUpperCase())
          .get()
          .then((result) {
        _isLoading = false;
        notifyListeners();
        result.docs.forEach((element) {
          _userNamesWithIds.add({
            "id": element["id"],
            "userName": element["username"],
            "photoUrl": element["photoUrl"]
          });
          notifyListeners();
        });
      });
    } else {
      _tempUserNamesWithIds = [];
      print(_userNamesWithIds.length);
      _userNamesWithIds.forEach((element) {
        if ((element["userName"] as String).startsWith(queryText)) {
          _tempUserNamesWithIds.add(element);
          notifyListeners();
        }
      });
    }
    // print(_userNamesWithIds);
    // print(_tempUserNamesWithIds);
  }

  Future<bool> checkIfConnection(String id) async {
    bool val = false;
    var doc =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    if (doc.exists) {
      (doc["myConnections"] as List).forEach((element) {
        ConnectionUser cu = ConnectionUser.fromJson(element);
        print(cu.id);
        print("--------------------");
        print(sharedPrefs.userid);
        if (sharedPrefs.userid == cu.id) {
          val = true;
        }
      });
    }
    return val;
  }
}
