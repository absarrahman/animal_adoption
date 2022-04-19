import 'dart:typed_data';

import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/services/firebase_api.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  static final PostController homeController = Get.find<PostController>();

  Rx<String> fileName = "".obs;
  late Uint8List imageBytes;

  Future<void> uploadImageFile() async {
    String userUUID = AuthController.authController.userModel.value!.uuid!;
    await FirebaseAPI.uploadFile(bytes: imageBytes, fileName: fileName.value, refPath: "images/$userUUID");
  }
}
