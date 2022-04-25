import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class ReportPanelView extends StatelessWidget {
  const ReportPanelView({Key? key}) : super(key: key);

  static const String id = '/reportPanel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AuthController.authController.isAdmin.value ? const Text("Report panel") : const Text("Unauthorized access"),
      ),
    );
  }
}
