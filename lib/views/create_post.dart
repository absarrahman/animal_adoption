import 'dart:developer';

import 'package:animal_adoption/controllers/post_controller.dart';
import 'package:animal_adoption/views/widgets/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class CreateAdoptionPostView extends StatelessWidget {
  const CreateAdoptionPostView({Key? key}) : super(key: key);

  static const String id = '/createPost';

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Post Name
            TextField(
              decoration: const InputDecoration(hintText: "Post name"),
              onChanged: (val) {
                postController.postName.value = val;
              },
            ),
            // Post description
            SizedBox(
              height: Get.height * 0.5,
              child: TextField(
                maxLines: 99999999,
                decoration: const InputDecoration(hintText: "Post description"),
                onChanged: (val) {
                  postController.postDescription.value = val;
                },
              ),
            ),
            // Animal type
            TextField(
              decoration: const InputDecoration(hintText: "Animal type"),
              onChanged: (val) {
                postController.animalType.value = val;
              },
            ),
            Obx(() {
              return TextButton(
                onPressed: () async {
                  final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.image,
                  );

                  if (results == null) {
                    return;
                  }
                  final bytes = results.files.single.bytes;
                  final fileName = results.files.single.name;
                  postController.fileName.value = fileName;
                  postController.imageBytes = bytes!;

                  log("Bytes is $bytes");
                  log("FileName is $fileName");
                },
                child: Text(postController.fileName.value.isEmpty ? "Select file" : postController.fileName.value),
              );
            }),
            ElevatedButton(
                onPressed: () async {
                  if (postController.fileName.value.isEmpty) {
                    Get.snackbar("Image not selected", "Please select an image before uploading");
                  } else if (postController.postDescription.isEmpty && postController.postName.isEmpty && postController.animalType.isEmpty) {
                    Get.snackbar("Failed to post", "Please fill up all the fields");
                  } else {
                    CommonWidgets.loadingWidget();
                    await postController.createPost();
                    Get.snackbar("Congratulations", "Post created successfully");
                    Get.offNamed(HomeView.id);
                  }
                },
                child: const Text("Post adoption")),
          ],
        ),
      ),
    );
  }
}
