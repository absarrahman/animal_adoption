import 'dart:typed_data';

import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/services/firebase_api.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  static final PostController homeController = Get.find<PostController>();

  Future<void> uploadImageFile({required Uint8List bytes, required String fileName}) async {
    String userUUID = AuthController.authController.userModel.value!.uuid!;
    await FirebaseAPI.uploadFile(bytes: bytes, fileName: fileName, refPath: "images/$userUUID");
  }
}
