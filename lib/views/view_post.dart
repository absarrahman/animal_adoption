import 'dart:developer';

import 'package:animal_adoption/controllers/post_controller.dart';
import 'package:animal_adoption/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: UserPostObserveWidget(adoptionPost: adoptionPost),
                      );
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
    PostController postController = PostController.postController;
    var userRate = 0.0;
    return SizedBox(
      height: 70,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Image
            CircleAvatar(
              radius: 70,
              foregroundImage: NetworkImage(adoptionPost[ModelConstants.imageUrl]),
            ),
            const SizedBox(
              width: 20,
            ),
            //Post name
            Text(adoptionPost[ModelConstants.postName]),
            const SizedBox(
              width: 20,
            ),
            // Booked UUID
            // If book user exists, option to reject/accept, else blank/ not booked yet
            adoptionPost[ModelConstants.bookedUuid] != null
                ? FutureBuilder(
                    future: FirebaseAPI.getCollectionRef(collectionPath: FireStoreConstants.userCollection).doc(adoptionPost[ModelConstants.bookedUuid]).get(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        var userData = snapshot.data!;
                        return ElevatedButton(
                          onPressed: (() {
                            Get.defaultDialog(
                              title: "User Info",
                              cancel: adoptionPost[ModelConstants.isBooked]
                                  ? null
                                  : ElevatedButton(
                                      onPressed: () {
                                        // Set booked user to null
                                      },
                                      child: const Text("Reject")),
                              confirm: adoptionPost[ModelConstants.isBooked]
                                  ? const Text("Already assigned to the user")
                                  : ElevatedButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: "Rate the user",
                                            content: Column(
                                              children: [
                                                const Text("Share your experience with the user"),
                                                RatingBar.builder(
                                                  initialRating: 3,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    userRate = rating;
                                                    log("userRate $userRate");
                                                  },
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    // Set isBooked to true, set the value in db
                                                    log("User data ${userData.data()}");
                                                    await postController.confirmBook(
                                                        userUUID: adoptionPost[ModelConstants.bookedUuid],
                                                        newRate: userRate,
                                                        oldAverage: userData[ModelConstants.averageRate],
                                                        postID: adoptionPost[ModelConstants.uuid],
                                                        totalRateCount: userData[ModelConstants.totalRateCount]);
                                                    Get.offAllNamed(HomeView.id);
                                                  },
                                                  child: const Text("Rate"),
                                                )
                                              ],
                                            ));
                                      },
                                      child: const Text("Accept")),
                              content: Column(
                                children: [
                                  // Email
                                  Text(userData[ModelConstants.email]),
                                  // Rating
                                  // if avg rate and totalRateCount = 0, user did not adopt any animals before
                                  Text(userData[ModelConstants.totalRateCount] == 0
                                      ? "This user never booked any animals"
                                      : "User average rating: ${userData[ModelConstants.averageRate].toStringAsFixed(2)}"),
                                ],
                              ),
                            );
                          }),
                          child: const Text("Someone booked it. Tap to check"),
                        );
                      } else {
                        return const Text("Failed to retrieve data");
                      }
                    })
                : adoptionPost[ModelConstants.isBooked] == true
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Not booked yet"),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Not booked yet"),
                      ),
          ],
        ),
      ),
    );
  }
}
