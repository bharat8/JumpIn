import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../domain/service_linking_accounts.dart';

class LinkingAccounts extends StatefulWidget {
  @override
  _LinkingAccountsState createState() => _LinkingAccountsState();
}

class _LinkingAccountsState extends State<LinkingAccounts> {
  @override
  void initState() {
    super.initState();
    final linkingAccountsProv =
        Provider.of<ServiceLinkingAccounts>(context, listen: false);
    bool status = sharedPrefs.isFacebookLoggedIn;
    if (status == null || status == false) {
      linkingAccountsProv.setFacebookLoginStatus = false;
    } else
      linkingAccountsProv.setFacebookLoginStatus = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final linkingAccountsProv = Provider.of<ServiceLinkingAccounts>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: JumpinNavDrawer(),
      appBar: JumpinAppBar(context, 'Link'),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // SizedBox(height: size.height * 0.2),
          Text(
            'Link accounts'.toUpperCase(),
            style: const TextStyle(
                color: ColorsJumpin.kPrimaryColor, fontSize: 30),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          linkingAccountsProv.isFacebookLoggedIn == false
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: GestureDetector(
                    onTap: () =>
                        linkingAccountsProv.initiateFacebookLogin(context),
                    child: linkingAccountsProv.isLoading == false
                        ? Neumorphic(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                                depth: 8,
                                lightSource: LightSource.top,
                                color: ColorsJumpin.kPrimaryColorLite),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.008),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/Onboarding/facebook_logo.png'),
                                      width: SizeConfig.blockSizeHorizontal * 8,
                                      height: SizeConfig.blockSizeVertical * 8,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Continue With Facebook",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  4),
                                    ),
                                  )
                                ],
                              ),
                            ))
                        : circularProgressIndicator(),
                  ))
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Image(
                            image: AssetImage(
                                'assets/images/Onboarding/facebook_logo.png'),
                            width: SizeConfig.blockSizeHorizontal * 8,
                            height: SizeConfig.blockSizeVertical * 8,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Image(
                                image: AssetImage(
                                    'assets/images/Onboarding/correct.png'),
                                width: SizeConfig.blockSizeHorizontal * 4,
                                height: SizeConfig.blockSizeVertical * 4,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: size.width * 0.01),
                              child: Text(
                                "Successfully logged in!",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: size.width * 0.02),
                              child: GestureDetector(
                                onTap: () =>
                                    linkingAccountsProv.unlinkAccount(context),
                                child: Text(
                                  "Unlink",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      color: Colors.red[800].withOpacity(0.8),
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
            child: GestureDetector(
              onTap: () {},
              child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.top,
                      color: ColorsJumpin.kPrimaryColorLite),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.008),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Image(
                            image: AssetImage(
                                'assets/images/Onboarding/instagram_logo.png'),
                            width: SizeConfig.blockSizeHorizontal * 8,
                            height: SizeConfig.blockSizeVertical * 8,
                          ),
                        ),
                        Center(
                          child: Text(
                            "Continue With Instagram",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.8),
                                fontSize: SizeConfig.blockSizeHorizontal * 4),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
