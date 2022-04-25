import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdoptionPostWidget extends StatelessWidget {
  final String imageUrl;
  final int createdAt;
  final String animalType;
  final String postName;
  final String postID;
  const AdoptionPostWidget({
    Key? key,
    required this.imageUrl,
    required this.createdAt,
    required this.animalType,
    required this.postName,
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
          ListTile(title: Text(postName),subtitle: Text(animalType),),
          
          // SelectableText(
          //   postID,
          //   toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
          //   enableInteractiveSelection: true,
          // ),
        ],
      ),
    );
  }
}
