import 'package:firebase_auth/firebase_auth.dart';
import "package:get/get.dart";

import '../models/user_model.dart';

class AuthController extends GetxController {
  static final AuthController authController = Get.find<AuthController>();
  Rx<String> email = "".obs;
  Rx<String> name = "".obs;
  Rx<String> password = "".obs;
  Rx<String> nid = "".obs;
  //FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Rx<UserModel> userModel = UserModel().obs;
  late Rx<User?> firebaseUser;
  var isLoggedIn = false.obs;
}
