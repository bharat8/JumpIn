import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/features/interests/interest_page_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class InterestPage extends StatefulWidget {
  final String source;
  InterestPage({this.source});
  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  final scrollDirection = Axis.horizontal;

  ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final interestProvider =
        Provider.of<InterestPageProvider>(context, listen: false);
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    // print(arguments["interests"]);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          bottomNavigationBar: GestureDetector(
            onTap: () {
              interestProvider.checkMinimumInterestsSelected(
                  context, widget.source);
            },
            child: Container(
              width: size.width,
              height: size.height * 0.07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.blue[900], Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Text("DONE",
                  style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontSize: size.height * 0.025,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          body: FutureBuilder<bool>(
              future: widget.source != "filter"
                  ? interestProvider.fetchInterests()
                  : interestProvider.selectInterestListFromFilters(
                      arguments["interests"] as List<String>),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return circularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return circularProgressIndicator();
                }
                return InterestsData(
                  size: size,
                  widget: widget,
                  scrollDirection: scrollDirection,
                  scrollController: _scrollController,
                  interestProvider: interestProvider,
                );
              })),
    );
  }
}

class InterestsData extends StatelessWidget {
  const InterestsData({
    Key key,
    @required this.size,
    @required this.widget,
    @required this.scrollDirection,
    @required ItemScrollController scrollController,
    @required this.interestProvider,
  })  : _scrollController = scrollController,
        super(key: key);

