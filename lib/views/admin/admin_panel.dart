import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/views/admin/report_panel.dart';
import 'package:animal_adoption/views/admin/user_list_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({Key? key}) : super(key: key);

  static const String id = '/adminPanel';

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.authController;
    return Scaffold(
      body: Center(
        child: authController.isAdmin.value
            ? Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(UserPanelListView.id);
                    },
                    child: const Text("User panel"),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Get.toNamed(ReportPanelView.id);
                  //     },
                  //     child: const Text("Report Panel")),
                ],
              )
            : const Text("Unauthorized access"),
      ),
    );
  }
}
