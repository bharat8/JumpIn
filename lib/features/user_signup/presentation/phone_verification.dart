import 'dart:async';
import 'package:JumpIn/controller/otp_controller.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/features/user_signup/domain/service_otp.dart';
import 'package:JumpIn/features/user_signup/presentation/widgets_phoneVerification/onboarding_prog_indicator1.dart';
import 'package:JumpIn/features/user_signup/presentation/widgets_signup/applogo.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:JumpIn/core/utils/utils.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

Map countryLocaleCode = {
  "AF/AFG": "93",
  "AL/ALB": "355",
  "DZ/DZA": "213",
  "AS/ASM": "1-684",
  "AD/AND": "376",
  "AO/AGO": "244",
  "AI/AIA": "1-264",
  "AQ/ATA": "672",
  "AG/ATG": "1-268",
  "AR/ARG": "54",
  "AM/ARM": "374",
  "AW/ABW": "297",
  "AC/ASC": "247",
  "AU/AUS": "61",
  "AT/AUT": "43",
  "AZ/AZE": "994",
  "BS/BHS": "1-242",
  "BH/BHR": "973",
  "BD/BGD": "880",
  "BB/BRB": "1-246",
  "BY/BLR": "375",
  "BE/BEL": "32",
  "BZ/BLZ": "501",
  "BJ/BEN": "229",
  "BM/BMU": "1441",
  "BT/BTN": "975",
  "BO/BOL": "591",
  "BA/BIH": "387",
  "BW/BWA": "267",
  "BR/BRA": "55",
  "VG/VGB": "1-284",
  "BN/BRN": "673",
  "BG/BGR": "359",
  "BF/BFA": "226",
  "MM/MMR": "95",
  "BI/BDI": "257",
  "KH/KHM": "855",
  "CM/CMR": "237",
  "CA/CAN": "1",
  "CV/CPV": "238",
  "KY/CYM": "1-345",
  "CF/CAF": "236",
  "TD/TCD": "235",
  "CL/CHL": "56",
  "CN/CHN": "86",
  "CX/CXR": "61",
  "CC/CCK": "61",
  "CO/COL": "57",
  "KM/COM": "269",
  "CG/COG": "242",
  "CK/COK": "682",
  "CR/CRC": "506",
  "HR/HRV": "385",
  "CU/CUB": "53",
  "CY/CYP": "357",
  "CZ/CZE": "420",
  "CD/COD": "243",
  "DK/DNK": "45",
  "DG/DGA": "246",
  "DJ/DJI": "253",
  "DM/DMA": "1-767",
  "DO/DOM": "1-809",
  "EC/ECU": "593",
  "EG/EGY": "20",
  "SV/SLV": "503",
  "GQ/GNQ": "240",
  "ER/ERI": "291",
  "EE/EST": "372",
  "ET/ETH": "251",
  "FK/FLK": "500",
  "FO/FRO": "298",
  "FJ/FJI": "679",
  "FI/FIN": "358",
  "FR/FRA": "33",
  "GF/GUF": "594",
  "PF/PYF": "689",
  "GA/GAB": "241",
  "GM/GMB": "220",
  "GE/GEO": "995",
  "DE/DEU": "49",
  "GH/GHA": "233",
  "GI/GIB": "350",
  "GR/GRC": "30",
  "GL/GRL": "299",
  "GD/GRD": "1-473",
  "GP/GLP": "590",
  "GU/GUM": "1-671",
  "GT/GTM": "502",
  "GN/GIN": "224",
  "GW/GNB": "245",
  "GY/GUY": "592",
  "HT/HTI": "509",
  "VA/VAT": "39",
  "HN/HND": "504",
  "HK/HKG": "852",
  "HU/HUN": "36",
  "IS/IS": "354",
  "IN/IND": "91",
  "ID/IDN": "62",
  "IR/IRN": "98",
  "IQ/IRQ": "964",
  "IE/IRL": "353",
  "IM/IMN": "44",
  "IL/ISR": "972",
  "IT/ITA": "39",
  "CI/CIV": "225",
  "JM/JAM": "1-876",
  "JP/JPN": "81",
  "JE/JEY": "44",
  "JO/JOR": "962",
  "KZ/KAZ": "7",
  "KE/KEN": "254",
  "KI/KIR": "686",
  "KW/KWT": "965",
  "KG/KGZ": "996",
  "LA/LAO": "856",
  "LV/LVA": "371",
  "LB/LBN": "961",
  "LS/LSO": "266",
  "LR/LBR": "231",
  "LY/LBY": "218",
  "LI/LIE": "423",
  "LT/LTU": "370",
  "LU/LUX": "352",
  "MO/MAC": "853",
  "MK/MKD": "389",
  "MG/MDG": "261",
  "MW/MWI": "265",
  "MY/MYS": "60",
  "MV/MDV": "960",
  "ML/MLI": "223",
  "MT/MLT": "356",
  "MH/MHL": "692",
  "MQ/MTQ": "596",
  "MR/MRT": "222",
  "MU/MUS": "230",
  "YT/MYT": "262",
  "MX/MEX": "52",
  "FM/FSM": "691",
  "MD/MDA": "373",
  "MC/MCO": "377",
  "MN/MNG": "976",
  "ME/MNE": "382",
  "MS/MSR": "1-664",
  "MA/MAR": "212",
  "MZ/MOZ": "258",
  "NA/NAM": "264",
  "NR/NRU": "674",
  "NP/NPL": "977",
  "NL/NLD": "31",
  "AN/ANT": "599",
  "NC/NCL": "687",
  "NZ/NZL": "64",
  "NI/NIC": "505",
  "NE/NER": "227",
  "NG/NGA": "234",
  "NU/NIU": "683",
  "NF/NFK": "672",
  "KP/PRK": "850",
  "MP/MNP": "1-670",
  "NO/NOR": "47",
  "OM/OMN": "968",
  "PK/PAK": "92",
  "PW/PLW": "680",
  "PS/PSE": "970",
  "PA/PAN": "507",
  "PG/PNG": "675",
  "PY/PRY": "595",
  "PE/PER": "51",
  "PH/PHL": "63",
  "PN/PCN": "870",
  "PL/POL": "48",
  "PT/PRT": "351",
  "PR/PRI": "1-787",
  "QA/QAT": "974",
  "RE/REU": "262",
  "RO/ROU": "40",
  "RU/RUS": "7",
  "RW/RWA": "250",
  "BL/BLM": "590",
  "SH/SHN": "290",
  "KN/KNA": "1-869",
  "LC/LCA": "1-758",
  "MF/MAF": "590",
  "PM/SPM": "508",
  "VC/VCT": "1-784",
  "WS/WSM": "685",
  "SM/SMR": "378",
  "ST/STP": "239",
  "SA/SAU": "966",
  "SN/SEN": "221",
  "RS/SRB": "381",
  "SC/SYC": "248",
  "SL/SLE": "232",
  "SG/SGP": "65",
  "SX/SXM": "1-721",
  "SK/SVK": "421",
  "SI/SVN": "386",
  "SB/SLB": "677",
  "SO/SOM": "252",
  "ZA/ZAF": "27",
  "KR/KOR": "82",
  "SS/SSD": "211",
  "ES/ESP": "34",
  "LK/LKA": "94",
  "SD/SDN": "249",
  "SR/SUR": "597",
  "SJ/SJM": "47",
  "SZ/SWZ": "268",
  "SE/SWE": "46",
  "CH/CHE": "41",
  "SY/SYR": "963",
  "TW/TWN": "886",
  "TJ/TJK": "992",
  "TZ/TZA": "255",
  "TH/THA": "66",
  "TL/TLS": "670",
  "TG/TGO": "228",
  "TK/TKL": "690",
  "TO/TON": "676",
  "TT/TTO": "1-868",
  "TN/TUN": "216",
  "TR/TUR": "90",
  "TM/TKM": "993",
  "TC/TCA": "1-649",
  "TV/TUV": "688",
  "UG/UGA": "256",
  "UA/UKR": "380",
  "AE/ARE": "971",
  "GB/GBR": "44",
  "US/USA": "1",
  "UY/URY": "598",
  "VI/VIR": "1-340",
  "UZ/UZB": "998",
  "VU/VUT": "678",
  "VE/VEN": "58",
  "VN/VNM": "84",
  "WF/WLF": "681",
  "EH/ESH": "212",
  "YE/YEM": "967",
  "ZM/ZMB": "260",
  "ZW/ZWE": "263",
};

