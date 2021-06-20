import 'package:get/state_manager.dart';

class OTPController extends GetxController {
  final otpTextInitialValue = "".obs;

  alterOTPTextInitialValue(String value) {
    otpTextInitialValue.value = value;
  }
}
