import 'package:JumpIn/features/people_home/data/model_jumpin_user.dart';
import 'package:get/state_manager.dart';

class PeopleProfileController extends GetxController {
  final user = JumpinUser().obs;
  final isReqSent = false.obs;
  final Map<String, String> reqMap = {"": ""}.obs;

  assignUser(JumpinUser people) {
    user.value = people;
  }

  updateIsreqSent() {
    isReqSent.value = !isReqSent.value;
  }

  updateReqMap(String userid, String reqStatus) {
    reqMap[userid] = reqStatus;
  }
}
