import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ColorsJumpin {
  static const kSecondaryColor = Color(0xFF000000);
  static const kPrimaryColor = Color(0xFF0f9ee5);
  static const kPrimaryColorLite = Color(0xffd0f1fa);
  static const innerCardBackgroundGrey = Color(0xfff7f7f7);
  static const kPadding = 2;
  static const interestCategorySelectedColor = Color(0xFFd0f1fa);
  static const interestCategoryUnSelectedColor = Colors.white;
  static const subcategoryBorderColor = Color(0xffd2e1f5);
  static const interestSubCategorySelectedColor = Color(0xffacc7ed);
  static const interestSubCategoryUnselectedColor = Color(0xffe4e4e4);
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;

  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;
  static double bodyHeight;
  static double bodyWidth;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    bodyWidth = _mediaQueryData.size.width;
    bodyHeight = _mediaQueryData.size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    blockSizeHorizontal = bodyWidth / 100;
    blockSizeVertical = bodyHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (bodyWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (bodyHeight - _safeAreaVertical) / 100;
  }
}

bool isLoggedin = false;
String font1 = 'TrebuchetMS';
String font2 = 'SFUIText-Bold';
String font2semibold = 'SFUIText-Semibold';

//Request handling
const String reqReceived = "ReqReceived";
const String reqSent = "ReqSent";
const String neitherReceivednorSent = "neitherReceivednorSent";

const offWhite = Color(0xfff7f7f7);
Size getScreenSize(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return size;
}