OTPController otpController = OTPController();
String phoneNo = "";
var _phoneNoformKey = GlobalKey<FormState>();
String smsCode = "";
var _smsCodeformKey = GlobalKey<FormState>();

void submitPhoneNo() {
  _phoneNoformKey.currentState.save();
}

void submitOTPsent() {
  _smsCodeformKey.currentState.save();
}

bool checkValidityOfEnteredNumber(String phoneNo) {
  //return true;
  // final RegExp indianMobileRegex = RegExp(r"^[6-9]\d{9}$");
  // return indianMobileRegex.hasMatch(phoneNo);
  return true;
}

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  ConnectionChecker cc = ConnectionChecker();

  int _start = 59;
  Widget otpEntryBox = Container();
  String sendOTPtext = 'Send OTP';
  bool verifyButtonVisible = false;
  bool timerVisible = false;
  bool sendButtonVisible = true;
  String dialCode = "+91";
  Future _future;
  Timer _timer;

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _start = 59;
    }
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start <= 0) {
            _start = 59;
            sendButtonVisible = true;
            timer.cancel();
          } else {
            _start = _start - 1;
            print(_start);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    cc.checkConnection(context);
    _future = prelims();
    super.initState();
  }

  @override
  void dispose() {
    cc.listener.cancel();
    super.dispose();
  }

  Future prelims() async {
    String locale = await Devicelocale.currentLocale;
    print(locale);
    countryLocaleCode.keys.forEach((element) {
      print(element);
      if ((element as String).contains(locale.substring(3))) {
        dialCode = "+${countryLocaleCode[element]}";
        return;
      }
    });
    print(dialCode);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final size = MediaQuery.of(context).size;
    final mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return circularProgressIndicator();
                }
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.topCenter,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(0.3), BlendMode.dstATop),
                          image: const AssetImage(
                              'assets/images/Onboarding/hands_distant.jpg'),
                          fit: BoxFit.contain)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenSize(context).height * 0.05,
                      ),
                      const OnboardingProgressIndicator1(),
                      ApplogonName(
                          height: mediaQueryData.size.height,
                          width: mediaQueryData.size.width),
                      Row(children: [
                        Container(
                          child: CountryListPick(
                              appBar: AppBar(
                                backgroundColor: Colors.blue,
                                title: Text(
                                  'Choose a country',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              pickerBuilder:
                                  (context, CountryCode countryCode) {
                                return Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 40,
                                      child: Image.asset(
                                        countryCode.flagUri,
                                        package: 'country_list_pick',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(countryCode.dialCode,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                );
                              },
                              theme: CountryTheme(
                                isShowFlag: true,
                                isShowTitle: true,
                                isShowCode: true,
                                isDownIcon: true,
                                showEnglishName: true,
                              ),
                              initialSelection: dialCode,
                              onChanged: (CountryCode code) {
                                print(code.name);
                                print(code.code);
                                print(code.dialCode);
                                print(code.flagUri);
                                dialCode = code.dialCode;
                              },
                              // Whether to allow the widget to set a custom UI overlay
                              useUiOverlay: true,
                              // Whether the country list should be wrapped in a SafeArea
                              useSafeArea: false),
                        ),
                        PhoneNoEntry()
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                sendButtonVisible = false;
                                sendOTPtext = "Resend OTP";
                                print("inside setstate");
                              });
                              print("outside setstate");
                              if (!sendButtonVisible) {
                                submitPhoneNo();
                                //closing the keyboard
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                signUpUserWithOTP(context);
                                if (checkValidityOfEnteredNumber(
                                    "$dialCode$phoneNo")) {
                                  startTimer();
                                  timerVisible = true;
                                  verifyButtonVisible = true;
                                  setState(() {
                                    otpEntryBox = const OTPEntry(value: true);
                                  });
                                } else {
                                  // setState(() {
                                  //   sendOTPtext = "Send OTP";
                                  //   timerVisible = false;
                                  //   verifyButtonVisible = false;
                                  //   otpEntryBox = Container();
                                  // });
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          title: Text(
                                              "Enter Valid Phone Number",
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      4))));
                                }
                              }
                            },
                            color: sendButtonVisible
                                ? ColorsJumpin.kPrimaryColorLite
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                  sendButtonVisible ? sendOTPtext : "Verifying",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3)),
                            ),
                          ),
                        )
                      ]),
                      otpEntryBox,
                      timerVisible == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Text(
                                    '0:' + _start.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                      verifyButtonVisible == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 50,
                                    width: 150,
                                    margin: EdgeInsets.all(30),
                                    child: RaisedButton(
                                      color: ColorsJumpin.kPrimaryColorLite,
                                      onPressed: () {
                                        if (sharedPrefs.okToNavigateFromOTP) {
                                          print(
                                              'phone verification page ${sharedPrefs.okToNavigateFromOTP}');
                                          Navigator.pushNamed(
                                              context, rOnboardingInterests);
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text("Invalid OTP"),
                                                  ));
                                        }
                                      },
                                      child: Text("Verify"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    )),
                              ],
                            )
                          : Container()
                    ],
                  ),
                );
              })),
    );
  }
}

