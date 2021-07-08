import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  bool get okToNavigateFromOTP =>
      _sharedPrefs.getBool(keyOkToNavigateFromOTP) ?? false;

  set okToNavigateFromOTP(bool value) {
    _sharedPrefs.setBool(keyOkToNavigateFromOTP, value);
  }

  bool get okToNavigateFromInterest =>
      _sharedPrefs.getBool(keyOkToNavigateFromInterest) ?? false;

  set okToNavigateFromInterest(bool value) {
    _sharedPrefs.setBool(keyOkToNavigateFromInterest, value);
  }

  bool get okToNavigateFromOnboardingUser =>
      _sharedPrefs.getBool(keyOkToNavigateFromOnboardingUser) ?? false;

  set okToNavigateFromOnboardingUser(bool value) {
    _sharedPrefs.setBool(keyOkToNavigateFromOnboardingUser, value);
  }

  bool get isSignedUp => _sharedPrefs.getBool(keySignedUp) ?? false;
  set isSignedUp(bool value) {
    _sharedPrefs.setBool(keySignedUp, value);
  }

  bool get isGoogleSignedUp => _sharedPrefs.getBool(keyGoogleSignedUp) ?? false;
  set isGoogleSignedUp(bool value) {
    _sharedPrefs.setBool(keyGoogleSignedUp, value);
  }

  bool get isLoggedIn => _sharedPrefs.getBool(keyLoggedIn) ?? false;
  set isLoggedIn(bool value) {
    _sharedPrefs.setBool(keyLoggedIn, value);
  }

  String get phoneNo => _sharedPrefs.getString(keyPhoneNo) ?? "";
  set phoneNo(String value) {
    _sharedPrefs.setString(keyPhoneNo, value);
  }

  String get photoUrl => _sharedPrefs.getString(keyPhotoUrl) ?? "";
  set photoUrl(String value) {
    _sharedPrefs.setString(keyPhotoUrl, value);
  }

  String get gender => _sharedPrefs.getString(keyGender) ?? "";
  set gender(String value) {
    _sharedPrefs.setString(keyGender, value);
  }

  String get userid => _sharedPrefs.getString(keyId) ?? "";
  set userid(String value) {
    _sharedPrefs.setString(keyId, value);
  }

  String get fcmToken => _sharedPrefs.getString(keyFcmToken) ?? "";
  set fcmToken(String value) {
    _sharedPrefs.setString(keyFcmToken, value);
  }

  String get fullname => _sharedPrefs.getString(keyFullName) ?? "";
  set fullname(String value) {
    _sharedPrefs.setString(keyFullName, value);
  }

  String get userName => _sharedPrefs.getString(keyUserName) ?? "";
  set userName(String value) {
    _sharedPrefs.setString(keyUserName, value);
  }

  String get email => _sharedPrefs.getString(keyEmail) ?? "";
  set email(String value) {
    _sharedPrefs.setString(keyEmail, value);
  }

  int get dobYear => _sharedPrefs.getInt(keydobYear) ?? 0;
  set dobYear(int value) {
    _sharedPrefs.setInt(keydobYear, value);
  }

  int get dobMonth => _sharedPrefs.getInt(keydobMonth) ?? 0;
  set dobMonth(int value) {
    _sharedPrefs.setInt(keydobMonth, value);
  }

  int get myNoOfConnections => _sharedPrefs.getInt(keymyConnectionsNo) ?? 0;
  set myNoOfConnections(int value) {
    _sharedPrefs.setInt(keymyConnectionsNo, value);
  }

  int get myNoOfConnectionRequests =>
      _sharedPrefs.getInt(keymyConnectionRequestsNo) ?? 0;
  set myNoOfConnectionRequests(int value) {
    _sharedPrefs.setInt(keymyConnectionRequestsNo, value);
  }

  String get myInterests => _sharedPrefs.getString(keyMyinterests) ?? "";
  set myInterests(String value) {
    _sharedPrefs.setString(keyMyinterests, value);
  }

  String get myLatitude => _sharedPrefs.getString(keyMyLattitude) ?? "0.0";
  set myLatitude(String value) {
    _sharedPrefs.setString(keyMyLattitude, value);
  }

  String get myLongitude => _sharedPrefs.getString(keyMyLongitude) ?? "0.0";
  set myLongitude(String value) {
    _sharedPrefs.setString(keyMyLongitude, value);
  }

  int get myNotificationCount =>
      _sharedPrefs.getInt(keyNotificationCounter) ?? 0;
  set myNotificationCount(int value) {
    _sharedPrefs.setInt(keyNotificationCounter, value);
  }

  int get myChatCount => _sharedPrefs.getInt(keyChatMsgCounter) ?? 0;
  set myChatCount(int value) {
    _sharedPrefs.setInt(keyChatMsgCounter, value);
  }

  int get dobDay => _sharedPrefs.getInt(keydobDay) ?? 0;
  set dobDay(int value) {
    _sharedPrefs.setInt(keydobDay, value);
  }

  String get myConnectionListasString =>
      _sharedPrefs.getString(keymyConnectionListasString);
  set myConnectionListasString(String value) =>
      _sharedPrefs.setString(keymyConnectionListasString, value);

  int get myPendingNotification => _sharedPrefs.getInt(keyPendingNotification);
  set myPendingNotification(int value) =>
      _sharedPrefs.setInt(keyPendingNotification, value);
  String get myPendingConnectionListasString =>
      _sharedPrefs.getString(keymyPendingConnectionListasString);
  set myPendingConnectionListasString(String value) =>
      _sharedPrefs.setString(keymyPendingConnectionListasString, value);

  bool get isFacebookLoggedIn => _sharedPrefs.getBool(keyIsFacebookLoggedIn);
  set isFacebookLoggedIn(bool value) =>
      _sharedPrefs.setBool(keyIsFacebookLoggedIn, value);

  bool get isOnboardingSeen => _sharedPrefs.getBool(keyOnboardingSeen);
  set isOnboardingSeen(bool value) =>
      _sharedPrefs.setBool(keyOnboardingSeen, value);

  String get getFeedback => _sharedPrefs.getString(keyFeedback);
  set setFeedback(String value) => _sharedPrefs.setString(keyFeedback, value);

  String get getVibeWithPeopleList =>
      _sharedPrefs.getString(keyVibeWithPeopleList);
  set setVibeWithPeopleList(String value) =>
      _sharedPrefs.setString(keyVibeWithPeopleList, value);

  String get getMutualFriends => _sharedPrefs.getString(keyMutualFriends);
  set setMutualFriends(String value) =>
      _sharedPrefs.setString(keyMutualFriends, value);

  int get appOpenCount => _sharedPrefs.getInt(keyAppOpenCount);
  set appOpenCount(int value) => _sharedPrefs.setInt(keyAppOpenCount, value);

  String get appOpenLastTime => _sharedPrefs.getString(keyAppOpenLastTime);
  set appOpenLastTime(String value) =>
      _sharedPrefs.setString(keyAppOpenLastTime, value);

  String get savedLocationCity => _sharedPrefs.getString(keySavedLocationCity);
  set savedLocationCity(String value) =>
      _sharedPrefs.setString(keySavedLocationCity, value);

  String get savedLocation => _sharedPrefs.getString(keySavedLocation);
  set savedLocation(String value) =>
      _sharedPrefs.setString(keySavedLocation, value);
}

