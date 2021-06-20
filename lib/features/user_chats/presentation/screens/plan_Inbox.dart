import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';

class PlanInbox extends StatefulWidget {
  @override
  _PlanInboxState createState() => _PlanInboxState();
}

class _PlanInboxState extends State<PlanInbox> {
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _displaySnackBar(BuildContext context, String title, Color color) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: const Duration(seconds: 1),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: getScreenSize(context).height * 0.15,
                child: Center(
                  child: Text(
                    'JUMPIN with Plans',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorsJumpin.kPrimaryColor,
                        fontFamily: font2,
                        fontSize: 30),
                  ),
                ),
              ),
              Container(
                height: getScreenSize(context).height * 0.1,
                child: Center(
                  child: Text(
                    'Coming Very Soon...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: font2,
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: getScreenSize(context).height * 0.2,
                color: const Color(0xffCBDDFD),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Join plans nearby for \n activities you love!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: font1,
                          fontSize: 20,
                          color: const Color(0xff6f7dc4)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: getScreenSize(context).height * 0.2,
                color: const Color(0xffcdf2fb),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Easily organize plans with friends \n by letting everyone vote!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: font1,
                          fontSize: 20,
                          color: const Color(0xff30a6c4)),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          thumbsUpSelected = !thumbsUpSelected;
                          if (thumbsUpSelected) {
                            thumbsDownSelected = false;
                            _displaySnackBar(context, "Thank You For Voting",
                                Colors.lightGreen);
                          }
                        });
                      },
                      child: thumbsUpSelected
                          ? const Icon(Icons.thumb_up_rounded,
                              color: Colors.green, size: 50)
                          : const Icon(Icons.thumb_up_outlined, size: 50)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          thumbsDownSelected = !thumbsDownSelected;
                          if (thumbsDownSelected) {
                            thumbsUpSelected = false;

                            _displaySnackBar(context, "Thank You For Voting",
                                Colors.redAccent);
                          }
                        });
                      },
                      child: thumbsDownSelected
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: const Icon(Icons.thumb_down_rounded,
                                  color: Colors.red, size: 50),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: const Icon(Icons.thumb_down_outlined,
                                  size: 50),
                            )),
                ],
              )
            ],
          ),
        ));
//         drawer: const JumpinNavDrawer(),;
  }
}

// class PlanInbox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
// Scaffold(
//   resizeToAvoidBottomPadding: false,
//   body: Column(
//     children: [
//       SearchPeopleInbox(
//         width: size.width,
//       ),
//       SizedBox(
//           height: size.height * 0.65,
//           width: size.width,
//           child: GridView.count(
//               primary: true,
//               crossAxisSpacing: 2,
//               mainAxisSpacing: 2,
//               crossAxisCount: 2,
//               children: List.generate(
//                   5, (index) => InboxEachUserCard(size: size))))
//     ],
//   ),
// );
//   }
// }

class InboxEachUserCard extends StatelessWidget {
  const InboxEachUserCard({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: size.width * 0.5,
        height: size.height * 0.2,
        child: Column(
          children: const [
            InboxPlanProfilePhoto(
                imageURL: 'assets/images/Onboarding/plan1.jpeg'),
            InboxPlanNameNStatus(name: 'Scuba Diving'),
            InboxPlamLastMessageNtime(message: 'So I was saying..', time: 10),
          ],
        ),
      ),
    );
  }
}

class InboxPlamLastMessageNtime extends StatelessWidget {
  const InboxPlamLastMessageNtime({
    Key key,
    this.time,
    this.message,
  }) : super(key: key);
  final String message;
  final int time;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      width: 800,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: font1,
              ),
            ),
          )),
          Container(
            padding: const EdgeInsets.all(3),
            child: Text(
              '$time' + 'm',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsJumpin.kPrimaryColorLite),
            ),
          ),
        ],
      ),
    );
  }
}

class InboxPlanNameNStatus extends StatelessWidget {
  const InboxPlanNameNStatus({Key key, @required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 5, top: 5, bottom: 5),
      child: Row(
        children: [
          InboxListPlanName(name: name),
        ],
      ),
    );
  }
}

class InboxPlanProfilePhoto extends StatelessWidget {
  const InboxPlanProfilePhoto({Key key, this.imageURL}) : super(key: key);
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            spreadRadius: 1,
            blurRadius: 12,
            color: Colors.grey[400],
            offset: const Offset(10, 10))
      ]),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(imageURL),
      ),
    );
  }
}

class InboxListPlanName extends StatelessWidget {
  const InboxListPlanName({Key key, @required this.name}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: font1,
              fontSize: 15),
        ),
      ),
    );
  }
}

class SearchPeopleInbox extends StatelessWidget {
  const SearchPeopleInbox({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: width * 0.7,
        child: const TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon:
                    Icon(Icons.search, color: ColorsJumpin.kSecondaryColor),
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'Search')),
      ),
    );
  }
}
