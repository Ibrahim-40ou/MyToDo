import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo/Controllers/theme_controller.dart';
import 'package:mytodo/Widgets/text.dart';

import 'button.dart';

class MyCard extends StatelessWidget {
  final Color buttonColor;
  final String label;
  final String text;
  final Color textsColor;
  final Widget icon;
  final Function function;

  const MyCard({
    super.key,
    required this.buttonColor,
    required this.label,
    required this.text,
    required this.textsColor,
    required this.function,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (controller) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: controller.isDarkMode.value
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              spreadRadius: 4,
              blurRadius: 4,
            ),
          ],
        ),
        child: MyButton(
          buttonFunction: () {
            function();
          },
          height: 100,
          width: (Get.width - 48) / 2,
          color: buttonColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: label,
                        size: 18,
                        weight: FontWeight.w600,
                        color: textsColor,
                      ),
                      MyText(
                        text: text,
                        size: 14,
                        weight: FontWeight.normal,
                        color: textsColor,
                      ),
                    ],
                  ),
                  icon,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
