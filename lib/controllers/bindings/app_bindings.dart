import 'package:get/get.dart';

import '../auth_controller.dart';
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}