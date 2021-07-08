import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class NotificationController extends GetxController {
  final notificationCounter = 0.obs;
  final msgCounter = 0.obs;

  void incrementNotificationCounter(int byHowMuch) {
    notificationCounter.value += byHowMuch;
  }

  void decrementNotificationCounter(int byHowMuch) {
    notificationCounter.value += byHowMuch;
  }

  void incrementMsgCounter(int byHowMuch) {
    msgCounter.value += byHowMuch;
  }

  void decrementMsgCounter(int byHowMuch) {
    msgCounter.value += byHowMuch;
  }
}
