import 'package:JumpIn/features/interests/interest_page.dart';
import 'package:JumpIn/features/on_boarding_user_profile/onboarding_user_profile.dart';
import 'package:JumpIn/features/onboarding_screens/presentation/screens/onboarding_screen.dart';
import 'package:JumpIn/features/people_home/presentation/screen_people_home.dart';
import 'package:JumpIn/features/people_profile/presentation/screens/people_profile.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/create_private_plan.dart';
import 'package:JumpIn/features/plans_home/presentation/create_plans/create_public_plan_profile.dart';
import 'package:JumpIn/features/plans_home/presentation/plans_home.dart';
import 'package:JumpIn/features/search_users_and_plans/presentation/screens/search_screen.dart';
import 'package:JumpIn/features/splash.dart';
import 'package:JumpIn/features/user_chats/presentation/widgets/tab_navigator.dart';
import 'package:JumpIn/features/user_notifications/presentation/screens/notifications.dart';
import 'package:JumpIn/features/user_profile/presentation/screens/edit_user_profile.dart';
import 'package:JumpIn/features/user_profile/presentation/screens/user_profile.dart';
import 'package:JumpIn/features/user_signup/presentation/phone_verification.dart';
import 'package:JumpIn/features/user_signup/presentation/social_auth.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/jumpin_rate_us.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/jumpin_settings.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/screen_user_connections.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/user_bookmarks.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/user_linking_accounts.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/user_plan_Invites.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/user_plans.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/user_requests.dart';
import 'package:JumpIn/features/user_utilities/presentation/screen/screen_user_location.dart';

import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_placeholder.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rSplash:
        return MaterialPageRoute(builder: (context) => SplashScreenJumpin());
      case rSocialAuth:
        return MaterialPageRoute(builder: (context) => ScreenSocialAuth());
      case rPhoneVerification:
        return MaterialPageRoute(builder: (context) => PhoneVerification());
      case rOnboardingInterests:
        return MaterialPageRoute(builder: (context) => InterestPage());
      case rOnboardingUser:
        List<String> userInterests = settings.arguments as List<String>;
        return MaterialPageRoute(
            builder: (context) =>
                OnboardingUserProfile(userInterests: userInterests));
      case rMyBookmarks:
        return MaterialPageRoute(builder: (context) => ScreenMyBookmarks());
      case rPeopleHome:
        return MaterialPageRoute(builder: (context) => ScreenPeopleHome());
      case rPlanHome:
        return MaterialPageRoute(builder: (context) => ScreenPlansHome());
      case rUserProfile:
        return MaterialPageRoute(builder: (context) => ScreenUserProfile());
      case rEditUserProfile:
        return MaterialPageRoute(builder: (context) => ScreenEditUserProfile());
      case rCreatePublicPlan:
        return MaterialPageRoute(
            builder: (context) => ScreenCreatePublicPlanProfile());
      case rCreatePrivatePlan:
        return MaterialPageRoute(
            builder: (context) => ScreenCreatePrivatePlanProfile());
      case rLinkingAccounts:
        return MaterialPageRoute(builder: (context) => LinkingAccounts());
      case rSearch:
        return MaterialPageRoute(builder: (context) => SearchScreen());
      case rSettings:
        return MaterialPageRoute(builder: (context) => JumpInSettings());
      case rMyLocation:
        return MaterialPageRoute(builder: (context) => ScreenUserLocation());
      case rMyConnections:
        return MaterialPageRoute(builder: (context) => ScreenUserConnections());
      case rMyPlans:
        return MaterialPageRoute(builder: (context) => MyPlans());
      case rNotification:
        return MaterialPageRoute(
            builder: (context) => ScreenJumpinNotifications());
      case rMyPlanInvites:
        return MaterialPageRoute(builder: (context) => MyPlanInvites());
      case rMyPeopleReq:
        return MaterialPageRoute(builder: (context) => ScreenMyPeopleReqReq());
      case rListOfChat:
        return MaterialPageRoute(builder: (context) => TabNavigator());
      case rHomePlaceHolder:
        return MaterialPageRoute(builder: (context) => HomePlaceHolder());
      case rPeopleProfile:
        List<String> arguments = settings.arguments as List<String>;
        return MaterialPageRoute(
          builder: (context) =>
              ScreenPeopleProfile(userid: arguments[0], source: arguments[1]),
        );
      case rOnboardingScreen:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      case rRateUs:
        return MaterialPageRoute(builder: (context) => JumpinRateUs());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('No routing found'),
                  ),
                ));
    }
  }
}
