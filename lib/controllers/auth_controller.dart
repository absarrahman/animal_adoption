import 'dart:developer';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/services/firebase_api.dart';
import 'package:animal_adoption/views/home.dart';
import 'package:animal_adoption/views/widgets/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:get/get.dart";

import '../models/user_model.dart';

class AuthController extends GetxController {
  static final AuthController authController = Get.find<AuthController>();
  Rx<String> email = "".obs;
  Rx<String> name = "".obs;
  Rx<String> password = "".obs;
  Rx<String> houseAddress = "".obs;
  Rx<String> nid = "".obs;
  Rx<String> phoneNumber = "".obs;
  Rx<UserModel?> userModel = UserModel().obs;
  late Rx<User?> firebaseUser;
  var isLoggedIn = false.obs;
  var isAdmin = false.obs;

  @override
  void onReady() async {
    firebaseUser = Rx<User?>(FirebaseAPI.firebaseAuth.currentUser);
    firebaseUser.bindStream(FirebaseAPI.firebaseAuth.userChanges());
    ever(firebaseUser, trackAuthState);
    super.onReady();
  }

  void trackAuthState(User? user) async {
    if (user != null) {
      userModel.value = await FirebaseAPI.setUserModel(collectionPath: FireStoreConstants.userCollection, uID: user.uid);
      isLoggedIn.value = true;
    }
  }

  Future<void> signUp() async {
    try {
      userModel.value = await FirebaseAPI.signUp(
        userJSON: {
          ModelConstants.email: email.value,
          ModelConstants.role: RoleConstants.user,
          ModelConstants.name: name.value,
          ModelConstants.userPhoneNumber: phoneNumber.value,
          ModelConstants.userNID: nid.value,
          ModelConstants.userHouseAddress: houseAddress.value,
          ModelConstants.totalRateCount: 0,
          ModelConstants.averageRate: 0.0,
        },
        password: password.value,
        collectionPath: FireStoreConstants.userCollection,
      );
    } catch (e) {
      CommonWidgets.dismissLoadingWidget();
      Get.snackbar("Failed to signup", "Something went wrong");
      log(e.toString());
    }
    _clearStrings();
    Get.offAllNamed(HomeView.id);
  }

  Future<void> signIn() async {
    try {
      userModel.value = await FirebaseAPI.signIn(email: email.value, password: password.value, collectionPath: FireStoreConstants.userCollection);
    } catch (e) {
      // Remove the loader
      CommonWidgets.dismissLoadingWidget();
      Get.snackbar("Failed to login", "Password wrong or the user does not exist");
      log(e.toString());
    }
    //log("sign in function ${userModel.value}");
    Get.offAllNamed(HomeView.id);
    _clearStrings();
  }

  Future<void> signOut() async {
    await FirebaseAPI.signOut();
    isLoggedIn.value = false;
  }

  _clearStrings() {
    name.value = '';
    email.value = '';
    password.value = '';
    nid.value = '';
    houseAddress.value = '';
  }

  Future<void> bookAnimal({required String postID}) async {
    var post = await FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.adoptionPosts).doc(postID).get();
    var currentBookedUid = post.data()![ModelConstants.bookedUuid];

    if (currentBookedUid == null) {
      await FirebaseAPI.updateData(
          collectionPath: FireStoreConstants.adoptionPosts,
          newJsonData: {
            ModelConstants.bookedUuid: authController.userModel.value!.uuid,
          },
          uID: postID);
      Get.back();
      Get.snackbar("Congratulations", "Animal booked successfully");
    } else {
      Get.snackbar("Failed to book", "Someone already booked it");
    }
  }

  Future<void> removeUser({required String uuid}) async {
    try {
      await FirebaseAPI.removeData(uID: uuid, collectionPath: FireStoreConstants.userCollection);
    } catch (e) {
      Get.snackbar("Something went wrong", "Failed to remove");
    }
  }
}
