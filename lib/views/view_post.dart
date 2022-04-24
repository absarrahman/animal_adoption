import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/string_constants.dart';
import '../services/firebase_api.dart';

class ViewPostHistory extends StatelessWidget {
  const ViewPostHistory({Key? key}) : super(key: key);
  static const String id = '/view_post_history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.adoptionPosts)
                .where('userUuid', isEqualTo: FirebaseAPI.firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log(FirebaseAPI.firebaseAuth.currentUser!.uid);
                List adoptionPostList = snapshot.data!.docs.toList();
                log("${adoptionPostList.length}");
                return ListView.builder(
                    itemCount: adoptionPostList.length,
                    itemBuilder: (context, index) {
                      var adoptionPost = adoptionPostList[index].data();
                      return UserPostObserveWidget(adoptionPost: adoptionPost);
                    });
              } else if (snapshot.hasError) {
                return const Text("Something went wrong");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else {
                return const Text("Please try again");
              }
            }),
      ),
    );
  }
}

class UserPostObserveWidget extends StatelessWidget {
  const UserPostObserveWidget({
    Key? key,
    required this.adoptionPost,
  }) : super(key: key);

  final Map<String, dynamic> adoptionPost;

  @override
  Widget build(BuildContext context) {
    return Text(adoptionPost.toString());
  }
}
