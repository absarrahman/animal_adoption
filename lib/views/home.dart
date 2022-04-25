import 'dart:developer';

import 'package:animal_adoption/views/admin/admin_panel.dart';
import 'package:animal_adoption/views/users/create_post.dart';
import 'package:animal_adoption/views/users/view_post.dart';
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
    log("${authController.userModel.value!.uuid} ${authController.isLoggedIn.value}");
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
                            return InkWell(
                              onHover: ((value) {}),
                              onTap: () {
                                Get.defaultDialog(
                                    content: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Text(
                                        adoptionPost[ModelConstants.postDescription],
                                      ),
                                      Visibility(
                                        visible: isValidUser(adoptionPost, authController),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // Book animal
                                            log("Adopt post ${adoptionPost[ModelConstants.uuid]}");
                                            await authController.bookAnimal(postID: adoptionPost[ModelConstants.uuid]);
                                          },
                                          child: const Text("Book Now"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              },
                              child: AdoptionPostWidget(
                                postDesciption: adoptionPost[ModelConstants.postDescription],
                                createdAt: adoptionPost[ModelConstants.createdAt],
                                imageUrl: adoptionPost[ModelConstants.imageUrl],
                                postName: adoptionPost[ModelConstants.postName],
                                postID: adoptionPost[ModelConstants.uuid],
                              ),
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

  bool isValidUser(adoptionPost, AuthController authController) {
    return adoptionPost[ModelConstants.userUuid] != authController.userModel.value!.uuid &&
        authController.isLoggedIn.value &&
        adoptionPost[ModelConstants.bookedUuid] == null;
  }
}

class UserDrawerWidget extends StatelessWidget {
  const UserDrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uuid = AuthController.authController.userModel.value!.uuid!;

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //For creating post
          TextButton(
            child: const Text("Create adoption post"),
            onPressed: () {
              log("Go to adoption post");
              Get.toNamed(CreateAdoptionPostView.id);
            },
          ),
          TextButton(
            child: const Text("View adoption history"),
            onPressed: () {
              log("Go to adoption post");
              Get.toNamed(ViewPostHistory.id);
            },
          ),
          FutureBuilder(
              future: FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.userCollection).doc(uuid).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var userData = snapshot.data!;
                  AuthController.authController.isAdmin.value = userData[ModelConstants.role] == RoleConstants.roleIsAdmin;
                  return AuthController.authController.isAdmin.value
                      ? TextButton(
                          onPressed: () {
                            Get.toNamed(AdminPanelView.id);
                          },
                          child: const Text("Admin panel"))
                      : Container();
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}
