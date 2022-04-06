import 'package:get/get.dart';

class ResponsiveUtil {

  //Responsive widths are collected from https://stackoverflow.com/questions/21574881/responsive-design-with-media-query-screen-size
  static bool get isMobile => Get.width < 768;
  static bool get isTablet => Get.width >= 768 && Get.width < 992;
  static bool get isDesktop => Get.width >= 992;
}
