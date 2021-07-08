import 'dart:convert';

import 'package:JumpIn/features/user_utilities/domain/service_rate_us.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JumpinRateUs extends StatefulWidget {
  @override
  _JumpinRateUsState createState() => _JumpinRateUsState();
}

class _JumpinRateUsState extends State<JumpinRateUs> {
  Map<String, dynamic> _feedback;
  bool _isFirstFeedback;
  bool _is24hoursPassed;
  bool _isEditing;

  @override
  void initState() {
    super.initState();
    print(sharedPrefs.getFeedback);

    if (sharedPrefs.getFeedback != null) {
      _feedback = jsonDecode(sharedPrefs.getFeedback);
      _isFirstFeedback = false;
      if (DateTime.now().hour -
              DateTime.parse(_feedback["dateOfSubmit"]).hour >=
          24) {
        _is24hoursPassed = true;
      } else {
        _is24hoursPassed = false;
      }
    } else {
      _isFirstFeedback = true;
      _is24hoursPassed = false;
    }

    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rateProv = Provider.of<ServiceRateUs>(context);
    return WillPopScope(
      onWillPop: () async {
        rateProv.resetData();
        sharedPrefs.appOpenCount = 0;
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: (((rateProv.getSubmittedStatus == false ||
                        rateProv.getErrorStatus == true) &&
                    (_is24hoursPassed == true || _isFirstFeedback == true))) ||
                _isEditing == true
            ? InkWell(
                onTap: () {
                  if (_isEditing == true)
                    rateProv.submitToFirebase(isEditing: true);
                  else
                    rateProv.submitToFirebase();
                  if (rateProv.getErrorStatus == true) {
                    showError(context, size);
                  }
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: Container(
                  width: size.width,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue[900], Colors.blue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.03),
                    ),
                  ),
                ),
              )
            : null,
        body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.04, horizontal: size.width * 0.06),
            child: ((rateProv.getSubmittedStatus == false ||
                        rateProv.getErrorStatus == true) &&
                    (_is24hoursPassed == true || _isFirstFeedback == true))
                ? rateProv.getLoadingStatus == false
                    ? FeedbackMainWidget(size: size, rateProv: rateProv)
                    : Container(
                        width: size.width,
                        height: size.height * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [circularProgressIndicator()],
                        ),
                      )
                : _isEditing == false
                    ? Container(
                        width: size.width,
                        height: size.height * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: BackButton(
                                  onPressed: () {
                                    rateProv.resetData();
                                    sharedPrefs.appOpenCount = 0;
                                    Navigator.of(context).pop();
                                  },
                                )),
                            Expanded(
                                child: Image.asset(
                                    "assets/images/Home/feedback.jpg")),
                            Container(
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              child: Image.asset(
                                  "assets/images/Onboarding/correct.png"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.height * 0.04),
                              child: Text(
                                "Thank you for your valuable feedback. We will use this feedback to serve you better.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: size.height * 0.025),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.height * 0.04),
                              child: Text(
                                "(You can only submit one feedback per day. However, you can edit the feedback submiited)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    color: Colors.grey[600]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.height * 0.04),
                              child: ElevatedButton(
                                onPressed: () {
                                  rateProv.editFeedback();
                                  setState(() {
                                    _isEditing = true;
                                  });
                                },
                                child: Text(
                                  "Edit Feedback",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : FeedbackMainWidget(size: size, rateProv: rateProv)),
      ),
    );
  }

  void showError(context, size) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: size.height * 0.1,
          width: size.width,
          color: Colors.white,
          alignment: Alignment.center,
          child: Text(
            "Select all answers to feedback questions before proceeding",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red[800],
                fontSize: size.height * 0.023,
                fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}

class FeedbackMainWidget extends StatefulWidget {
  const FeedbackMainWidget({
    Key key,
    @required this.size,
    @required this.rateProv,
  }) : super(key: key);

  final Size size;
  final ServiceRateUs rateProv;

  @override
  _FeedbackMainWidgetState createState() => _FeedbackMainWidgetState();
}

class _FeedbackMainWidgetState extends State<FeedbackMainWidget> {
  List<TextEditingController> _controllers = new List();
  @override
  void dispose() {
    for (TextEditingController c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft, child: BackButton()),
          Text(
            "Jumpin Feedback",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.size.height * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: widget.size.height * 0.02),
            child: Text(
              "This feedback will take only 2 minutes tops. Please be brutally honest, we need real criticism to improve the app",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.size.height * 0.023,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ListView.builder(
              itemCount: widget.rateProv.questionAnswersList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                _controllers.add(new TextEditingController());
                if (widget.rateProv.questionAnswersList[index]["answer"] !=
                    null) {
                  // print(widget.rateProv.questionAnswersList[index]["answer"]);
                  _controllers[index].text =
                      widget.rateProv.questionAnswersList[index]["answer"];
                  print(_controllers[index].text);
                }
                return Padding(
                    padding: EdgeInsets.only(top: widget.size.height * 0.04),
                    child: Container(
                      width: widget.size.width * 0.8,
                      height: (widget.rateProv.questionAnswersList[index]
                                          ["ratings"] !=
                                      null &&
                                  widget
                                          .rateProv
                                          .questionAnswersList[index]["ratings"]
                                          .length ==
                                      2) ||
                              widget.rateProv.questionAnswersList[index]
                                      ["ratings"] ==
                                  null
                          ? widget.size.height * 0.42
                          : widget.size.height * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20)),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              Container(
                                width: constraints.maxWidth,
                                height: (widget.rateProv.questionAnswersList[
                                                    index]["ratings"] !=
                                                null &&
                                            widget
                                                    .rateProv
                                                    .questionAnswersList[index]
                                                        ["ratings"]
                                                    .length ==
                                                2) ||
                                        widget.rateProv
                                                    .questionAnswersList[index]
                                                ["ratings"] ==
                                            null
                                    ? constraints.maxHeight * 0.3
                                    : constraints.maxHeight * 0.2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.1),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Colors.blue[900], Colors.blue],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.rateProv.questionAnswersList[index]
                                      ["question"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.size.height * 0.025,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (widget.rateProv.questionAnswersList[index]
                                      ["ratings"] !=
                                  null)
                                SelectionOptions(
                                  index: index,
                                  constraints: constraints,
                                )
                              else
                                Container(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight * 0.7,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[50],
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: constraints.maxWidth * 0.1,
                                      vertical: constraints.maxHeight * 0.06),
                                  child: TextField(
                                    maxLines: null,
                                    controller: _controllers[index],
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Any comments...",
                                        hintStyle:
                                            TextStyle(color: Colors.black38)),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    onChanged: (value) {
                                      widget.rateProv
                                          .updateAnswer(value, index);
                                    },
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                    ));
              }),
        ],
      ),
    );
  }
}

