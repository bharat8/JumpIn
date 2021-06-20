import 'package:JumpIn/features/people_profile/domain/people_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'get_image_from_name.dart';

class MutualPeopleMore extends StatelessWidget {
  final List<String> mutualPeople;

  const MutualPeopleMore(this.mutualPeople);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prov =
        Provider.of<ServicePeopleProfileController>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.1,
              // color: Colors.black12,
              child: Row(
                children: [
                  BackButton(),
                  Text("You and @${prov.user.username} both know",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Container(
              width: size.width,
              height: size.height * 0.9 - MediaQuery.of(context).padding.top,
              // color: Colors.black26,
              child: GridView.builder(
                itemCount: mutualPeople.length,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: size.height * 0.02,
                    mainAxisSpacing: size.width * 0.04,
                    childAspectRatio: 1 / 1.5),
                itemBuilder: (context, index) {
                  return Container(
                    width: size.width * 0.02,
                    height: size.width * 0.02,
                    // color: Colors.black12,
                    child: Column(
                      children: [
                        GetImageFromName(
                          name: mutualPeople[index],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: size.height * 0.015),
                          alignment: Alignment.center,
                          child: Text(mutualPeople[index],
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
