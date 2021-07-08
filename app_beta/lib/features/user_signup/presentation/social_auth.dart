import 'package:JumpIn/features/user_signup/presentation/widgets_signup/auth_screen.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ScreenSocialAuth extends StatefulWidget {
  @override
  _ScreenSocialAuthState createState() => _ScreenSocialAuthState();
}

class _ScreenSocialAuthState extends State<ScreenSocialAuth> {
  ConnectionChecker cc = ConnectionChecker();

  @override
  void initState() {
    cc.checkConnection(context);
    super.initState();
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return authScreen(context);
  }
}
