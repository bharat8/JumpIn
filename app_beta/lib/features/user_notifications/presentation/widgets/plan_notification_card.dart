import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class PlanNotificationCard extends StatelessWidget {
  const PlanNotificationCard({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Container(
          height: size.height * 0.19,
          width: size.width * 0.7775,
          child: Container(
            color: Colors.grey[300],
            child: Container(
              margin: EdgeInsets.all(7),
              child: Column(
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'TrebuchetMS'),
                          children: [
                        TextSpan(
                            text: "@Somal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsJumpin.kSecondaryColor)),
                        TextSpan(
                            text: " has invited",
                            style:
                                TextStyle(color: ColorsJumpin.kSecondaryColor)),
                        TextSpan(
                            text: " you",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsJumpin.kSecondaryColor)),
                        TextSpan(
                            text: " to plan",
                            style:
                                TextStyle(color: ColorsJumpin.kSecondaryColor)),
                        TextSpan(
                            text: " ScubaDiving",
                            style: TextStyle(
                                color: ColorsJumpin.kSecondaryColor,
                                fontWeight: FontWeight.bold))
                      ])),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.circle, color: Colors.red, size: 10),
                        Text(
                          '10 hours ago',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.all(3),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          onPressed: () {},
                          child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Accept',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: "TrebuchetMS",
                                          fontSize: 5)),
                                  Text('JUMPIN',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: "TrebuchetMS",
                                          fontSize: 12)),
                                ],
                              )),
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text('DENY',
                                style: TextStyle(fontFamily: font1)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.19,
          width: size.width * 0.2,
          child: Container(
              decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Onboarding/plan1.jpeg'),
              fit: BoxFit.fill,
            ),
          )),
        ),
      ]),
    );
  }
}
