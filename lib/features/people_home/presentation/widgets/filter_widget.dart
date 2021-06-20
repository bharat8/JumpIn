import 'package:JumpIn/features/interests/interest_page.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  void initState() {
    final prov = Provider.of<ServiceJumpinPeopleHome>(context, listen: false);
    if (prov.distanceRangeValues == null) {
      prov.distanceRangeValues = RangeValues(0, 5000);
      prov.distanceRangeLabels = RangeLabels(
          "${prov.distanceRangeValues.start.toInt()} kms",
          "${prov.distanceRangeValues.end.toInt()}+ kms");
    }
    if (prov.ageRangeValues == null) {
      prov.ageRangeValues = RangeValues(13, 75);
      prov.ageRangeLabels = RangeLabels(
          "${prov.ageRangeValues.start.toInt()} years",
          "${prov.ageRangeValues.end.toInt()}+ years");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
            width: size.width * 0.9,
            height: size.height * 0.8,
            color: Colors.white,
            padding: EdgeInsets.all(size.height * 0.02),
            child: LayoutBuilder(builder: (context, size) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.maxHeight * 0.05,
                      width: size.maxWidth,
                      // color: Colors.black12,
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.arrow_back_ios_rounded)),
                    ),
                    Container(
                      height: size.maxHeight * 0.07,
                      width: size.maxWidth,
                      // color: Colors.black26,
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text("Select from a wide range of filters",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.maxHeight * 0.032)),
                        ),
                      ),
                    ),
                    Container(
                      height: size.maxHeight * 0.1,
                      width: size.maxWidth,
                      // color: Colors.black12,
                      child: Row(
                        children: [
                          Text("Vibe",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.maxHeight * 0.028)),
                          // Neumo
                          Expanded(
                            child: Container(
                              height: size.maxHeight * 0.1,
                              alignment: Alignment.centerRight,
                              child: Consumer<ServiceJumpinPeopleHome>(
                                  builder: (context, homeProv, child) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: homeProv.vibe.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => homeProv.selectVibeFilter(
                                            homeProv.vibe[index]["name"]
                                                as String),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: size.maxWidth * 0.03),
                                          child: Chip(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      size.maxHeight * 0.017,
                                                  horizontal:
                                                      size.maxWidth * 0.03),
                                              label: Text(
                                                homeProv.vibe[index]["name"]
                                                    as String,
                                                style: TextStyle(
                                                    color: homeProv.vibe[index]
                                                                ["value"] ==
                                                            false
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize:
                                                        size.maxHeight * 0.025,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              shape: StadiumBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Colors.blue[300])),
                                              backgroundColor:
                                                  homeProv.vibe[index]
                                                              ["value"] ==
                                                          false
                                                      ? Colors.transparent
                                                      : Colors.blue[300]),
                                        ),
                                      );
                                    });
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: size.maxHeight * 0.15,
                      width: size.maxWidth,
                      // color: Colors.black26,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Distance (in kms)",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.maxHeight * 0.028)),
                          // Neumo
                          Consumer<ServiceJumpinPeopleHome>(
                              builder: (context, homeProv, child) {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: RangeSlider(
                                onChanged: (RangeValues newRange) =>
                                    homeProv.selectDistanceFilter(newRange),
                                values: homeProv.distanceRangeValues,
                                divisions: 1000,
                                labels: homeProv.distanceRangeLabels,
                                min: 0,
                                max: 5000,
                                activeColor: Colors.blue[300],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      height: size.maxHeight * 0.15,
                      width: size.maxWidth,
                      // color: Colors.black12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Age (in years)",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.maxHeight * 0.028)),
                          // Neumo
                          Consumer<ServiceJumpinPeopleHome>(
                              builder: (context, homeProv, child) {
                            return SliderTheme(
                              data: SliderThemeData(trackHeight: 1),
                              child: RangeSlider(
                                onChanged: (RangeValues newRange) =>
                                    homeProv.selectAgeFilter(newRange),
                                values: homeProv.ageRangeValues,
                                divisions: 15,
                                labels: homeProv.ageRangeLabels,
                                min: 13,
                                max: 75,
                                activeColor: Colors.blue[300],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      height: size.maxHeight * 0.08,
                      width: size.maxWidth,
                      // color: Colors.black26,
                      child: Row(
                        children: [
                          Container(
                            width: size.maxWidth * 0.3,
                            child: Text("Gender",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.maxHeight * 0.028)),
                          ),
                          Expanded(
                            child: Container(
                              height: size.maxHeight * 0.06,
                              alignment: Alignment.centerRight,
                              child: Consumer<ServiceJumpinPeopleHome>(
                                  builder: (context, homeProv, child) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: homeProv.gender.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () =>
                                              homeProv.selectGenderFilter(
                                                  homeProv.gender[index]["name"]
                                                      as String),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.maxWidth * 0.03),
                                              child: ImageIcon(AssetImage(homeProv.gender[index]["image"] as String),
                                                  color: homeProv.gender[index]
                                                              ["value"] ==
                                                          false
                                                      ? Colors.grey
                                                      : Colors.blue[300],
                                                  size:
                                                      size.maxHeight * 0.05)));
                                    });
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<ServiceJumpinPeopleHome>(
                        builder: (context, homeProv, child) {
                      return Container(
                        height: size.maxHeight * 0.23,
                        width: size.maxWidth,
                        // color: Colors.black12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Interests",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.maxHeight * 0.028)),
                                  GestureDetector(
                                    onTap: () async {
                                      final List<String> result =
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) => InterestPage(
                                                        source: "filter",
                                                      ),
                                                  settings: RouteSettings(
                                                      arguments: {
                                                        "interests":
                                                            homeProv.interests
                                                      })));
                                      homeProv.selectInterestsFilter(result);
                                    },
                                    child: Text("Select Interests",
                                        style: TextStyle(
                                            color: Colors.blue[300],
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w400,
                                            fontSize: size.maxHeight * 0.028)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                child: homeProv.interests.isEmpty
                                    ? Container(
                                        width: size.maxWidth,
                                        alignment: Alignment.center,
                                        child: Text("No interests selected",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    size.maxHeight * 0.023)),
                                      )
                                    : Wrap(
                                        alignment: WrapAlignment.start,
                                        runAlignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        direction: Axis.vertical,
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: homeProv.interests
                                            .map((e) => Container(
                                                color: Colors.blue[300],
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          size.maxWidth * 0.02),
                                                      child: Text(e as String,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  size.maxHeight *
                                                                      0.022,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: size.maxWidth *
                                                              0.02),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            homeProv.removeItems(
                                                                homeProv
                                                                    .interests
                                                                    .indexOf(
                                                                        e));
                                                          },
                                                          child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size:
                                                                  size.maxHeight *
                                                                      0.025)),
                                                    )
                                                  ],
                                                )))
                                            .toList()),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("Mutual Friends",
                    //         style: TextStyle(
                    //             color: Colors.black54,
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: size.maxHeight * 0.028)),
                    //     Expanded(
                    //       child: Container(
                    //         height: size.maxHeight * 0.06,
                    //         alignment: Alignment.centerRight,
                    //         child: Consumer<ServiceJumpinPeopleHome>(
                    //             builder: (context, homeProv, child) {
                    //           return ListView.builder(
                    //               shrinkWrap: true,
                    //               scrollDirection: Axis.horizontal,
                    //               itemCount:
                    //                   homeProv.mutualFriendsShow.length,
                    //               itemBuilder: (context, index) {
                    //                 return Padding(
                    //                   padding: EdgeInsets.only(
                    //                       left: size.maxWidth * 0.03),
                    //                   child: GestureDetector(
                    //                       onTap: () => homeProv
                    //                           .selectMutualFriendsFilter(
                    //                               homeProv.mutualFriendsShow[
                    //                                       index]["name"]
                    //                                   as String),
                    //                       child: Container(
                    //                         width: size.maxWidth * 0.25,
                    //                         height: size.maxHeight * 0.06,
                    //                         decoration: BoxDecoration(
                    //                             color:
                    //                                 homeProv.mutualFriendsShow[
                    //                                                 index]
                    //                                             ["value"] ==
                    //                                         false
                    //                                     ? Colors.transparent
                    //                                     : Colors.blue[300],
                    //                             borderRadius:
                    //                                 BorderRadius.circular(5),
                    //                             border: Border.all(
                    //                                 color: Colors.blue[300],
                    //                                 width: 1)),
                    //                         alignment: Alignment.center,
                    //                         child: Text(
                    //                           homeProv.mutualFriendsShow[
                    //                               index]["name"] as String,
                    //                           style: TextStyle(
                    //                               color:
                    //                                   homeProv.mutualFriendsShow[
                    //                                                   index]
                    //                                               ["value"] ==
                    //                                           false
                    //                                       ? Colors.black
                    //                                       : Colors.white,
                    //                               fontSize:
                    //                                   size.maxHeight * 0.025,
                    //                               fontWeight:
                    //                                   FontWeight.w400),
                    //                         ),
                    //                       )),
                    //                 );
                    //               });
                    //         }),
                    //       ),
                    //     ),
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(right: size.maxWidth * 0.03),
                    //       child: Container(
                    //         width: size.maxWidth * 0.25,
                    //         height: size.maxHeight * 0.06,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(5),
                    //             border: Border.all(
                    //                 color: Colors.blue[300], width: 1)),
                    //         alignment: Alignment.center,
                    //         child: Text(
                    //           "Yeah!",
                    //           style: TextStyle(
                    //               color: Colors.black,
                    //               fontSize: size.maxHeight * 0.025,
                    //               fontWeight: FontWeight.w400),
                    //         ),
                    //       ),
                    //     ),
                    // Container(
                    //   width: size.maxWidth * 0.25,
                    //   height: size.maxHeight * 0.06,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(5),
                    //       border: Border.all(
                    //           color: Colors.blue[300], width: 1)),
                    //   alignment: Alignment.center,
                    //   child: Text(
                    //     "Nah!",
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: size.maxHeight * 0.025,
                    //         fontWeight: FontWeight.w400),
                    //   ),
                    // ),
                    //   ],
                    // ),

                    // GestureDetector(
                    //   onTap: () {
                    //     // Navigator.pushNamed(context, rOnboardingInterests);
                    //   },
                    //   child: Text("Select Interests",
                    //       style: TextStyle(
                    //           color: Colors.blue[300],
                    //           decoration: TextDecoration.underline,
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: size.maxHeight * 0.028)),
                    //   ],
                    // ),
                    Container(
                      height: size.maxHeight * 0.08,
                      width: size.maxWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Random",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.maxHeight * 0.028)),
                          Consumer<ServiceJumpinPeopleHome>(
                              builder: (context, homeProv, child) {
                            return CupertinoSwitch(
                              value: homeProv.getRandomSelectionStatus,
                              activeColor: Colors.blue[300],
                              onChanged: (value) {
                                homeProv.setRandomSelectionStatus(value);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      height: size.maxHeight * 0.08,
                      width: size.maxWidth,
                      // color: Colors.black26,
                      child: Consumer<ServiceJumpinPeopleHome>(
                          builder: (context, homeProv, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () => homeProv.resetFiltersData(),
                                child: Text(
                                  "Reset",
                                  style: TextStyle(
                                      color: Colors.red[400],
                                      decoration: TextDecoration.underline,
                                      fontSize: size.maxHeight * 0.03,
                                      fontWeight: FontWeight.w500),
                                )),
                            GestureDetector(
                              onTap: () {
                                // homeProv.finaliseFilters();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: size.maxWidth * 0.25,
                                height: size.maxHeight * 0.06,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.blue[300]),
                                alignment: Alignment.center,
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.maxHeight * 0.025,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    )
                  ]);
            })));
  }
}