class SelectionOptions extends StatelessWidget {
  const SelectionOptions({
    Key key,
    @required this.constraints,
    @required this.index,
  }) : super(key: key);

  final BoxConstraints constraints;
  final int index;

  @override
  Widget build(BuildContext context) {
    final rateProv = Provider.of<ServiceRateUs>(context, listen: false);
    return Container(
      width: constraints.maxWidth,
      height: rateProv.questionAnswersList[index]["ratings"] != null &&
              rateProv.questionAnswersList[index]["ratings"].length == 2
          ? constraints.maxHeight * 0.7
          : constraints.maxHeight * 0.8,
      decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
      child: LayoutBuilder(
        builder: (context, constr) {
          return Consumer<ServiceRateUs>(builder: (context, rateProv, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  (rateProv.questionAnswersList[index]["ratings"] as List).map(
                (rating) {
                  int ratingIndex =
                      (rateProv.questionAnswersList[index]["ratings"] as List)
                          .indexOf(rating);
                  return InkWell(
                    onTap: () => rateProv.selectSelection(index, ratingIndex),
                    child: Container(
                      width: constr.maxWidth,
                      height: rateProv.questionAnswersList[index]["ratings"] !=
                                  null &&
                              rateProv.questionAnswersList[index]["ratings"]
                                      .length ==
                                  2
                          ? constr.maxHeight * 0.28
                          : constr.maxHeight * 0.18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                              color: Colors.blue[300],
                              width: constr.maxWidth * 0.004),
                          color: rateProv.questionAnswersList[index]
                                      ["selection"][ratingIndex] ==
                                  false
                              ? Colors.transparent
                              : Colors.green),
                      padding: EdgeInsets.symmetric(
                          horizontal: constr.maxWidth * 0.045),
                      child: Row(
                        children: [
                          Container(
                              width: constr.maxWidth * 0.13,
                              height: constr.maxWidth * 0.13,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: rateProv.questionAnswersList[index]
                                              ["selection"][ratingIndex] ==
                                          false
                                      ? Colors.transparent
                                      : Colors.blueGrey[50],
                                  border: Border.all(
                                      color: rateProv.questionAnswersList[index]
                                                  ["selection"][ratingIndex] ==
                                              false
                                          ? Colors.blue[900]
                                          : Colors.transparent,
                                      width: constr.maxWidth * 0.006)),
                              child: rateProv.questionAnswersList[index]
                                          ["selection"][ratingIndex] ==
                                      false
                                  ? Center(
                                      child: Text(
                                        ratingIndex == 0
                                            ? "A"
                                            : (ratingIndex == 1 ? "B" : "C"),
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w500,
                                            fontSize: rateProv.questionAnswersList[
                                                            index]["ratings"] !=
                                                        null &&
                                                    rateProv
                                                            .questionAnswersList[
                                                                index]
                                                                ["ratings"]
                                                            .length ==
                                                        2
                                                ? constr.maxHeight * 0.1
                                                : constr.maxHeight * 0.06),
                                      ),
                                    )
                                  : Icon(
                                      Icons.done_rounded,
                                      color: Colors.green,
                                      size: rateProv.questionAnswersList[index]
                                                      ["ratings"] !=
                                                  null &&
                                              rateProv
                                                      .questionAnswersList[
                                                          index]["ratings"]
                                                      .length ==
                                                  2
                                          ? constr.maxHeight * 0.14
                                          : constr.maxHeight * 0.08,
                                    )),
                          Padding(
                            padding:
                                EdgeInsets.only(left: constr.maxWidth * 0.03),
                            child: Text(
                              rating,
                              style: TextStyle(
                                  color: rateProv.questionAnswersList[index]
                                              ["selection"][ratingIndex] ==
                                          false
                                      ? Colors.black.withOpacity(0.6)
                                      : Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: rateProv.questionAnswersList[index]
                                                  ["ratings"] !=
                                              null &&
                                          rateProv
                                                  .questionAnswersList[index]
                                                      ["ratings"]
                                                  .length ==
                                              2
                                      ? constr.maxHeight * 0.08
                                      : constr.maxHeight * 0.045),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          });
        },
      ),
    );
  }
}
