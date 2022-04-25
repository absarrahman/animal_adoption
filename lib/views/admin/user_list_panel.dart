import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/string_constants.dart';
import '../../controllers/auth_controller.dart';
import '../../services/firebase_api.dart';

class UserPanelListView extends StatelessWidget {
  const UserPanelListView({Key? key}) : super(key: key);

  static const String id = '/userPanelList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AuthController.authController.isAdmin.value
            ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.userCollection).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List userList = snapshot.data!.docs.toList();
                    return ListView.builder(
                      itemBuilder: ((context, index) {
                        var user = userList[index];
                        return Visibility(
                          visible: user[ModelConstants.role] == RoleConstants.user,
                          child: ListTile(
                            leading: const Icon(Icons.people),
                            title: Text("${user[ModelConstants.email]}"),
                            trailing: IconButton(
                              onPressed: () {
                                // Remove id
                                Get.defaultDialog(
                                  title: "Are you sure?",
                                  content: const Text("Are you sure you want to remove the user?"),
                                  confirm: ElevatedButton(
                                    onPressed: () async {
                                      await AuthController.authController.removeUser(uuid: user[ModelConstants.uuid]);
                                      Get.back();
                                    },
                                    child: const Text("Yes"),
                                  ),
                                  cancel: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("No"),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        );
                      }),
                      itemCount: userList.length,
                    );
                  } else {
                    return const Text("Failed to load");
                  }
                })
            : const Text("Unauthorized access"),
      ),
    );
  }
}
