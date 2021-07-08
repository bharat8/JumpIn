import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class EventNameNLocation extends StatelessWidget {
  const EventNameNLocation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Scuba Diving Camp'.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: font2,
                    fontWeight: FontWeight.bold,
                    color: ColorsJumpin.kPrimaryColor,
                    fontSize: SizeConfig.blockSizeHorizontal * 4)),
          ),
          Row(
            children: [
              const ImageIcon(
                  AssetImage('assets/images/Home/location_icon.png')),
              Text(
                'Puducherry, 1000kms',
                style: TextStyle(fontFamily: font1),
              )
            ],
          )
        ],
      ),
    );
  }
}
