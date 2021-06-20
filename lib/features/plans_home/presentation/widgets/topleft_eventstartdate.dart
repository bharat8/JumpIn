import 'package:JumpIn/core/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TopLeftEventStartDate extends StatelessWidget {
  const TopLeftEventStartDate({
    Key key,
    @required this.planStartMonth,
    @required this.planStartdayOfMonth,
    @required this.planStartyear,
  }) : super(key: key);

  final String planStartMonth;
  final int planStartdayOfMonth;
  final int planStartyear;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.all(5),
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
            padding: const EdgeInsets.all(1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: Colors.black,
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black26),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(1),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  '$planStartMonth' +
                                      ' ' +
                                      '$planStartdayOfMonth',
                                  style: TextStyle(
                                      fontFamily: font2semibold,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.all(1),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  '$planStartyear',
                                  style: TextStyle(
                                      fontFamily: font2semibold,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ))
                        ],
                      ),
                    ),
                    //gendericon
                    Expanded(
                      flex: 5,
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Icon(
                            Icons.calendar_today,
                            size: SizeConfig.blockSizeHorizontal * 9,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // Positioned(
    //     top: 10,
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
    //                       padding: const EdgeInsets.only(right: 20, top: 4),
    //                       child: AutoSizeText(
    //                         '$planStartMonth' + ' ' + '$planStartdayOfMonth',
    //                         maxLines: 1,
    //                       )),
    //                   Padding(
    //                       padding: const EdgeInsets.only(right: 20, top: 4),
    //                       child: AutoSizeText(
    //                         '$planStartyear',
    //                         maxLines: 2,
    //                         style: TextStyle(fontSize: 10),
    //                       )),
    //                   Spacer(),
    //                   Padding(
    //                     padding: const EdgeInsets.all(5.0),
    //                     child: Align(
    //                         alignment: Alignment.bottomLeft,
    //                         child: Icon(Icons.calendar_today)),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //    ));
  }
}
