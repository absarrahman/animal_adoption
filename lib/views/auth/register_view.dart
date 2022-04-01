import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);
  static const String id = '/register-view';

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.authController;
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
          DropdownButton(
              value: authController.role.value,
              items: [
                RoleConstants.roleAdoptPostPetUser,
                RoleConstants.roleGonnAdoptUser,
              ]
                  .map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ))
                  .toList(),
              onChanged: (String? value) {
                authController.role.value = value!;
              }),
          ElevatedButton(
              onPressed: () {
                authController.signUp();
              },
              child: const Text("Signup"))
        ],
      ),
    );
  }
}
