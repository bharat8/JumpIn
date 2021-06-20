import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class PeopleBloc {
  List<DocumentSnapshot> jumpinPeopleList;

  BehaviorSubject<List<DocumentSnapshot>> peopleController;

  PeopleBloc() {
    peopleController = BehaviorSubject<List<DocumentSnapshot>>();
  }

  Stream<List<DocumentSnapshot>> get jumpinPeopleStream =>
      peopleController.stream;

  Future fetchFirst10Records() async {
    try {
      jumpinPeopleList =
          (await FirebaseFirestore.instance.collection("users").limit(10).get())
              .docs;
      peopleController.sink.add(jumpinPeopleList);
    } on SocketException {
      peopleController.sink.addError(SocketException("No Internet"));
    } catch (e) {
      print(e.toString());
      peopleController.sink.addError(e);
    }
  }

  Future fetchNext10Records() async {
    try {
      List<DocumentSnapshot> newJumpinPeopleList = (await FirebaseFirestore
              .instance
              .collection("users")
              .startAfterDocument(jumpinPeopleList[jumpinPeopleList.length - 1])
              .limit(2)
              .get())
          .docs;

      jumpinPeopleList.addAll(newJumpinPeopleList);
      peopleController.sink.add(jumpinPeopleList);
    } on SocketException {
      peopleController.sink.addError(SocketException("No Internet"));
    } catch (e) {
      print(e.toString());
      peopleController.sink.addError(e);
    }
  }

  void dispose() {
    peopleController.close();
  }
}
