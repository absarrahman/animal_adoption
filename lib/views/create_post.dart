import 'dart:developer';

import 'package:animal_adoption/controllers/post_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAdoptionPostView extends StatelessWidget {
  const CreateAdoptionPostView({Key? key}) : super(key: key);

  static const String id = '/createPost';

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              final results = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.image,
              );

              if (results == null) {
                Get.dialog(const Text("Image not selected"));
                return;
              }
              final bytes = results.files.single.bytes;
              final fileName = results.files.single.name;

              log("Bytes is $bytes");
              log("FileName is $fileName");
              postController.uploadImageFile(bytes: bytes!, fileName: fileName);
            },
            child: const Text("Upload")),
      ),
    );
  }
}
