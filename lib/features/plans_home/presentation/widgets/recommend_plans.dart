import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class RecommendButton extends StatelessWidget {
  const RecommendButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: ColorsJumpin.kSecondaryColor,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: GestureDetector(
              onTap: () {
                //print("recommend tapped");
                // urlFileShare(context, user.photoUrl, user.fullname);
                // Share.share(
                //     "You know that I have great taste, and I have a feeling that you and ${user.fullname} will vibe very well.(Thank me later) \n Use this link to connect on JUMPIN - the app that discovers interest twins near you. \n www.jumpin.co.in");
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageIcon(
                        const AssetImage('assets/images/Home/refer_icon.png'),
                        size: SizeConfig.blockSizeHorizontal * 8),
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
                      child: Text('Recommend',
                          style: TextStyle(
                              fontFamily: 'TrebuchetMS',
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeHorizontal * 3)),
                    )
                  ]))),
    );
  }
}
