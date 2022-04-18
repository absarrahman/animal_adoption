import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdoptionPostWidget extends StatelessWidget {
  final String imageUrl;
  final int createdAt;
  final String postDesciption;
  final String postName;
  final String userName;
  const AdoptionPostWidget({
    Key? key,
    required this.imageUrl,
    required this.createdAt,
    required this.postDesciption,
    required this.postName,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      color: Colors.red,
      child: Column(
        children: [
          Image.network(imageUrl,height: Get.width * 0.09, width: Get.width * 0.09,),
          Text(postName),
          Text(userName),
          Text(postDesciption)
        ],
      ),
    );
  }
}
