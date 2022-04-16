import 'dart:developer';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/services/firebase_api.dart';
import 'package:animal_adoption/utils/responsive.dart';
import 'package:animal_adoption/views/auth/login_view.dart';
import 'package:animal_adoption/views/auth/register_view.dart';
import 'package:animal_adoption/views/widgets/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String id = '/';

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.authController;
    log("${authController.isLoggedIn.value}");
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            const Spacer(
              flex: 3,
            ),
            authController.isLoggedIn.value
                ? ElevatedButton(
                    onPressed: () async {
                      CommonWidgets.loadingWidget();
                      await authController.signOut();
                      CommonWidgets.dismissLoadingWidget();
                    },
                    child: const Text("Logout"),
                  )
                : Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 8,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(LoginView.id);
                            },
                            child: const Text("Login"),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          flex: 8,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(RegisterView.id);
                            },
                            child: const Text("Join us"),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.adoptionPosts).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              List adoptionPostList = snapshot.data!.docs.toList();
              return ListView.builder(
                itemBuilder: ((context, index) {
                  var adoptionPost = adoptionPostList[index].data();
                  return Text(adoptionPost[ModelConstants.postDescription]);
                }),
                itemCount: adoptionPostList.length,
              );
            } else if (snapshot.hasError) {
              return const Text("Something went wrong");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              return const Text("Please try again");
            }
          },
        ));
  }
}
