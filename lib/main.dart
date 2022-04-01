import 'package:animal_adoption/controllers/bindings/app_bindings.dart';
import 'package:animal_adoption/routes.dart';
import 'package:animal_adoption/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialize = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeView.id,
      initialBinding: AppBinding(),
      home: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return const HomeView();
          } else {
            printError(info: "Something went wrong");
            return const Center(child: Text("Failed to connect"));
          }
        },
        future: _initialize,
      ),
      getPages: AppRoutes.routes,
    );
  }
}
