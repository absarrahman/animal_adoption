import 'dart:developer';

import 'package:animal_adoption/controllers/post_controller.dart';
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
            TextButton(
                onPressed: () async {
                  if (postController.fileName.value.isEmpty) {
                    Get.snackbar("Image not selected", "Please select an image before uploading");
                  } else {
                    await postController.uploadImageFile();
                    Get.snackbar("Congratulations", "Post created successfully");
                    Get.offNamed(HomeView.id);
                  }
                },
                child: const Text("Upload File")),
          ],
        ),
      ),
    );
  }
}
