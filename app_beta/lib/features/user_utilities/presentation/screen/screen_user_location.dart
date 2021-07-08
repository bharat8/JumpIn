import 'package:JumpIn/core/utils/home_placeholder.dart';
import 'package:JumpIn/core/utils/jumpin_appbar.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class ScreenUserLocation extends StatefulWidget {
  @override
  _ScreenUserLocationState createState() => _ScreenUserLocationState();
}

class _ScreenUserLocationState extends State<ScreenUserLocation> {
  Geolocator geolocator = Geolocator();

  Address address;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: JumpinAppBar(context, 'Location'),
      drawer: const JumpinNavDrawer(),
      body: isLoading == false
          ? ListView(
              children: [
                ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: ColorsJumpin.kPrimaryColor,
                    ),
                    title: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });

                        LocationUtils.getLocation().then((position) {
                          LocationUtils.getAddress(position).then((addrs) {
                            setState(() {
                              isLoading = false;
                              address = addrs;
                              sharedPrefs.savedLocation = address.addressLine;
                            });
                          });
                        });
                      },
                      child: Text('Get My Current Location',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4)),
                    )),
                // ListTile(
                //     leading: Icon(
                //       Icons.add_location,
                //       color: ColorsJumpin.kPrimaryColor,
                //     ),
                //     title: Text('Add a new location',
                //         style: TextStyle(fontFamily: font1, fontSize: 20))),
                address != null
                    ? ListTile(
                        leading: Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        title: Text(address.addressLine,
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4)),
                      )
                    : Container(),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
                if (sharedPrefs.savedLocation != null)
                  ListTile(
                    leading: Text(
                      "Last Known Location",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    title: Text(sharedPrefs.savedLocation,
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4)),
                  )
              ],
            )
          : circularProgressIndicator(),
    );
  }
}