class PhoneNoEntry extends StatelessWidget {
  const PhoneNoEntry({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: SizeConfig.bodyWidth * 0.02),
        child: Form(
            key: _phoneNoformKey,
            child: TextFormField(
              onSaved: (val) => phoneNo = val,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 0.0),
                  ),
                  border: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 0.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 0.0),
                  ),
                  labelText: 'Enter Phone Number',
                  hintText: '9876543210',
                  hintStyle: TextStyle(color: Colors.black38),
                  labelStyle: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w600),
                  hoverColor: ColorsJumpin.kPrimaryColorLite),
            )),
      ),
    );
  }
}

class BackgroundImage extends StatefulWidget {
  const BackgroundImage({Key key, @required this.topValue}) : super(key: key);

  final double topValue;
  @override
  _BackgroundImageState createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.topValue,
        right: 0,
        bottom: 300,
        left: 0,
        child: Opacity(
          opacity: 0.2,
          child: SizedBox(
              height: 200,
              width: getScreenSize(context).width,
              child: Image.asset('assets/images/Onboarding/hands_distant.jpg')),
        ));
  }
}

class PhoneNumberEntry extends StatefulWidget {
  final TextEditingController phoneNoController;
  const PhoneNumberEntry({
    Key key,
    this.phoneNoController,
  }) : super(key: key);

