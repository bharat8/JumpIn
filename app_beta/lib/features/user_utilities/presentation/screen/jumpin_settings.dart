import 'dart:io';

import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JumpInSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JumpinAppBar(context, 'Settings'),
      drawer: const JumpinNavDrawer(),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => WebView(
                    "https://drive.google.com/file/d/1rwCjF3SlGcLJ6JlgnbrrZ51gt6KGVgkO/view?usp=sharing",
                    "JumpIn Privacy Policy"))),
            child: ListTile(
                leading: const Icon(
                  Icons.policy,
                  color: ColorsJumpin.kPrimaryColor,
                ),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(fontFamily: font1),
                ),
                subtitle: const Text("Read the company's Privacy Policy"),
                trailing: const Icon(Icons.arrow_right_alt_rounded)),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => WebView(
                    "https://drive.google.com/file/d/1dKsDCDmE6Wrv5Rmd-xxUTbOQR1JB1z8q/view?usp=sharing",
                    "JumpIn Terms of Use"))),
            child: ListTile(
                leading: const Icon(
                  Icons.privacy_tip,
                  color: ColorsJumpin.kPrimaryColor,
                ),
                subtitle: const Text('Read the terms of use'),
                title: Text(
                  'Terms of Use',
                  style: TextStyle(fontFamily: font1),
                ),
                trailing: const Icon(Icons.arrow_right_alt_rounded)),
          ),
        ],
      ),
    );
  }
}
