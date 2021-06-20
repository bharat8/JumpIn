import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Swiper imageSlider(BuildContext context, List<String> images) {
  return Swiper(
    pagination: SwiperControl(
        iconPrevious: const Icon(Icons.navigate_before,
                color: ColorsJumpin.kSecondaryColor)
            .icon,
        iconNext: const Icon(
          Icons.navigate_next,
          color: ColorsJumpin.kSecondaryColor,
        ).icon),
    itemBuilder: (BuildContext context, int index) {
      return CircleAvatar(
        radius: getScreenSize(context).height * 0.058,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2000),
          child: CachedNetworkImage(
            imageUrl: images[index],
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
      );
    },
    itemCount: images.length,
    scale: 0.9,
  );
}
