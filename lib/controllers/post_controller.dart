import 'dart:developer';
import 'dart:typed_data';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/services/firebase_api.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  static final PostController homeController = Get.find<PostController>();

  Rx<String> fileName = "".obs;
  late Uint8List imageBytes;
  Rx<String> postName = "".obs;
  Rx<String> postDescription = "".obs;
  Rx<String> animalType = "".obs;

  Future<String?> uploadImageFile() async {
    String userUUID = AuthController.authController.userModel.value!.uuid!;
    return await FirebaseAPI.uploadFile(bytes: imageBytes, fileName: fileName.value, refPath: "images/$userUUID");
  }

  Future<void> createPost() async {
    String? imageUrl = await uploadImageFile();
    log("Image URL $imageUrl");
    String? docID = await FirebaseAPI.addDataAndGetDocID(collectionPath: FireStoreConstants.adoptionPosts, json: {
      ModelConstants.animalType: animalType.value,
      ModelConstants.bookedUuid: null,
      ModelConstants.createdAt: DateTime.now().microsecondsSinceEpoch,
      ModelConstants.postDescription: postDescription.value,
      ModelConstants.postName: postName.value,
      ModelConstants.imageUrl: imageUrl,
      ModelConstants.userUuid: AuthController.authController.userModel.value!.uuid,
    });
    log("Doc id is $docID");
    await FirebaseAPI.updateData(collectionPath: FireStoreConstants.adoptionPosts, uID: docID, newJsonData: {ModelConstants.uuid: docID});
  }
}
