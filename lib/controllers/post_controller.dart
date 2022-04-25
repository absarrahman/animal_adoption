import 'dart:developer';
import 'dart:typed_data';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/services/firebase_api.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  static final PostController postController = Get.find<PostController>();

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
      ModelConstants.isBooked: false,
      ModelConstants.createdAt: DateTime.now().microsecondsSinceEpoch,
      ModelConstants.postDescription: postDescription.value,
      ModelConstants.postName: postName.value,
      ModelConstants.imageUrl: imageUrl,
      ModelConstants.userUuid: AuthController.authController.userModel.value!.uuid,
    });
    log("Doc id is $docID");
    await FirebaseAPI.updateData(collectionPath: FireStoreConstants.adoptionPosts, uID: docID, newJsonData: {ModelConstants.uuid: docID});
  }

  Future<void> confirmBook(
      {required String userUUID, required double newRate, required String postID, required double oldAverage, required int totalRateCount}) async {
    try {
      double newAverage = _calculateAverage(newRate: newRate, oldAverage: oldAverage, totalRateCount: totalRateCount);
      await FirebaseAPI.updateData(collectionPath: FireStoreConstants.adoptionPosts, newJsonData: {ModelConstants.isBooked: true}, uID: postID);
      await FirebaseAPI.updateData(
          collectionPath: FireStoreConstants.userCollection,
          newJsonData: {
            ModelConstants.averageRate: newAverage,
            ModelConstants.totalRateCount: totalRateCount + 1,
          },
          uID: userUUID);
    } catch (e) {
      Get.snackbar("Something went wrong", "Failed to confirm booking");
    }
  }

  double _calculateAverage({required double newRate, required double oldAverage, required int totalRateCount}) {
    //newAve = ((oldAve*oldNumPoints) + x)/(oldNumPoints+1) https://stackoverflow.com/questions/3998780/general-is-there-a-way-to-calculate-an-average-based-off-of-an-existing-averag
    log("User old average $oldAverage total rate $totalRateCount newRate $newRate");
    double totalValue = (oldAverage * totalRateCount) + newRate;
    double newCount = totalRateCount + 1;
    double newAverage = totalValue / newCount;
    log("New average = $newAverage total value $totalValue new cOunt $newCount");
    return newAverage;
  }

  Future<void> removeBook({required String postID}) async {
    try {
      await FirebaseAPI.updateData(
          collectionPath: FireStoreConstants.adoptionPosts,
          newJsonData: {
            ModelConstants.isBooked: false,
            ModelConstants.bookedUuid: null,
          },
          uID: postID);
    } catch (e) {
      Get.snackbar("Something went wrong", "Failed to remove booking. Please try again");
    }
  }
}
