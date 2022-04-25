import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/common.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);
  static const String id = '/login-view';

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController.authController;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign in"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter email",
              ),
              onChanged: (value) {
                authController.email.value = value;
              },
            ),
            // Password
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter password",
              ),
              obscureText: true,
              onChanged: (value) {
                authController.password.value = value;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  CommonWidgets.loadingWidget();
                  try {
                    await authController.signIn();
                  } on FirebaseAuthException catch (e) {
                    // Remove loader
                    CommonWidgets.dismissLoadingWidget();
                    Get.snackbar("Failed to login", e.message!);
                  }
                },
                child: const Text("Sign in"))
          ],
        ));
  }
}
