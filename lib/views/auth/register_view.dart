import 'dart:developer';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/views/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);
  static const String id = '/register-view';

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.authController;
    log(authController.isLoggedIn.value.toString());
    return Scaffold(
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
          // User name
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter username",
            ),
            onChanged: (value) {
              authController.userName.value = value;
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

          //House address
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter house address",
            ),
            onChanged: (value) {
              authController.houseAddress.value = value;
            },
          ),
          // Nid
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter NID",
            ),
            onChanged: (value) {
              authController.nid.value = value;
            },
          ),
          Obx(() {
            return DropdownButton(
                value: authController.role.value,
                items: [
                  RoleConstants.roleMaps[RoleConstants.roleAdoptPostPetUser],
                  RoleConstants.roleMaps[RoleConstants.roleGonnAdoptUser],
                ]
                    .map((value) => DropdownMenuItem(
                          child: Text(value!),
                          value: value,
                        ))
                    .toList(),
                onChanged: (String? value) {
                  authController.role.value = value!;
                });
          }),
          ElevatedButton(
              onPressed: () async {
                CommonWidgets.loadingWidget();
                await authController.signUp();
              },
              child: const Text("Signup"))
        ],
      ),
    );
  }
}
