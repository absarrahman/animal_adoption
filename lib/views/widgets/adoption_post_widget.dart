import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdoptionPostWidget extends StatelessWidget {
  final String imageUrl;
  final int createdAt;
  final String postDesciption;
  final String postName;
  final String userName;
  final String postID;
  const AdoptionPostWidget({
    Key? key,
    required this.imageUrl,
    required this.createdAt,
    required this.postDesciption,
    required this.postName,
    required this.userName,
    required this.postID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      color: const Color(0xffEEEDDE),
      child: Column(
        children: [
          Image.network(
            imageUrl,
            height: Get.width * 0.09,
            width: Get.width * 0.09,
          ),
          // Post name
          Text(postName),
          // Post username
          Text(userName),
          // Post description
          Text(postDesciption),
          //  POST ID
          SelectableText(
            postID,
            toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
            enableInteractiveSelection: true,
          ),
        ],
      ),
    );
  }
}
