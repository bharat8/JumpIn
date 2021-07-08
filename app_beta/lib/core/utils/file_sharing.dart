import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

Future<Null> urlFileShare(
    BuildContext context, String userName, String id) async {
  if (Platform.isAndroid) {
    final documentDirectory = (await getExternalStorageDirectory()).path;
    File imgFile = File('$documentDirectory/${id}_image.png');

    Share.shareFiles([imgFile.path],
        subject: 'People Recommendations',
        text:
            "You know that I have great taste, and I have a feeling that you and ${userName} will vibe very well.(Thank me later) \n Use this link( ${await createDynamicLink(id)} ) to connect on JUMPIN  - the app that discovers interest twins near you. \n www.jumpin.co.in");
  } else {
    Share.share(
      'Hello, check your share files!',
      subject: 'URL File Share',
    );
  }
}

Future<String> createDynamicLink(String id) async {
  var parameters = DynamicLinkParameters(
    uriPrefix: 'https://antij.page.link',
    link: Uri.parse('https://antiz.com/share?userId=$id'),
    androidParameters: AndroidParameters(
      packageName: "com.antizero.JumpIn",
    ),
  );
  final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
  final Uri shortUrl = shortDynamicLink.shortUrl;

  return shortUrl.toString();
}
