import 'package:animal_adoption/views/auth/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String id = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.toNamed(RegisterView.id);
            },
            child: const Text("Register View"),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text("Hey"),
      ),
    );
  }
}
