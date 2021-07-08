import 'package:get/state_manager.dart';

class JumpinRequestController extends GetxController {
  final isReqReceived = false.obs;

 void alterReqRcvdValue() {
    isReqReceived.value = !isReqReceived.value;
  }
}
