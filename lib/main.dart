import 'package:animal_adoption/controllers/bindings/app_bindings.dart';
import 'package:animal_adoption/routes.dart';
import 'package:animal_adoption/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDUqqUUVXNoL0Nsg2VrKuLhyUFRCs99wQg",
          appId: "1:706505452444:web:570882697b4363b1d33659",
          messagingSenderId: "706505452444",
          projectId: "animal-adoption-platform"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialize = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDUqqUUVXNoL0Nsg2VrKuLhyUFRCs99wQg",
          appId: "1:706505452444:web:570882697b4363b1d33659",
          messagingSenderId: "706505452444",
          projectId: "animal-adoption-platform"));

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
