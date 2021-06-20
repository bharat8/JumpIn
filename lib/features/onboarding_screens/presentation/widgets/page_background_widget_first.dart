import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class PageBackgroundWidgetFirst {
  PageViewModel buildPageViewModel(Size size, BuildContext context) {
    return PageViewModel(
        titleWidget: Container(),
        decoration: PageDecoration(
            titlePadding: EdgeInsets.zero,
            footerPadding: EdgeInsets.zero,
            contentMargin: EdgeInsets.zero),
        bodyWidget: Container(
          width: size.width,
          height: size.height * 0.9,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: LayoutBuilder(builder: (context, size) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: size.maxWidth,
                      height: size.maxHeight * 0.1,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.maxWidth * 0.02),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: size.maxWidth * 0.04),
                            child: Icon(
                              Icons.menu_rounded,
                              size: size.maxHeight * 0.04,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.maxHeight * 0.035),
                            child: Image.asset(
                                "assets/images/Onboarding/logo_final.png"),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: size.maxWidth * 0.02),
                            child: Text('jumpin'.toUpperCase(),
                                style: TextStyle(
                                    fontFamily: font2,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          Container(
                            height: SizeConfig.blockSizeHorizontal * 6,
                            width: SizeConfig.blockSizeHorizontal * 6,
                            // color: Colors.black12,
                            child: Image.asset(
                              'assets/images/Home/chatIcon1.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: size.maxWidth,
                        height: size.maxHeight * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.maxWidth * 0.8,
                              height: size.maxHeight * 0.7,
                              // color: Colors.black12,
                              child: Column(
                                children: [
                                  Container(
                                    height: size.maxHeight * 0.1,
                                    // color: Colors.black12,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Spacer(),
                                            Text('@shawshank',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorsJumpin
                                                        .kPrimaryColor,
                                                    fontSize: size.maxHeight *
                                                        0.025)),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: size.maxHeight * 0.005),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height:
                                                        size.maxHeight * 0.03,
                                                    child: Image.asset(
                                                      "assets/images/SideNav/placeholder.png",
                                                    ),
                                                  ),
                                                  Text("1080 kms",
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.maxHeight *
                                                                  0.025,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 45,
                                              child:
                                                  LiquidCircularProgressIndicator(
                                                value: 0.85, // Defaults to 0.5.
                                                valueColor:
                                                    AlwaysStoppedAnimation(Colors
                                                            .blue[
                                                        300]), // Defaults to the current Theme's accentColor.
                                                backgroundColor: Colors
                                                    .white, // Defaults to the current Theme's backgroundColor.
                                                borderColor: Colors.blue[300],
                                                borderWidth: 2.0,
                                                direction: Axis
                                                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                                center: Text(
                                                  "85%",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Spacer(),
                                                Text(
                                                  " Vibe",
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .blockSizeHorizontal *
                                                          4,
                                                      color: Colors.black
                                                          .withOpacity(0.8)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    "Meter",
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            3.1,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: size.maxHeight * 0.5,
                                    width: size.maxWidth * 0.8,
                                    decoration: BoxDecoration(
                                        color: Colors.cyan[50].withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding:
                                        EdgeInsets.all(size.maxHeight * 0.03),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          12)),
                                              depth: -10,
                                              surfaceIntensity: 0.5,
                                              lightSource: LightSource.top,
                                              intensity: 1,
                                              color: Colors.cyan[800],
                                            ),
                                            child: Container(
                                              height: getScreenSize(context)
                                                      .height *
                                                  0.15,
                                              width:
                                                  getScreenSize(context).width *
                                                      0.26,
                                              padding: EdgeInsets.all(
                                                  getScreenSize(context)
                                                          .height *
                                                      0.015),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "23 Years",
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    2.9,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.9),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "male"
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    font2semibold,
                                                                fontSize: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    2.9,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.9),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'assets/images/Home/male_blue.png'),
                                                          size: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              8,
                                                          color: Colors.white
                                                              .withOpacity(0.9),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          12)),
                                              depth: -10,
                                              surfaceIntensity: 0.5,
                                              lightSource: LightSource.top,
                                              intensity: 1,
                                              color: Colors.cyan[800],
                                            ),
                                            child: Container(
                                              height: getScreenSize(context)
                                                      .height *
                                                  0.15,
                                              width:
                                                  getScreenSize(context).width *
                                                      0.26,
                                              padding: EdgeInsets.all(
                                                  getScreenSize(context)
                                                          .height *
                                                      0.015),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    flex: 5,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Text(
                                                        "AntiZero Private Limited",
                                                        style: TextStyle(
                                                            fontSize: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                2.8,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'assets/images/Home/work.png'),
                                                          size: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              8,
                                                          color: Colors.white
                                                              .withOpacity(0.9),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          12)),
                                              depth: -10,
                                              surfaceIntensity: 0.5,
                                              lightSource: LightSource.top,
                                              intensity: 1,
                                              color: Colors.cyan[800],
                                            ),
                                            child: Container(
                                              height: getScreenSize(context)
                                                      .height *
                                                  0.15,
                                              width:
                                                  getScreenSize(context).width *
                                                      0.26,
                                              padding: EdgeInsets.all(
                                                  getScreenSize(context)
                                                          .height *
                                                      0.015),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: ImageIcon(
                                                            const AssetImage(
                                                                'assets/images/Home/interest_home.png'),
                                                            size: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                8,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                            "Football\nCricket",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.9),
                                                                fontSize: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    2.9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          12)),
                                              depth: -10,
                                              surfaceIntensity: 0.5,
                                              lightSource: LightSource.top,
                                              intensity: 1,
                                              color: Colors.cyan[800],
                                            ),
                                            child: Container(
                                              height: getScreenSize(context)
                                                      .height *
                                                  0.15,
                                              width:
                                                  getScreenSize(context).width *
                                                      0.26,
                                              padding: EdgeInsets.all(
                                                  getScreenSize(context)
                                                          .height *
                                                      0.015),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: ImageIcon(
                                                            AssetImage(
                                                                'assets/images/Home/mutual_friend.png'),
                                                            size: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                9,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9)),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          '6\nMutual Friends',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.9),
                                                              fontSize: SizeConfig
                                                                      .blockSizeHorizontal *
                                                                  2.9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: CircleAvatar(
                                                    radius:
                                                        getScreenSize(context)
                                                                .height *
                                                            0.08,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/Home/people_background_blue_shades.png'),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: CircleAvatar(
                                                      radius:
                                                          getScreenSize(context)
                                                                  .height *
                                                              0.058,
                                                      backgroundImage: AssetImage(
                                                          "assets/images/Home/profile.jpg")),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: size.maxHeight * 0.1,
                                    width: size.maxWidth * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Neumorphic(
                                          style: NeumorphicStyle(
                                            depth: 10,
                                            intensity: 0.7,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(5)),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                              height: size.maxHeight * 0.06,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.maxWidth * 0.04),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: GestureDetector(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/Onboarding/logo_final.png",
                                                      height: size.maxHeight *
                                                          0.027),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: size.maxWidth *
                                                            0.02),
                                                    child: Text('JumpIn',
                                                        style: TextStyle(
                                                            fontFamily: font1,
                                                            color: Colors.black,
                                                            fontSize:
                                                                size.maxHeight *
                                                                    0.023,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ],
                                              ))),
                                        ),
                                        Neumorphic(
                                          style: NeumorphicStyle(
                                            depth: 10,
                                            intensity: 0.7,
                                            boxShape:
                                                NeumorphicBoxShape.roundRect(
                                                    BorderRadius.circular(5)),
                                            color: Colors.white,
                                          ),
                                          child: Container(
                                              height: size.maxHeight * 0.06,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.maxWidth * 0.04),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: GestureDetector(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ImageIcon(
                                                      const AssetImage(
                                                          'assets/images/Home/refer_icon.png'),
                                                      size: size.maxHeight *
                                                          0.035),
                                                  Text('Recommend',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'TrebuchetMS',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.maxHeight *
                                                                  0.018)),
                                                ],
                                              ))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                      width: size.maxWidth,
                      height: size.maxHeight * 0.1,
                      color: Colors.grey[100],
                      padding: EdgeInsets.symmetric(
                          horizontal: size.maxWidth * 0.04),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: size.maxWidth * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage(
                                      'assets/images/Onboarding/logo_final.png'),
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "JumpIn",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications,
                                size: 25,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.face_sharp,
                                size: 25,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  color: Colors.black26,
                ),
                Positioned(
                  bottom: size.maxHeight * 0.04,
                  left: size.maxWidth * 0.2,
                  child: Container(
                      width: size.maxWidth * 0.6,
                      height: size.maxHeight * 0.15,
                      padding: EdgeInsets.all(size.maxHeight * 0.005),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: size.maxHeight * 0.06,
                                top: size.maxHeight * 0.01),
                            child: Image.asset(
                                "assets/images/Home/bottom-left.png"),
                          ),
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(
                                    top: size.maxHeight * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "connect and begin chatting with your next friend",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: size.maxHeight * 0.02,
                                        fontWeight: FontWeight.w500),
                                  )))
                        ],
                      )),
                ),
                Positioned(
                  right: size.maxWidth * 0.2,
                  bottom: size.maxHeight * 0.22,
                  child: Container(
                      width: size.maxWidth * 0.6,
                      height: size.maxHeight * 0.15,
                      padding: EdgeInsets.all(size.maxHeight * 0.005),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: size.maxHeight * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "be a matchmaker! share jumpin profiles with someone suitable",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: size.maxHeight * 0.02,
                                        fontWeight: FontWeight.w500),
                                  ))),
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.maxHeight * 0.06,
                                bottom: size.maxHeight * 0.01),
                            child:
                                Image.asset("assets/images/Home/top-right.png"),
                          ),
                        ],
                      )),
                )
              ],
            );
          }),
        ));
  }
}
