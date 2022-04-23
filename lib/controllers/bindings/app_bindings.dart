import 'package:animal_adoption/controllers/post_controller.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(),permanent: true);
    Get.lazyPut(() => PostController(), fenix: true);
  }
}