  final Size size;
  final InterestPage widget;
  final Axis scrollDirection;
  final ItemScrollController _scrollController;
  final InterestPageProvider interestProvider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.fromLTRB(
            size.width * 0.03, size.height * 0.01, size.width * 0.03, 0),
        child: Container(
          // color: Colors.black12,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (widget.source != "profile" && widget.source != "filter")
                      Container(
                        height: constraints.maxHeight * 0.05,
                        width: constraints.maxWidth,
                        padding: EdgeInsets.symmetric(
                            vertical: constraints.maxHeight * 0.013),
                        // color: Colors.black12,
                        child: Image.asset(
                          'assets/images/Onboarding/onboardingProgress2.png',
                        ),
                      ),
                    Container(
                      width: constraints.maxWidth,
                      height: widget.source == "filter"
                          ? constraints.maxHeight * 0.07
                          : constraints.maxHeight * 0.12,
                      // color: Colors.black26,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: Text(
                              "Choose Your Interests",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      (constraints.maxHeight * 0.05) * 0.5),
                            ),
                          ),
                          Text(
                            "Select interests and then sub-interests",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize:
                                    (constraints.maxHeight * 0.04) * 0.52),
                          ),
                          if (widget.source != "filter")
                            Consumer<InterestPageProvider>(
                                builder: (context, prov, child) {
                              return Text(
                                " Select minimum 5 Sub-Interests",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        (constraints.maxHeight * 0.03) * 0.7),
                              );
                            }),
                        ],
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.22,
                      // color: Colors.black38,
                      child: ScrollablePositionedList.builder(
                        scrollDirection: scrollDirection,
                        itemScrollController: _scrollController,
                        itemCount: interestProvider.getCategories.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Consumer<InterestPageProvider>(
                              builder: (context, interestListProv, child) {
                            return Neumorphic(
                                margin: EdgeInsets.fromLTRB(
                                    constraints.maxWidth * 0.03,
                                    constraints.maxHeight * 0.03,
                                    constraints.maxWidth * 0.06,
                                    constraints.maxHeight * 0.03),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(12)),
                                    depth: interestListProv.getCategories.values
                                                .elementAt(index) ==
                                            false
                                        ? 7
                                        : -8,
                                    surfaceIntensity: 0.1,
                                    lightSource: interestListProv
                                                .getCategories.values
                                                .elementAt(index) ==
                                            false
                                        ? LightSource.top
                                        : LightSource.topLeft,
                                    intensity: 0.9,
                                    color: interestListProv.getCategories.values
                                                .elementAt(index) ==
                                            false
                                        ? Colors.white
                                        : Colors.blue[700]),
                                child: InkWell(
                                  onTap: () =>
                                      interestListProv.selectedCategory(
                                          interestListProv.getCategories.keys
                                              .elementAt(index) as String),
                                  onLongPress: () async {
                                    await interestListProv.deSelectedCategory(
                                        interestListProv.getCategories.keys
                                            .elementAt(index) as String,
                                        _scrollController);
                                  },
                                  child: Container(
                                    width: constraints.maxWidth * 0.3,
                                    height: (constraints.maxHeight * 0.2) * 0.8,
                                    // color: Colors.black12,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            constraints.maxWidth * 0.02),
                                    child: Center(
                                      child: Text(
                                        (interestProvider.getCategories.keys
                                                .elementAt(index) as String)
                                            .split(" ")
                                            .join("\n"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: size.height * 0.018,
                                            fontWeight: FontWeight.w600,
                                            color: interestListProv
                                                        .getCategories.values
                                                        .elementAt(index) ==
                                                    false
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                    ),
                                  ),
                                ));
                          });
                        },
                      ),
                    ),
                    Consumer<InterestPageProvider>(
                      builder: (context, subInterestProv, child) {
                        return subInterestProv.getCategories[
                                    subInterestProv.getSelectedCategory] ==
                                true
                            ? GridView.builder(
                                itemCount: (subInterestProv.getSubCategories[
                                            subInterestProv.getSelectedCategory]
                                        as Map)
                                    .length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () => subInterestProv
                                            .selectSubCategory((subInterestProv
                                                            .getSubCategories[
                                                        subInterestProv
                                                            .getSelectedCategory]
                                                    as Map)
                                                .keys
                                                .elementAt(index) as String),
                                        child: Container(
                                          width: constraints.maxWidth / 3,
                                          height: constraints.maxHeight / 3,
                                          margin: EdgeInsets.all(
                                              constraints.maxHeight * 0.012),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2000),
                                              image: DecorationImage(
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black26,
                                                      BlendMode.colorBurn),
                                                  image: AssetImage(
                                                    (subInterestProv.getSubCategories[
                                                                subInterestProv
                                                                    .getSelectedCategory]
                                                            as Map)
                                                        .values
                                                        .elementAt(
                                                            index)[1] as String,
                                                  ),
                                                  fit: BoxFit.cover)),
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2000),
                                            child: Container(
                                              color: (subInterestProv.getSubCategories[
                                                                  subInterestProv
                                                                      .getSelectedCategory]
                                                              as Map)
                                                          .values
                                                          .elementAt(
                                                              index)[0] ==
                                                      true
                                                  ? Colors.transparent
                                                  : Colors.white30,
                                              width: constraints.maxWidth / 3,
                                              height: constraints.maxHeight / 3,
                                              alignment: Alignment.center,
                                              child: Text(
                                                (subInterestProv.getSubCategories[
                                                            subInterestProv
                                                                .getSelectedCategory]
                                                        as Map)
                                                    .keys
                                                    .elementAt(index) as String,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.height * 0.02,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if ((subInterestProv.getSubCategories[
                                                      subInterestProv
                                                          .getSelectedCategory]
                                                  as Map)
                                              .values
                                              .elementAt(index)[0] ==
                                          true)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              margin: EdgeInsets.only(
                                                  top: 10, right: 12),
                                              child: Image.asset(
                                                  "assets/images/Onboarding/checked.png")),
                                        ),
                                    ],
                                  );
                                })
                            : Container(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight * 0.63,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.2),
                                  child: Column(
                                    children: [
                                      Icon(Icons.assistant,
                                          color: Colors.black.withOpacity(0.7)),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.03),
                                        child: Text(
                                          "Select an interest and then sub-interests",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.015),
                                        child: Text(
                                          "(Long press an interest to deselect)",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
