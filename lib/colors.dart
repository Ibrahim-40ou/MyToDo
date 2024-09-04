import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controllers/theme_controller.dart';

class MyColors {
  final ThemeController themeController = Get.find();

  Color get background => themeController.isDarkMode.value
      ? const Color(0xFF05040B)
      : const Color(0xFFF5F4FB);

  Color get text => themeController.isDarkMode.value
      ? const Color(0xFFF1F1F9)
      : const Color(0xFF06060E);

  Color get main => const Color(0xFF332AD5);

  Color get secondary => themeController.isDarkMode.value
      ? const Color(0xFF110E71)
      : const Color(0xFF918EF1);

  Color get accent => themeController.isDarkMode.value
      ? const Color(0xFF1106EA)
      : const Color(0xFF2115F9);

  Color get red => themeController.isDarkMode.value
      ? const Color(0xFFDB0000)
      : const Color(0xFFFF0000);

  Color get grey => const Color(0xFF717171);
}
