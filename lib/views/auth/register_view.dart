import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);
  static const String id = '/register-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          //Email
          TextField(
            decoration: InputDecoration(
              hintText: "Enter email",
            ),
          ),
          //Password
          TextField(
            decoration: InputDecoration(
              hintText: "Enter password",
            ),
          ),
        ],
      ),
    );
  }
}
