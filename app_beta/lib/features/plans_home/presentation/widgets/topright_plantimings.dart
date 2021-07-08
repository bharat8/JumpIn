import 'package:JumpIn/core/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TopRightPlanTimings extends StatelessWidget {
  const TopRightPlanTimings({
    Key key,
    this.planStartime,
    this.planEndTime,
  }) : super(key: key);

  final DateTime planStartime;
  final DateTime planEndTime;
  //String startMeridian =  ? 'pm' : 'am';

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            const BoxShadow(
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
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black26),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                AutoSizeText(
                                  planStartime.hour.toString() +
                                      ":" +
                                      planStartime.minute.toString(),
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3,
                                      fontFamily: font2semibold,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                AutoSizeText(
                                  planEndTime.hour.toString() +
                                      ":" +
                                      planEndTime.minute.toString(),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(Icons.watch_later,
                                        size: SizeConfig.blockSizeHorizontal *
                                            9)))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
    // Positioned(
    //     top: 10,
    //     right: 0,
    //     child: Container(
    //       decoration: BoxDecoration(boxShadow: [
    //         const BoxShadow(
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
    //                       padding:
    //                           const EdgeInsets.only(left: 30, right: 2, top: 2),
    //                       child: AutoSizeText(
    //                         planStartime.hour.toString() +
    //                             ":" +
    //                             planStartime.minute.toString(),
    //                         maxLines: 2,
    //                       )),
    //                   Padding(
    //                       padding:
    //                           const EdgeInsets.only(left: 30, right: 2, top: 2),
    //                       child: AutoSizeText(
    //                         planStartime.hour.toString() +
    //                             ":" +
    //                             planStartime.minute.toString(),
    //                         maxLines: 2,
    //                       )),
    //                   Spacer(),
    //                   Padding(
    //                       padding: const EdgeInsets.all(5.0),
    //                       child: Align(
    //                           alignment: Alignment.bottomRight,
    //                           child: Icon(Icons.watch_later)))
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ));
  }
}
