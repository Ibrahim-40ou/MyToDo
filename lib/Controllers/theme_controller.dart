import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    darkModeCheck = await SharedPreferences.getInstance();
  }

  RxBool isDarkMode =
      darkModeCheck!.getBool('isDark') == true ? true.obs : false.obs;

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());
    if (isDark) {
      darkModeCheck!.setBool('isDark', true);
    } else {
      darkModeCheck!.setBool('isDark', false);
    }
    update();
  }
}
