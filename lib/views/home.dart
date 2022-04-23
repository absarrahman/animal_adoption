import 'dart:developer';

import 'package:animal_adoption/views/create_post.dart';
import 'package:animal_adoption/views/widgets/adoption_post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:animal_adoption/constants/string_constants.dart';
import 'package:animal_adoption/controllers/auth_controller.dart';
import 'package:animal_adoption/services/firebase_api.dart';
import 'package:animal_adoption/views/auth/login_view.dart';
import 'package:animal_adoption/views/auth/register_view.dart';
import 'package:animal_adoption/views/widgets/common.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String id = '/';

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.authController;
    log("${authController.userModel.value!.username} ${authController.isLoggedIn.value}");
    return Obx(() {
      return Scaffold(
          drawer: authController.isLoggedIn.value ? const UserDrawerWidget() : null,
          appBar: AppBar(
            elevation: 0,
            leading: Builder(builder: (context) {
              return authController.isLoggedIn.value
                  ? IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    )
                  : Container();
            }),
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
                return GridView.builder(
                  itemBuilder: ((context, index) {
                    // Per adoption post
                    var adoptionPost = adoptionPostList[index].data();

                    return FutureBuilder(
                        future: Future.wait([
                          //Get data from usercollection
                          FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.userCollection).doc(adoptionPost[ModelConstants.userUuid]).get(),
                          // Get data from booked Collection
                          //FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.userCollection).doc(adoptionPost[ModelConstants.userUuid]).get()
                        ]),
                        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator.adaptive();
                          } else if (snapshot.hasData) {
                            return AdoptionPostWidget(
                              postDesciption: adoptionPost[ModelConstants.postDescription],
                              createdAt: adoptionPost[ModelConstants.createdAt],
                              imageUrl:
                                  "https://media.istockphoto.com/photos/european-short-haired-cat-picture-id1072769156?k=20&m=1072769156&s=612x612&w=0&h=k6eFXtE7bpEmR2ns5p3qe_KYh098CVLMz4iKm5OuO6Y=",
                              postName: adoptionPost[ModelConstants.postName],
                              userName: snapshot.data![0][ModelConstants.username]!,
                            );
                          } else {
                            return const Text("Failed to retrieve data");
                          }
                        });
                  }),
                  itemCount: adoptionPostList.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500, //height
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 120,
                      mainAxisSpacing: 20),
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
    });
  }
}

class UserDrawerWidget extends StatelessWidget {
  const UserDrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          //For creating post
          TextButton(
            child: const Text("Create adoption post"),
            onPressed: () {
              log("Go to adoption post");
              Get.toNamed(CreateAdoptionPostView.id);
            },
          ),
        ],
      ),
    );
  }
}
