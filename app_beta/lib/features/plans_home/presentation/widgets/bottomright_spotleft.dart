import 'package:JumpIn/core/constants/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BottomRightSpotLeft extends StatelessWidget {
  const BottomRightSpotLeft(
      {Key key, this.totalSpot, this.spotLeft, this.iconImageURL})
      : super(key: key);

  final int totalSpot;
  final int spotLeft;
  final String iconImageURL;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0,
        bottom: 20,
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
                            border:
                                Border.all(width: 1.0, color: Colors.black26),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Expanded(
                            flex: 5,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: ImageIcon(
                                  AssetImage(iconImageURL),
                                  size: SizeConfig.blockSizeHorizontal * 9,
                                )),
                          ),
                          Expanded(
                            flex: 5,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6, right: 6),
                                            child: Text(
                                              spotLeft.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      2.5,
                                                  fontFamily: font2semibold,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Text('/$totalSpot',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    2.5,
                                                fontFamily: font2semibold,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(
                                            left: 1, bottom: 1, right: 1),
                                        child: AutoSizeText('Spots Left',
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 15))),
                                  ],
                                )),
                          ),
                        ]),
                      ),
                    )))));
    // Positioned(
    //     bottom: getScreenSize(context).height * 0.02,
    //     right: 0,
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
    //                     padding: const EdgeInsets.all(1.0),
    //                     child: Align(
    //                         alignment: Alignment.topRight,
    //                         child: ImageIcon(
    //                           AssetImage(iconImageURL),
    //                           size: 28,
    //                         )),
    //                   ),
    //                   Spacer(),
    //                   Padding(
    //                     padding: const EdgeInsets.only(left: 30),
    //                     child: Row(
    //                       children: [
    //                         Container(
    //                           decoration: BoxDecoration(
    //                               color: Colors.black,
    //                               borderRadius: BorderRadius.circular(10)),
    //                           child: Padding(
    //                             padding:
    //                                 const EdgeInsets.only(left: 6, right: 6),
    //                             child: Text(
    //                               spotLeft.toString(),
    //                               style: TextStyle(color: Colors.white),
    //                             ),
    //                           ),
    //                         ),
    //                         Text('/$totalSpot')
    //                       ],
    //                     ),
    //                   ),
    //                   const Padding(
    //                       padding:
    //                           EdgeInsets.only(left: 1, bottom: 1, right: 1),
    //                       child: AutoSizeText('Spots Left',
    //                           maxLines: 1, style: TextStyle(fontSize: 15))),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ));
  }
}
