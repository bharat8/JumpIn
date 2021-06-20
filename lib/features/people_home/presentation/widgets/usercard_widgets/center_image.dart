import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CenterImage extends StatelessWidget {
  const CenterImage({
    Key key,
    @required this.user,
  }) : super(key: key);

  final JumpinUser user;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: getScreenSize(context).height * 0.08,
                backgroundImage: AssetImage(
                    'assets/images/Home/people_background_blue_shades.png'),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: getScreenSize(context).height * 0.058,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2000),
                  child: CachedNetworkImage(
                    imageUrl: user.photoUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => SpinKitThreeBounce(
                      size: getScreenSize(context).height * 0.03,
                      color: Colors.white,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
