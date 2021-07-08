import 'dart:convert';

import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ServiceRateUs extends ChangeNotifier {
  bool _isLoading = false;
  bool get getLoadingStatus => _isLoading;

  bool _showError = false;
  bool get getErrorStatus => _showError;

  bool _isSubmitted = false;
  bool get getSubmittedStatus => _isSubmitted;
  set setSubmittedStatus(bool val) {
    _isSubmitted = val;
  }

  List _questionAnswers = [
    {
      "question": "How was your overall experience on JumpIn?*",
      "ratings": ["Terrible", "Not so bad", "I'm loving it"],
      "selection": [false, false, false]
    },
    {
      "question": "How likely are you to recommend JumpIn to others?*",
      "ratings": ["Not at all", "Probably I will", "Sure, gonna do it"],
      "selection": [false, false, false]
    },
    {
      "question": "How easy was it to use the app?*",
      "ratings": [
        "Hard to understand",
        "Only understood some parts",
        "Everything is pretty easy"
      ],
      "selection": [false, false, false]
    },
    {
      "question": "How did you like the look of the app?*",
      "ratings": ["Its horrible", "Could be improved", "Looks Awesome"],
      "selection": [false, false, false]
    },
    {
      "question": "Did you find interesting people on the app?*",
      "ratings": ["None", "Some", "Many"],
      "selection": [false, false, false]
    },
    {
      "question":
          "How frequently did people respond to your JumpIn requests and chats?*",
      "ratings": ["Not at all", "Somewhat frequently", "Very frequently"],
      "selection": [false, false, false]
    },
    {
      "question": "Did you use the Recommend button?*",
      "ratings": ["No", "Yes"],
      "selection": [false, false],
      "answer": ""
    },
    {
      "question": "Did you make any meaningful connections on the app?*",
      "ratings": ["No", "Yes"],
      "selection": [false, false]
    },
    {"question": "Overall, where can we improve?", "answer": ""},
    {"question": "Overall, which aspects did you like?", "answer": ""},
    {
      "question":
          "Any other comments? (Feel free to say anything on your mind)",
      "answer": ""
    },
  ];

  List get questionAnswersList => _questionAnswers;

  void selectSelection(int questionIndex, int ratingIndex) {
    for (var i = 0;
        i < (_questionAnswers[questionIndex]["selection"] as List).length;
        i++) {
      _questionAnswers[questionIndex]["selection"][i] = false;
    }
    _questionAnswers[questionIndex]["selection"][ratingIndex] = true;
    notifyListeners();
  }

  void updateAnswer(String str, int questionIndex) {
    _questionAnswers[questionIndex]["answer"] = str;
    notifyListeners();
  }

  void submitToFirebase({bool isEditing = false}) async {
    _showError = false;
    notifyListeners();
    List sortedData = [];
    _questionAnswers.forEach((element) {
      if (element["selection"] != null) {
        int index = (element["selection"] as List)
            .indexWhere((data) => (data as bool) == true);
        if (index == -1) {
          _showError = true;
          notifyListeners();
        } else {
          sortedData.add({
            "question": element["question"],
            "ratings": element["ratings"][(element["selection"] as List)
                .indexWhere((data) => (data as bool) == true)],
          });
        }
      } else {
        sortedData.add({
          "question": element["question"],
          "answer": element["answer"],
        });
      }
    });
    if (_showError == false) {
      _isLoading = true;
      notifyListeners();
      if (sharedPrefs.getFeedback == null) {
        await FirebaseFirestore.instance
            .collection("feedbacks")
            .doc("${sharedPrefs.userid}_1")
            .set({
          "userId": sharedPrefs.userid,
          "dateOfSubmit": Timestamp.now(),
          "userName": sharedPrefs.userName,
          "userRevies": sortedData
        });
        sharedPrefs.setFeedback = jsonEncode({
          "userId": sharedPrefs.userid,
          "dateOfSubmit": DateTime.now().toString(),
          "count": 1,
          "userName": sharedPrefs.userName,
          "userRevies": sortedData
        });
        print(sharedPrefs.getFeedback);
      } else {
        Map<String, dynamic> feedback = jsonDecode(sharedPrefs.getFeedback);
        print(feedback);
        if (isEditing != false) {
          await FirebaseFirestore.instance
              .collection("feedbacks")
              .doc("${sharedPrefs.userid}_${feedback["count"]}")
              .set({
            "userId": sharedPrefs.userid,
            "dateOfSubmit": DateTime.now().toString(),
            "userName": sharedPrefs.userName,
            "userRevies": sortedData
          });
          sharedPrefs.setFeedback = jsonEncode({
            "userId": sharedPrefs.userid,
            "dateOfSubmit": DateTime.now().toString(),
            "count": feedback["count"],
            "userName": sharedPrefs.userName,
            "userRevies": sortedData
          });
        } else {
          if (DateTime.now().hour -
                  DateTime.parse(feedback["dateOfSubmit"]).hour >=
              24)
            await FirebaseFirestore.instance
                .collection("feedbacks")
                .doc("${sharedPrefs.userid}_${feedback["count"] + 1}")
                .set({
              "userId": sharedPrefs.userid,
              "dateOfSubmit": DateTime.now().toString(),
              "userName": sharedPrefs.userName,
              "userRevies": sortedData
            });
          sharedPrefs.setFeedback = jsonEncode({
            "userId": sharedPrefs.userid,
            "dateOfSubmit": DateTime.now().toString(),
            "count": feedback["count"] + 1,
            "userName": sharedPrefs.userName,
            "userRevies": sortedData
          });
        }

        print(sharedPrefs.getFeedback);
      }

      _isLoading = false;
      _isSubmitted = true;
      notifyListeners();
    }
  }

  void resetData() {
    _isSubmitted = false;
    _isLoading = false;
    _showError = false;
    for (var i = 0; i < _questionAnswers.length; i++) {
      if ((_questionAnswers[i] as Map).containsKey("selection")) {
        for (var j = 0;
            j < (_questionAnswers[i]["selection"] as List).length;
            j++) {
          _questionAnswers[i]["selection"][j] = false;
        }
      } else {
        _questionAnswers[i]["answer"] = "";
      }
    }
  }

  void editFeedback() {
    if (sharedPrefs.getFeedback != null) {
      Map<String, dynamic> feedback = jsonDecode(sharedPrefs.getFeedback);
      (feedback["userRevies"] as List).forEach((element) {
        if (element.containsKey("ratings")) {
          _questionAnswers.forEach((data) {
            print("here");
            if (data["question"] == element["question"]) {
              (data["selection"] as List)[(data["ratings"] as List)
                  .indexWhere((ele) => ele == element["ratings"])] = true;
            }
          });
        }
        if (element.containsKey("answer")) {
          _questionAnswers[_questionAnswers.indexWhere(
                  (data) => data["question"] == element["question"])]
              ["answer"] = element["answer"];

          // print(_questionAnswers[_questionAnswers.indexWhere(
          //     (data) => data["question"] == element["question"])]["answer"]);
        }
      });
    }
    print(_questionAnswers);
    notifyListeners();
  }
}
