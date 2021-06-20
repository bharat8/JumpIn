import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class UploadANewPhoto extends StatelessWidget {
  const UploadANewPhoto({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: SizeConfig.blockSizeHorizontal * 4),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              'Upload New Photo',
              style: TextStyle(
                  fontFamily: font1,
                  fontSize: SizeConfig.blockSizeHorizontal * 4),
            ),
          )
        ],
      ),
    );
  }
}
