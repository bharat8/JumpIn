import 'package:JumpIn/core/utils/home_placeholder_provider.dart';
import 'package:JumpIn/core/utils/route_generator.dart';
import 'package:JumpIn/features/interests/interest_page_provider.dart';
import 'package:JumpIn/features/people_home/domain/search_provider.dart';
import 'package:JumpIn/features/people_home/domain/service_jumpin_people_home.dart';
import 'package:JumpIn/features/splash.dart';
import 'package:JumpIn/features/user_notifications/domain/notification_service.dart';
import 'package:JumpIn/features/user_utilities/domain/service_rate_us.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controller/jumpin_request_controller.dart';
import 'controller/notification_controller.dart';
import 'controller/otp_controller.dart';
import 'controller/people_profile_controller.dart';
import 'features/people_profile/domain/people_profile_controller.dart';
import 'features/user_profile/domain/user_profile_controller.dart';
import 'features/user_utilities/domain/service_connections.dart';

import 'core/utils/custom_scroll.dart';
import 'features/user_utilities/domain/service_linking_accounts.dart';
import 'features/on_boarding_user_profile/domain/user_profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(JumpinRequestController());
  Get.put(NotificationController());
  Get.put(PeopleProfileController());
  Get.put(OTPController());
  Get.put(ConnectionController());
  await Firebase.initializeApp();

  await sharedPrefs.init();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  //runApp(App());
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InterestPageProvider>(
          create: (context) => InterestPageProvider(),
        ),
        ChangeNotifierProvider<ServiceLinkingAccounts>(
          create: (context) => ServiceLinkingAccounts(),
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) => UserProfileProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider<ServiceJumpinPeopleHome>(
          create: (context) => ServiceJumpinPeopleHome(),
        ),
        ChangeNotifierProvider<UserProfileController>(
          create: (context) => UserProfileController(),
        ),
        ChangeNotifierProvider<ServicePeopleProfileController>(
          create: (context) => ServicePeopleProfileController(),
        ),
        ChangeNotifierProvider<ServiceRateUs>(
          create: (context) => ServiceRateUs(),
        ),
        ChangeNotifierProvider<HomePlaceHolderProvider>(
          create: (context) => HomePlaceHolderProvider(),
        ),
        ChangeNotifierProvider<NotificationService>(
          create: (context) => NotificationService(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: rSplash,
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: "AirbnbCereal",
              appBarTheme: AppBarTheme(
                  color: Colors.transparent,
                  elevation: 0,
                  brightness: Brightness.light),
              primaryColor: Colors.white),
          title: 'JumpIn',
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: CustomScroll(),
              child: child,
            );
          },
          home: SplashScreenJumpin()),
    );
  }
}
