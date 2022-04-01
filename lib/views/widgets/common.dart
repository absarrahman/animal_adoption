import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonWidgets {
  static loadingWidget() {
    Get.defaultDialog(content: const CircularProgressIndicator(), barrierDismissible: false, title: 'Loading');
  }

  static dismissLoadingWidget() {
    Get.back();
  }

  static AppBar appBar({String? title}) {
    return AppBar(
      title: RichText(
        text: TextSpan(text: title ?? 'Unknown', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
