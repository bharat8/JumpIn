import 'package:JumpIn/core/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BottomLeftPeopleAlsoJoining extends StatelessWidget {
  const BottomLeftPeopleAlsoJoining({Key key, this.peoplejoining, this.icon})
      : super(key: key);
  final List<String> peoplejoining;
  final ImageIcon icon;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        left: 0,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(6, 2),
              blurRadius: 10,
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: getScreenSize(context).height * 0.15,
            width: getScreenSize(context).width * 0.26,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                shadowColor: Colors.black,
                elevation: 2.0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black26),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ImageIcon(icon.image,
                              size: SizeConfig.blockSizeHorizontal * 9),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: AutoSizeText(
                            '${peoplejoining[0]},${peoplejoining[1]} and 3 others Also Joining',
                            style: TextStyle(
                                fontFamily: font2semibold,
                                fontSize: SizeConfig.blockSizeHorizontal * 3,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
    // Positioned(
    //     bottom: getScreenSize(context).height * 0.02,
    //     left: 0,
    //     child: Container(
    //       decoration: BoxDecoration(boxShadow: [
    //         BoxShadow(
    //           color: Colors.grey,
    //           offset: Offset(6, 2),
    //           blurRadius: 10,
    //         )
    //       ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
    //       child: SizedBox(
    //         height: getScreenSize(context).height * 0.15,
    //         width: getScreenSize(context).width * 0.26,
    //         child: Padding(
    //           padding: const EdgeInsets.all(3.0),
    //           child: Card(
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10)),
    //             shadowColor: Colors.black,
    //             elevation: 2.0,
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(width: 1.0, color: Colors.black26),
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.only(right: 62),
    //                     child: Align(
    //                         alignment: Alignment.bottomRight,
    //                         child: ImageIcon(icon.image)),
    //                   ),
    //                   Spacer(),
    //                   Padding(
    //                       padding: const EdgeInsets.only(
    //                           right: 10, left: 1, bottom: 2),
    //                       child: Container(
    //                         child: Text(
    //                           '${peoplejoining[0]},${peoplejoining[1]} and 3 others Also Joining',
    //                           style: TextStyle(fontSize: 10),
    //                         ),
    //                       )),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ));
  }
}