  @override
  _PhoneNumberEntryState createState() => _PhoneNumberEntryState();
}

class _PhoneNumberEntryState extends State<PhoneNumberEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: IntlPhoneField(
        controller: widget.phoneNoController,
        decoration: InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: ColorsJumpin.kSecondaryColor),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: ColorsJumpin.kSecondaryColor))),
        initialCountryCode: "IN",
        onChanged: (phone) {
          print(phone.completeNumber);
        },
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer(
      {Key key,
      @required this.child,
      @required this.width,
      @required this.bgColor})
      : super(key: key);

  final Color bgColor;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: width,
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(30)),
      child: child,
    );
  }
}

class OTPEntry extends StatefulWidget {
  const OTPEntry({Key key, @required this.value}) : super(key: key);

  final bool value;
  @override
  _OTPEntryState createState() => _OTPEntryState();
}

class _OTPEntryState extends State<OTPEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Obx(
        () => Form(
          key: _smsCodeformKey,
          child: TextFormField(
            initialValue: otpController.otpTextInitialValue.value,
            enabled: widget.value,
            onSaved: (val) => smsCode = val,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter OTP',
              labelStyle: TextStyle(color: ColorsJumpin.kSecondaryColor),
              border: OutlineInputBorder(borderSide: BorderSide()),
              icon: Icon(Icons.input, color: ColorsJumpin.kPrimaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