final sharedPrefs = SharedPrefs();
const String keyOkToNavigateFromOTP = "ok_to_navigate_from_OTP";
const String keyOkToNavigateFromInterest = "ok_to_navigate_from_interest";
const String keyOkToNavigateFromOnboardingUser =
    "ok_to_navigate_from_onboarding_user";
const String keySignedUp = "signed_up";
const String keyGoogleSignedUp = "google_signed_up";
const String keyLoggedIn = "logged_in";
const String keyPhoneNo = "key_phoneNo";
const String keyPhotoUrl = "key_photoUrl";
const String keyEmail = "key_email";
const String keyId = "key_userId";
const String keyFcmToken = "key_fcmToken";
const String keyFullName = "key_fullname";
const String keyUserName = "key_userName";
const String keyGender = "key_gender";
const String keydobYear = "key_dobYear";
const String keydobMonth = "key_dobMonth";
const String keydobDay = "key_dobDay";
const String keymyConnectionsNo = "key_myConnections";
const String keymyConnectionRequestsNo = "key_myConnectionRequest";
const String keymyConnectionListasString = "key_myConnectionListString";
const String keymyPendingConnectionListasString =
    "key_myPendingConnectionListString";

const String keyMyLongitude = "key_MyLongitude";
const String keyMyLattitude = "key_MyLattitude";
const String keyNotificationCounter = "key_NotificationCouner";
const String keyChatMsgCounter = "key_chatMsgCounter";
const String keyPendingNotification = "key_pendingNotification";
const String keyMyinterests = "keyMyinterests";
const String keyIsFacebookLoggedIn = "key_isFacebookLoggedIn";
const String keyOnboardingSeen = "key_isOnboardingSeen";
const String keyFeedback = "key_feedback";
const String keyVibeWithPeopleList = "key_vibeWithPeople";
const String keyMutualFriends = "key_mutualFriends";
const String keyAppOpenCount = "key_AppOpenCount";
const String keyAppOpenLastTime = "key_AppOpenLastTime";
const String keySavedLocationCity = "key_savedLocationCity";
const String keySavedLocation = "key_savedLocation";
