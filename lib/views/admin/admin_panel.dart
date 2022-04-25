import 'package:flutter/material.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({Key? key}) : super(key: key);

  static const String id = '/adminPanel';
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ADMIN PANEL"),
      ),
    );
  }
}
